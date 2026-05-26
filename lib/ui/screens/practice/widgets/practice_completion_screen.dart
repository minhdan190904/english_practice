import 'dart:math';
import 'package:flutter/material.dart';

class PracticeCompletionScreen extends StatefulWidget {
  const PracticeCompletionScreen({super.key});

  @override
  State<PracticeCompletionScreen> createState() =>
      _PracticeCompletionScreenState();
}

class _PracticeCompletionScreenState extends State<PracticeCompletionScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late AnimationController _confettiController;

  final List<_ConfettiParticle> _particles = [];
  final _rng = Random();

  @override
  void initState() {
    super.initState();

    // Scale-in animation for the trophy
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );
    _scaleController.forward();

    // Confetti particles
    _confettiController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    for (int i = 0; i < 40; i++) {
      _particles.add(_ConfettiParticle(
        x: _rng.nextDouble(),
        speed: 0.3 + _rng.nextDouble() * 0.7,
        size: 4 + _rng.nextDouble() * 8,
        color: [
          Colors.amber,
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.purple,
          Colors.orange,
          Colors.pink,
          Colors.teal,
        ][_rng.nextInt(8)],
        delay: _rng.nextDouble() * 0.5,
      ));
    }

    _confettiController.repeat();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // Confetti layer
          AnimatedBuilder(
            animation: _confettiController,
            builder: (context, _) {
              return CustomPaint(
                painter: _ConfettiPainter(
                  particles: _particles,
                  progress: _confettiController.value,
                ),
                size: MediaQuery.of(context).size,
              );
            },
          ),

          // Content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Trophy animation
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.amber.shade300, Colors.orange.shade400],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withAlpha(80),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          '🏆',
                          style: TextStyle(fontSize: 56),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Congratulations text
                  Text(
                    'Chúc mừng!',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Bạn đã thuộc hết từ vựng! 🎉',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface.withAlpha(180),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tiếp tục luyện tập mỗi ngày để duy trì vốn từ nhé!',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withAlpha(120),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Done button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Hoàn thành ✨',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Confetti Data ────────────────────────────────────────────────────────────

class _ConfettiParticle {
  final double x;
  final double speed;
  final double size;
  final Color color;
  final double delay;

  _ConfettiParticle({
    required this.x,
    required this.speed,
    required this.size,
    required this.color,
    required this.delay,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final adjustedProgress = ((progress - p.delay) % 1.0).clamp(0.0, 1.0);
      final y = adjustedProgress * size.height * p.speed;
      final x = p.x * size.width + sin(adjustedProgress * pi * 4) * 30;
      final opacity = (1.0 - adjustedProgress).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = p.color.withAlpha((opacity * 200).toInt())
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(adjustedProgress * pi * 2);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.6),
          const Radius.circular(1),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
