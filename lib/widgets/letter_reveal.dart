import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Sits right after the last video in the feed. Uses the exact same
/// scroll-visibility approach as VideoFeedItem, so scrolling down to it
/// triggers the same fade + scale + slide entrance — it's the "last
/// video" in the feed, just with a letter instead of footage.
class LetterReveal extends StatefulWidget {
  final String text;
  final double height;
  final ScrollController scrollController;

  const LetterReveal({
    super.key,
    required this.text,
    required this.height,
    required this.scrollController,
  });

  @override
  State<LetterReveal> createState() => _LetterRevealState();
}

class _LetterRevealState extends State<LetterReveal> {
  double _visibleFraction = 0;
  DateTime _lastVisibilityCheck = DateTime.fromMillisecondsSinceEpoch(0);
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
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
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

    return RepaintBoundary(
      child: Transform.translate(
        offset: Offset(0, slide),
        child: Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            child: Container(
              height: widget.height,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(28, 36, 28, 36),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: AppColors.heroGradient,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite, color: Colors.white, size: 30),
                  const SizedBox(height: 18),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        widget.text.trim(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 15, height: 1.7, color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
