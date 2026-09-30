import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../theme/app_theme.dart';
import 'heart_burst.dart';

/// A video that lives inside the same vertical scroll as the rest of the
/// Home screen (not a separate swipeable feed — just a regular list item,
/// sized to take up almost the whole screen so only one is comfortably
/// visible at a time).
///
/// Loading is LAZY: the video file is only decoded once it's about to
/// scroll into view (not all at once when the Home screen opens) — this
/// is what keeps playback smooth on a real phone instead of every video
/// fighting for the decoder at the same time.
///
/// As it scrolls into view it fades + scales in, a romantic phrase flashes
/// in and out during that transition, and it starts playing automatically
/// once it's mostly visible; scrolling it away pauses it.
class VideoFeedItem extends StatefulWidget {
  final String asset;
  final String phrase;
  final double height;
  final ScrollController scrollController;

  const VideoFeedItem({
    super.key,
    required this.asset,
    required this.phrase,
    required this.height,
    required this.scrollController,
  });

  @override
  State<VideoFeedItem> createState() => _VideoFeedItemState();
}

class _VideoFeedItemState extends State<VideoFeedItem> {
  VideoPlayerController? _controller;
  bool _initStarted = false;
  bool _ready = false;
  bool _muted = true;
  bool _finished = false;
  double _visibleFraction = 0;
  DateTime _lastVisibilityCheck = DateTime.fromMillisecondsSinceEpoch(0);

  static const double _playThreshold = 0.55;
  // Start decoding a little before the video is actually visible, so it's
  // ready by the time it's fully on screen — but NOT all of them at once.
  static const double _preloadThreshold = 0.02;
  // Only recompute visibility ~20x/second during scroll instead of on
  // every single scroll pixel — recalculating for every video item on
  // every scroll frame is what was choking playback.
  static const Duration _throttle = Duration(milliseconds: 50);

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateVisibility());
  }

  void _onScroll() {
    final now = DateTime.now();
    if (now.difference(_lastVisibilityCheck) < _throttle) return;
    _lastVisibilityCheck = now;
    _updateVisibility();
  }

  void _ensureInitialized() {
    if (_initStarted) return;
    _initStarted = true;
    final c = VideoPlayerController.asset(widget.asset)
      ..setLooping(false)
      ..setVolume(0);
    _controller = c;
    c.addListener(_onVideoTick);
    c.initialize().then((_) {
      if (!mounted) return;
      setState(() => _ready = true);
      _updateVisibility();
    });
  }

  void _onVideoTick() {
    if (!mounted || !_ready || _controller == null) return;
    final value = _controller!.value;
    if (value.duration > Duration.zero && value.position >= value.duration) {
      if (!_finished) setState(() => _finished = true);
    }
  }

  void _updateVisibility() {
    if (!mounted) return;
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.attached) return;

    final size = renderObject.size;
    if (size.height == 0) return;
    final topLeft = renderObject.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;

    final top = topLeft.dy;
    final bottom = top + size.height;
    final visibleTop = top.clamp(0.0, screenHeight);
    final visibleBottom = bottom.clamp(0.0, screenHeight);
    final visibleHeight = (visibleBottom - visibleTop).clamp(0.0, size.height);
    final fraction = visibleHeight / size.height;

    if ((fraction - _visibleFraction).abs() > 0.01) {
      setState(() => _visibleFraction = fraction);
    }

    if (fraction > _preloadThreshold) {
      _ensureInitialized();
    }

    if (_ready && _controller != null) {
      final shouldPlay = fraction >= _playThreshold && !_finished;
      if (shouldPlay && !_controller!.value.isPlaying) {
        _controller!.play();
      } else if (!shouldPlay && _controller!.value.isPlaying) {
        _controller!.pause();
      }
    }
  }

  void _replay() {
    _controller?.seekTo(Duration.zero);
    _controller?.play();
    setState(() => _finished = false);
  }

  void _toggleMute() {
    if (_controller == null) return;
    setState(() {
      _muted = !_muted;
      _controller!.setVolume(_muted ? 0 : 1);
    });
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _controller?.removeListener(_onVideoTick);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double vf = _visibleFraction;
    if (vf < 0) vf = 0;
    if (vf > 1) vf = 1;
    final t = Curves.easeOut.transform(vf);
    final opacity = t;
    final scale = 0.90 + 0.10 * t;
    final slide = (1 - t) * 24;

    // Phrase appears WHILE scrolling (partial visibility) and fades away
    // once the video settles fully into view or fully leaves — a simple
    // parabola peaking at vf = 0.5 gives exactly that "during the
    // transition" feel without needing a separate animation controller.
    final phraseOpacity = 4 * vf * (1 - vf);

    final controller = _controller;
    final ready = _ready && controller != null;

    return RepaintBoundary(
      child: Transform(
        transform: Matrix4.identity()
          ..translate(0.0, slide)
          ..scale(scale, scale),
        alignment: Alignment.center,
        child: Opacity(
          opacity: opacity,
          child: SizedBox(
            height: widget.height,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: ready
                  ? HeartBurst(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(color: Colors.black),
                          FittedBox(
                            fit: controller.value.size.width > controller.value.size.height
                                ? BoxFit.contain
                                : BoxFit.cover,
                            child: SizedBox(
                              width: controller.value.size.width,
                              height: controller.value.size.height,
                              child: VideoPlayer(controller),
                            ),
                          ),
                          IgnorePointer(
                            child: Opacity(
                              opacity: phraseOpacity,
                              child: Container(
                                color: Colors.black.withOpacity(0.25 * phraseOpacity),
                                alignment: Alignment.center,
                                child: Text(
                                  widget.phrase,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                    shadows: [Shadow(color: Colors.black54, blurRadius: 16, offset: Offset(0, 2))],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 10,
                            bottom: 10,
                            child: GestureDetector(
                              onTap: _toggleMute,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(color: Colors.black.withOpacity(0.55), shape: BoxShape.circle),
                                child: Icon(_muted ? Icons.volume_off : Icons.volume_up, color: Colors.white, size: 18),
                              ),
                            ),
                          ),
                          if (_finished)
                            Positioned.fill(
                              child: Container(
                                color: Colors.black.withOpacity(0.45),
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  onTap: _replay,
                                  child: Container(
                                    width: 76,
                                    height: 76,
                                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                    child: const Icon(Icons.replay, color: Colors.black, size: 42),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                  : Container(
                      color: AppColors.card,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(color: AppColors.green),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
