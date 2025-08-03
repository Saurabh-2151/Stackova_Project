import 'package:equatable/equatable.dart';
import 'package:video_player/video_player.dart';

abstract class HeroState extends Equatable {
  const HeroState();

  @override
  List<Object?> get props => [];
}

class HeroInitial extends HeroState {
  const HeroInitial();
}

class HeroLoading extends HeroState {
  const HeroLoading();
}

class HeroLoaded extends HeroState {
  final VideoPlayerController? videoController;
  final bool isVideoInitialized;
  final bool showFallback;
  final bool isVisible;
  final bool animationsStarted;

  const HeroLoaded({
    this.videoController,
    required this.isVideoInitialized,
    required this.showFallback,
    required this.isVisible,
    required this.animationsStarted,
  });

  @override
  List<Object?> get props => [
    videoController,
    isVideoInitialized,
    showFallback,
    isVisible,
    animationsStarted,
  ];

  HeroLoaded copyWith({
    VideoPlayerController? videoController,
    bool? isVideoInitialized,
    bool? showFallback,
    bool? isVisible,
    bool? animationsStarted,
  }) {
    return HeroLoaded(
      videoController: videoController ?? this.videoController,
      isVideoInitialized: isVideoInitialized ?? this.isVideoInitialized,
      showFallback: showFallback ?? this.showFallback,
      isVisible: isVisible ?? this.isVisible,
      animationsStarted: animationsStarted ?? this.animationsStarted,
    );
  }
}

class HeroError extends HeroState {
  final String message;

  const HeroError(this.message);

  @override
  List<Object?> get props => [message];
}
