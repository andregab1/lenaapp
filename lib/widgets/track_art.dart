import 'package:flutter/material.dart';
import '../models/track.dart';

/// Renders a track's cover art — always one of the couple's photos now.
class TrackArt extends StatelessWidget {
  final Track track;
  final double size;
  final double borderRadius;

  const TrackArt({
    super.key,
    required this.track,
    required this.size,
    this.borderRadius = 6,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.asset(
        track.coverAsset,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
