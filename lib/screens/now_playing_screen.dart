import 'dart:ui';
import 'package:flutter/material.dart';
import '../controllers/player_controller.dart';
import '../models/track.dart';
import '../theme/app_theme.dart';
import '../widgets/heart_burst.dart';

/// Pushes the Now Playing screen on the root navigator so it covers the
/// bottom nav and mini player, with a slide-up transition.
void openNowPlaying(BuildContext context, PlayerController controller) {
  if (controller.current == null) return;
  Navigator.of(context, rootNavigator: true).push(
    PageRouteBuilder(
      opaque: true,
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (_, __, ___) => NowPlayingScreen(controller: controller),
      transitionsBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(curved),
          child: child,
        );
      },
    ),
  );
}

class NowPlayingScreen extends StatelessWidget {
  final PlayerController controller;
  const NowPlayingScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final track = controller.current;
        if (track == null) return const SizedBox.shrink();

        return Scaffold(
          backgroundColor: AppColors.surface,
          body: Stack(
            children: [
              Positioned.fill(child: _BlurredBackground(track: track)),
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_down, size: 28, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const Spacer(),
                          const Text(
                            'TOCANDO AGORA',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1, color: AppColors.textDim),
                          ),
                          const Spacer(),
                          const SizedBox(width: 44),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Hero(
                              tag: 'trackHero-${track.audioAsset}',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: HeartBurst(
                                  child: Image.asset(track.coverAsset, fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            track.title,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            track.artist,
                            style: const TextStyle(fontSize: 15, color: AppColors.textDim),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 18, 28, 6),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: controller.progress,
                              minHeight: 4,
                              backgroundColor: Colors.white24,
                              valueColor: AlwaysStoppedAnimation(track.dominantColor),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_fmt(controller.elapsedSeconds), style: const TextStyle(fontSize: 11, color: AppColors.textDim)),
                              Text(track.durationLabel, style: const TextStyle(fontSize: 11, color: AppColors.textDim)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.skip_previous, color: Colors.white70, size: 30),
                          const SizedBox(width: 34),
                          GestureDetector(
                            onTap: controller.togglePlay,
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: Icon(
                                controller.isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.black,
                                size: 32,
                              ),
                            ),
                          ),
                          const SizedBox(width: 34),
                          const Icon(Icons.skip_next, color: Colors.white70, size: 30),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static String _fmt(double seconds) {
    final s = seconds.floor();
    final m = s ~/ 60;
    final r = s % 60;
    return '$m:${r.toString().padLeft(2, '0')}';
  }
}

class _BlurredBackground extends StatelessWidget {
  final Track track;
  const _BlurredBackground({required this.track});

  @override
  Widget build(BuildContext context) {
    final base = Image.asset(track.coverAsset, fit: BoxFit.cover);

    return Stack(
      fit: StackFit.expand,
      children: [
        base,
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(color: Colors.black.withOpacity(0.55)),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                track.dominantColor.withOpacity(0.35),
                Colors.transparent,
                AppColors.surface.withOpacity(0.75),
              ],
              stops: const [0.0, 0.45, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}
