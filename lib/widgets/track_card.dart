import 'package:flutter/material.dart';
import '../models/track.dart';
import '../theme/app_theme.dart';
import 'track_art.dart';

class TrackCard extends StatelessWidget {
  final Track track;
  final VoidCallback onTap;

  const TrackCard({super.key, required this.track, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'trackHero-${track.audioAsset}',
              child: TrackArt(track: track, size: 140, borderRadius: 8),
            ),
            const SizedBox(height: 10),
            Text(
              track.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.text),
            ),
            const SizedBox(height: 2),
            Text(
              track.artist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: AppColors.textDim),
            ),
          ],
        ),
      ),
    );
  }
}
