import 'package:flutter/material.dart';
import '../controllers/player_controller.dart';
import '../models/track.dart';
import '../theme/app_theme.dart';
import '../widgets/track_row.dart';
import 'now_playing_screen.dart';

class PlaylistScreen extends StatelessWidget {
  final Playlist playlist;
  final PlayerController controller;

  const PlaylistScreen({super.key, required this.playlist, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 56)),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: _CoverArt(playlist: playlist),
                    ),
                    Text(
                      playlist.title,
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.text),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${playlist.meta} • ${playlist.tracks.length} faixas',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDim),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Row(
                        children: [
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              if (playlist.tracks.isNotEmpty) {
                                controller.playTrack(playlist.tracks.first);
                                openNowPlaying(context, controller);
                              }
                            },
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
                              child: const Icon(Icons.play_arrow, color: Colors.black, size: 28),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final track = playlist.tracks[i];
                    return AnimatedBuilder(
                      animation: controller,
                      builder: (_, __) => TrackRow(
                        track: track,
                        isCurrent: controller.current == track,
                        onTap: () {
                          controller.playTrack(track);
                          openNowPlaying(context, controller);
                        },
                      ),
                    );
                  },
                  childCount: playlist.tracks.length,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 140)),
            ],
          ),
          Positioned(
            top: 14,
            left: 14,
            child: SafeArea(
              bottom: false,
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.6),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, size: 18, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoverArt extends StatelessWidget {
  final Playlist playlist;
  const _CoverArt({required this.playlist});

  @override
  Widget build(BuildContext context) {
    const size = 180.0;
    if (playlist.coverAssets.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(playlist.coverAssets.first, width: size, height: size, fit: BoxFit.cover),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: size,
        height: size,
        child: GridView.count(
          crossAxisCount: 2,
          physics: const NeverScrollableScrollPhysics(),
          children: playlist.coverAssets
              .map((a) => Image.asset(a, fit: BoxFit.cover))
              .toList(),
        ),
      ),
    );
  }
}
