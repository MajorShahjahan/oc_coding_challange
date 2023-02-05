// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiddinx_app_streaming/domain/models/products/product.dart';
import 'package:kiddinx_app_streaming/presentation/screens/kids_view/audio/views/audio/bloc/audio_view_cubit.dart';
import 'package:kiddinx_app_streaming/presentation/screens/kids_view/shared_screens/no_data_screen/no_data_screen.dart';
import 'package:kiddinx_app_streaming/presentation/shared/components/custom_progress_indicator/custom_progress_indicator.dart';
import 'package:kiddinx_app_streaming/presentation/shared/components/text/custom_text.dart';
import 'package:kiddinx_app_streaming/presentation/shared/elements/kids_background/kids_background.dart';
import 'package:kiddinx_app_streaming/presentation/shared/elements/tiles/character_tile/character_tile.dart';
import 'package:kiddinx_app_streaming/presentation/shared/elements/tiles/media_tile_m/media_tile_m.dart';
import 'package:kiddinx_app_streaming/presentation/shared/enums/media_tile_types.dart';
import 'package:kiddinx_app_streaming/presentation/shared/layouts/horizontal_list_layout/horizontal_list_layout.dart';
import 'package:kiddinx_app_streaming/presentation/shared/layouts/kids_list_layout/kids_list_layout.dart';
import 'package:kiddinx_app_streaming/presentation/shared/strings.dart';
import 'package:kiddinx_app_streaming/presentation/shared/style/icons.dart';
import 'package:kiddinx_app_streaming/presentation/shared/utils/string_utils.dart';

class AudioScreen extends StatelessWidget {
  const AudioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AudioViewCubit(),
      child: BlocBuilder<AudioViewCubit, AudioViewState>(
        builder: (context, state) {
          if (state is AudioViewError) {
            return Center(
              child: CustomText.body(state.errorMessage),
            );
          }
          if (state is AudioViewLoaded) {
            if (state.wrappedCharacters.isEmpty) {
              return KidsBackground(
                child: KidsNoDataScreen(
                  imageUrl: StringUtils.getAvatarAssetPathByCharacterId(1),
                  title: KidsCharacterOverviewScreenStrings.noAudioTitle,
                  subtitle: KidsCharacterOverviewScreenStrings.noDataSubtitle,
                ),
              );
            }
            return KidsListLayout(
              list: [
                if (state.lastPlayed.isNotEmpty)
                  _getLastPlayed(context, state.lastPlayed),
                ..._getCharacters(context, state.wrappedCharacters),
              ],
            );
          }
          return const CustomProgressIndicator.circular();
        },
      ),
    );
  }

  HorizontalListLayout _getLastPlayed(
    BuildContext context,
    List<Product> products,
  ) {
    return HorizontalListLayout(
      leading: const CharacterTile(
        characterName: StartScreenStrings.subHeaderLastPlayedText,
        icon: KiddinxIcons.headphones,
      ),
      tiles: products
          .map(
            (e) => MediaTileM.title(
              product: e,
              title: e.name,
              type: MediaTileMType.FAVORITES,
              onTap: () =>
                  BlocProvider.of<AudioViewCubit>(context).openPlayer(e),
            ),
          )
          .toList(),
    );
  }

  List<HorizontalListLayout> _getCharacters(
    BuildContext context,
    List<AudioCharacterWrapper> wrappedCharacters,
  ) {
    return wrappedCharacters
        .map(
          (wrappedCharacter) => HorizontalListLayout(
            tiles: wrappedCharacter.titles
                .map(
                  (e) => MediaTileM.title(
                    product: e,
                    title: e.name,
                    type: MediaTileMType.FAVORITES,
                    onTap: () =>
                        BlocProvider.of<AudioViewCubit>(context).openPlayer(e),
                  ),
                )
                .toList(),
            leading: CharacterTile(
              characterName: wrappedCharacter.character.name,
              assetUrl: wrappedCharacter.character.avatarUrl,
            ),
          ),
        )
        .toList();
  }
}
