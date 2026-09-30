import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import '../models/track.dart';

/// Shared playback state — every track plays real audio through
/// [AudioPlayer].
class PlayerController extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Track? _current;
  bool _playing = false;
  double _elapsedSeconds = 0;

  PlayerController() {
    // IMPORTANT: audioplayers defaults to a "low latency" playback path
    // meant for short sound effects. For longer audio (full songs), that
    // mode is the classic cause of crackling / sped-up playback on
    // Android. mediaPlayer mode is the correct one for music.
    _audioPlayer.setPlayerMode(PlayerMode.mediaPlayer);
    _audioPlayer.setReleaseMode(ReleaseMode.stop);

    _audioPlayer.onPositionChanged.listen((pos) {
      _elapsedSeconds = pos.inMilliseconds / 1000;
      notifyListeners();
    });
    _audioPlayer.onPlayerComplete.listen((_) {
      _playing = false;
      _elapsedSeconds = 0;
      notifyListeners();
    });
  }

  Track? get current => _current;
  bool get isPlaying => _playing;
  double get elapsedSeconds => _elapsedSeconds;

  double get progress {
    if (_current == null || _current!.durationSeconds == 0) return 0;
    final value = _elapsedSeconds / _current!.durationSeconds;
    if (value < 0) return 0;
    if (value > 1) return 1;
    return value;
  }

  Future<void> playTrack(Track track) async {
    final isNewTrack = _current != track;
    _current = track;
    _playing = true;
    if (isNewTrack) {
      _elapsedSeconds = 0;
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(track.audioAsset));
    } else {
      await _audioPlayer.resume();
    }
    notifyListeners();
  }

  Future<void> togglePlay() async {
    if (_current == null) return;
    _playing = !_playing;
    if (_playing) {
      await _audioPlayer.resume();
    } else {
      await _audioPlayer.pause();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
