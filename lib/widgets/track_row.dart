import 'package:flutter/material.dart';
import '../models/track.dart';
import '../theme/app_theme.dart';
import 'track_art.dart';

class TrackRow extends StatelessWidget {
  final Track track;
  final bool isCurrent;
  final VoidCallback onTap;

  const TrackRow({
    super.key,
    required this.track,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            TrackArt(track: track, size: 44),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    track.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isCurrent ? AppColors.green : AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    track.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: AppColors.textDim),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              track.durationLabel,
              style: const TextStyle(fontSize: 12, color: AppColors.textDim),
            ),
          ],
        ),
      ),
    );
  }
}
