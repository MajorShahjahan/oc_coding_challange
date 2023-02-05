import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiddinx_app_streaming/data/shared/exceptions/objectbox_read_exception.dart';
import 'package:kiddinx_app_streaming/domain/models/enums/audio_playback_type.dart';
import 'package:kiddinx_app_streaming/domain/models/products/audio_product.dart';
import 'package:kiddinx_app_streaming/domain/models/products/character.dart';
import 'package:kiddinx_app_streaming/domain/models/products/product.dart';
import 'package:kiddinx_app_streaming/domain/models/profiles/profile.dart';
import 'package:kiddinx_app_streaming/domain/services/app_event_notification/app_event_notification_service.dart';
import 'package:kiddinx_app_streaming/presentation/handler/shared_preferences/i_shared_preferences_service.dart';
import 'package:kiddinx_app_streaming/presentation/handler/snackbar/i_snackbar_service.dart';
import 'package:kiddinx_app_streaming/presentation/shared/interfaces/i_app_event_notification_service.dart';
import 'package:kiddinx_app_streaming/presentation/shared/interfaces/i_product_service.dart';
import 'package:kiddinx_app_streaming/presentation/shared/interfaces/i_profile_service.dart';
import 'package:kiddinx_app_streaming/presentation/shared/locator.dart';
import 'package:kiddinx_app_streaming/presentation/shared/strings.dart';
import 'package:loggy/loggy.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'audio_view_state.dart';

class AudioViewCubit extends Cubit<AudioViewState> {
  AudioViewCubit() : super(const AudioViewState()) {
    _init();
  }

  final _audioCharacter = <int, AudioCharacterWrapper>{};
  List<AudioProduct> _lastPlayed = [];
  List<AudioProduct> _allAudioProducts = [];

  final _productService = locator<IProductService>();
  final _profileService = locator<IProfileService>();
  final _sharedPrefsService = locator<ISharedPreferencesService>();
  final _snackBarService = locator<ISnackBarService>();
  final _appEventNotificationService = locator<IAppEventNotificationService>();

  Future<void> _init() async {
    await _loadData(false, calledFromInit: true);
    await _loadData(true);
    await _listenAppEvents();
  }

  Future<void> _listenAppEvents() async {
    _appEventNotificationService.stream.listen((event) {
      if (event is PlaylistUpdated || event is PlaylistDeleted) {
        _loadData(false);
      }
    });
  }

  Future<void> _loadData(bool queryApi, {bool calledFromInit = false}) async {
    try {
      await _loadProducts(queryApi);
      await _generateCharacterWrapping();
      await _generateLastPlayed(queryApi);
      emit(
        AudioViewLoaded(
          lastPlayed: _lastPlayed,
          wrappedCharacters: _audioCharacter.values.toList(),
        ),
      );
    } on ObjectBoxReadException {
      _promptErrorMessage(AlertStrings.dataLoadError,
          calledFromInit: calledFromInit);
    } catch (ex, st) {
      await Sentry.captureException(ex, stackTrace: st);
      logError(ex, StackTrace.current);
      _promptErrorMessage(AlertStrings.dataLoadError,
          calledFromInit: calledFromInit);
    }
  }

  void _promptErrorMessage(
    String errorMessage, {
    bool calledFromInit = false,
  }) {
    if (calledFromInit) {
      emit(AudioViewError(
        errorMessage: errorMessage,
      ));
    } else {
      _snackBarService.showErrorSnackBar(
        text: errorMessage,
      );
    }
  }

  Future<void> _loadProducts(bool queryApi) async {
    _allAudioProducts.clear();
    _allAudioProducts = await _productService.getAllAudioProducts(
      queryApi: queryApi,
    );
    _allAudioProducts.sort(
      (a, b) => a.episodeId.compareTo(b.episodeId),
    );
  }

  Future<void> _generateCharacterWrapping() async {
    _audioCharacter.clear();
    for (final AudioProduct product in _allAudioProducts) {
      if (_audioCharacter.containsKey(product.series.characterId)) {
        _audioCharacter[product.series.characterId]!.titles.add(product);
      } else {
        _audioCharacter[product.series.characterId] = AudioCharacterWrapper(
          character: product.series.character,
          titles: [product],
        );
      }
    }
  }

  Future<void> _generateLastPlayed(bool queryApi) async {
    final Profile profile = await _profileService.getProfileById(
      _sharedPrefsService.activeProfileId,
      fetchApi: queryApi,
    );
    _lastPlayed = profile.getLastPlayed().whereType<AudioProduct>().toList();
  }

  Future<void> openPlayer(Product product) async {
    await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );

    await _appEventNotificationService.publishEvent(
      AudioPlaybackInitiated(
        playbackType: AudioPlaybackType.PRODUCT,
        playbackEntityId: product.id,
      ),
    );
  }
}

class AudioCharacterWrapper {
  AudioCharacterWrapper({
    required this.character,
    required this.titles,
  });

  Character character;
  List<AudioProduct> titles;
}
