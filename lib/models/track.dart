import 'package:flutter/material.dart';

/// A single song in the playlist. Every song has real audio plus one of
/// the couple's photos as its cover art.
class Track {
  final String title;
  final String artist;
  final int durationSeconds;

  /// Path passed to AudioPlayer's AssetSource (relative to assets root,
  /// without the leading "assets/"), e.g. 'audio/song.mp3'.
  final String audioAsset;

  /// Full asset path used with Image.asset, e.g. 'assets/images/photo1.jpg'.
  final String coverAsset;

  /// Accent color extracted from the cover photo, used to tint the Now
  /// Playing screen so each song gets its own subtle mood.
  final Color dominantColor;

  const Track({
    required this.title,
    required this.artist,
    required this.durationSeconds,
    required this.audioAsset,
    required this.coverAsset,
    required this.dominantColor,
  });

  String get durationLabel {
    final m = durationSeconds ~/ 60;
    final s = durationSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}

/// A collection of tracks shown as a playlist screen.
class Playlist {
  final String id;
  final String title;
  final String meta;
  final List<Track> tracks;

  /// One or more cover asset paths used to build the header art (a single
  /// photo, or a 2x2 collage when more than one is given).
  final List<String> coverAssets;

  const Playlist({
    required this.id,
    required this.title,
    required this.meta,
    required this.tracks,
    required this.coverAssets,
  });
}
