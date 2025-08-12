import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'hero_event.dart';
import 'hero_state.dart';

class HeroBloc extends Bloc<HeroEvent, HeroState> {
  late AnimationController fadeController;
  late AnimationController slideController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;
  VideoPlayerController? _videoController;

  HeroBloc() : super(const HeroInitial()) {
    on<InitializeHero>(_onInitializeHero);
    on<InitializeVideo>(_onInitializeVideo);
    on<VideoInitialized>(_onVideoInitialized);
    on<VideoError>(_onVideoError);
    on<StartAnimations>(_onStartAnimations);
    on<HeroVisibilityChanged>(_onHeroVisibilityChanged);
  }

  void initializeAnimationControllers(TickerProvider vsync) {
    fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: vsync,
    );

    slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: vsync,
    );

    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: fadeController,
      curve: Curves.easeOut,
    ));

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: slideController,
      curve: Curves.easeOut,
    ));
  }

  void _onInitializeHero(
    InitializeHero event,
    Emitter<HeroState> emit,
  ) {
    emit(const HeroLoading());
    add(const InitializeVideo());
  }

  void _onInitializeVideo(
    InitializeVideo event,
    Emitter<HeroState> emit,
  ) async {
    try {
      _videoController = VideoPlayerController.asset('assets/homeVedio.mp4');
      
      // Add timeout for video initialization
      await _videoController!.initialize().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Video initialization timeout');
        },
      );
      
      await _videoController!.setLooping(true);
      await _videoController!.setVolume(0.0);
      await _videoController!.play();

      add(VideoInitialized(_videoController!));
    } catch (e) {
      // Log error for debugging
      print('Video initialization error: $e');
      add(VideoError(e.toString()));
    }
  }

  void _onVideoInitialized(
    VideoInitialized event,
    Emitter<HeroState> emit,
  ) {
    emit(HeroLoaded(
      videoController: event.controller,
      isVideoInitialized: true,
      showFallback: false,
      isVisible: true,
      animationsStarted: false,
    ));

    add(const StartAnimations());
  }

  void _onVideoError(
    VideoError event,
    Emitter<HeroState> emit,
  ) {
    emit(const HeroLoaded(
      videoController: null,
      isVideoInitialized: false,
      showFallback: true,
      isVisible: true,
      animationsStarted: false,
    ));

    add(const StartAnimations());
  }

  void _onStartAnimations(
    StartAnimations event,
    Emitter<HeroState> emit,
  ) {
    fadeController.forward();
    slideController.forward();

    if (state is HeroLoaded) {
      final currentState = state as HeroLoaded;
      emit(currentState.copyWith(animationsStarted: true));
    }
  }

  void _onHeroVisibilityChanged(
    HeroVisibilityChanged event,
    Emitter<HeroState> emit,
  ) {
    if (state is HeroLoaded) {
      final currentState = state as HeroLoaded;
      emit(currentState.copyWith(isVisible: event.isVisible));
    }
  }

  @override
  Future<void> close() {
    _videoController?.dispose();
    fadeController.dispose();
    slideController.dispose();
    return super.close();
  }
}
