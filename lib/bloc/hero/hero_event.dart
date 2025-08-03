import 'package:equatable/equatable.dart';
import 'package:video_player/video_player.dart';

abstract class HeroEvent extends Equatable {
  const HeroEvent();

  @override
  List<Object?> get props => [];
}

class InitializeHero extends HeroEvent {
  const InitializeHero();
}

class InitializeVideo extends HeroEvent {
  const InitializeVideo();
}

class VideoInitialized extends HeroEvent {
  final VideoPlayerController controller;

  const VideoInitialized(this.controller);

  @override
  List<Object?> get props => [controller];
}

class VideoError extends HeroEvent {
  final String error;

  const VideoError(this.error);

  @override
  List<Object?> get props => [error];
}

class StartAnimations extends HeroEvent {
  const StartAnimations();
}

class HeroVisibilityChanged extends HeroEvent {
  final bool isVisible;

  const HeroVisibilityChanged(this.isVisible);

  @override
  List<Object?> get props => [isVisible];
}
