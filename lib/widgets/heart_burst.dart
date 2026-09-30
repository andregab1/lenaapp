import 'dart:math';
import 'package:flutter/material.dart';

/// Wrap any widget with this to get an Instagram-style "double tap to
/// like" burst of floating hearts at the tap position.
class HeartBurst extends StatefulWidget {
  final Widget child;
  const HeartBurst({super.key, required this.child});

  @override
  State<HeartBurst> createState() => _HeartBurstState();
}

class _FloatingHeart {
  final Offset origin;
  final double dx;
  final double size;
  final double rotation;
  final int id;
  _FloatingHeart({required this.origin, required this.dx, required this.size, required this.rotation, required this.id});
}

class _HeartBurstState extends State<HeartBurst> {
  final List<_FloatingHeart> _hearts = [];
  int _nextId = 0;
  final Random _random = Random();

  void _spawn(Offset position) {
    final rnd = _random;
    for (var i = 0; i < 7; i++) {
      final heart = _FloatingHeart(
        origin: position,
        dx: (rnd.nextDouble() - 0.5) * 90,
        size: 18 + rnd.nextDouble() * 22,
        rotation: (rnd.nextDouble() - 0.5) * 0.8,
        id: _nextId++,
      );
      setState(() => _hearts.add(heart));
      Future.delayed(Duration(milliseconds: 900 + rnd.nextInt(300)), () {
        if (!mounted) return;
        setState(() => _hearts.removeWhere((h) => h.id == heart.id));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: (details) => _spawn(details.localPosition),
      onDoubleTap: () {},
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          widget.child,
          ..._hearts.map((h) => _AnimatedHeart(key: ValueKey(h.id), heart: h)),
        ],
      ),
    );
  }
}

class _AnimatedHeart extends StatefulWidget {
  final _FloatingHeart heart;
  const _AnimatedHeart({super.key, required this.heart});

  @override
  State<_AnimatedHeart> createState() => _AnimatedHeartState();
}

class _AnimatedHeartState extends State<_AnimatedHeart> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        final riseUp = -120 * Curves.easeOut.transform(t);
        final drift = widget.heart.dx * Curves.easeOut.transform(t);
        final fadeOpacity = t < 0.75 ? 1.0 : (1 - (t - 0.75) / 0.25);
        final scale = t < 0.25 ? (t / 0.25) : 1.0;
        return Positioned(
          left: widget.heart.origin.dx - widget.heart.size / 2 + drift,
          top: widget.heart.origin.dy - widget.heart.size / 2 + riseUp,
          child: Opacity(
            opacity: fadeOpacity.clamp(0.0, 1.0).toDouble(),
            child: Transform.scale(
              scale: scale,
              child: Transform.rotate(
                angle: widget.heart.rotation,
                child: Icon(Icons.favorite, color: Colors.pinkAccent, size: widget.heart.size),
              ),
            ),
          ),
        );
      },
    );
  }
}
