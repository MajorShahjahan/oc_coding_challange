part of 'audio_view_cubit.dart';

class AudioViewState extends Equatable {
  const AudioViewState();

  @override
  List<Object?> get props => [];
}

class AudioViewInitial extends AudioViewState {
  const AudioViewInitial();
}

class AudioViewError extends AudioViewState {
  const AudioViewError({
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  List<Object?> get props => [
        errorMessage,
      ];
}

class AudioViewLoaded extends AudioViewState {
  const AudioViewLoaded({
    required this.lastPlayed,
    required this.wrappedCharacters,
  });

  final List<Product> lastPlayed;
  final List<AudioCharacterWrapper> wrappedCharacters;

  @override
  List<Object?> get props => [
        lastPlayed,
        wrappedCharacters,
      ];
}
