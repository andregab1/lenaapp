import 'package:flutter/material.dart';
import '../controllers/player_controller.dart';
import '../theme/app_theme.dart';
import 'track_art.dart';

class MiniPlayer extends StatelessWidget {
  final PlayerController controller;
  final VoidCallback onTap;

  const MiniPlayer({super.key, required this.controller, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final track = controller.current;
    if (track == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 6),
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(colors: [Color(0xFF3A3A3A), Color(0xFF282828)]),
          boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 16, offset: Offset(0, 6))],
        ),
        child: Row(
          children: [
            TrackArt(track: track, size: 40, borderRadius: 4),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.text),
                  ),
                  Text(
                    track.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: AppColors.textDim),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(controller.isPlaying ? Icons.pause : Icons.play_arrow, color: AppColors.text),
              onPressed: controller.togglePlay,
            ),
          ],
        ),
      ),
    );
  }
}
