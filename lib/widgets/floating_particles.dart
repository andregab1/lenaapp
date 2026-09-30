import 'dart:math';
import 'package:flutter/material.dart';

/// A subtle drifting field of small hearts, meant to sit behind the
/// greeting header on the Home screen. Purely decorative, ignores touch.
class FloatingParticles extends StatefulWidget {
  final int count;
  const FloatingParticles({super.key, this.count = 14});

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _Particle {
  final double x; // 0..1 fraction of width
  final double speed; // loops per cycle
  final double phase; // 0..1 start offset
  final double size;
  final double opacity;
  _Particle({required this.x, required this.speed, required this.phase, required this.size, required this.opacity});
}

class _FloatingParticlesState extends State<FloatingParticles> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    final rnd = Random(7);
    _particles = List.generate(widget.count, (_) {
      return _Particle(
        x: rnd.nextDouble(),
        speed: 0.5 + rnd.nextDouble() * 0.7,
        phase: rnd.nextDouble(),
        size: 8 + rnd.nextDouble() * 12,
        opacity: 0.12 + rnd.nextDouble() * 0.22,
      );
    });
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 18))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Stack(
                children: _particles.map((p) {
                  final t = (_controller.value * p.speed + p.phase) % 1.0;
                  final y = constraints.maxHeight * (1 - t);
                  final sway = sin((t + p.phase) * 2 * pi) * 10;
                  return Positioned(
                    left: p.x * constraints.maxWidth + sway,
                    top: y,
                    child: Opacity(
                      opacity: p.opacity,
                      child: Icon(Icons.favorite, color: Colors.white, size: p.size),
                    ),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
