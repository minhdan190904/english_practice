import 'package:flutter/material.dart';

/// Widget shown when quiz is completed — displays score with animations.
class QuizResultWidget extends StatefulWidget {
  final int correctCount;
  final int totalQuestions;

  const QuizResultWidget({
    super.key,
    required this.correctCount,
    required this.totalQuestions,
  });

  @override
  State<QuizResultWidget> createState() => _QuizResultWidgetState();
}

class _QuizResultWidgetState extends State<QuizResultWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final percentage = widget.totalQuestions > 0
        ? (widget.correctCount / widget.totalQuestions * 100).round()
        : 0;
    final isPerfect = percentage == 100;
    final isGood = percentage >= 70;

    String emoji;
    String message;
    Color accentColor;

    if (isPerfect) {
      emoji = '🏆';
      message = 'Xuất sắc! Hoàn hảo!';
      accentColor = Colors.amber;
    } else if (isGood) {
      emoji = '🎉';
      message = 'Làm tốt lắm!';
      accentColor = Colors.green;
    } else if (percentage >= 50) {
      emoji = '💪';
      message = 'Khá tốt, cố gắng thêm!';
      accentColor = Colors.blue;
    } else {
      emoji = '📚';
      message = 'Cần ôn lại bài nhé!';
      accentColor = Colors.orange;
    }

    return FadeTransition(
      opacity: _fadeIn,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Emoji with glow
              ScaleTransition(
                scale: _scale,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accentColor.withValues(alpha: 0.1),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.2),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 64),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Score
              Text(
                '$percentage%',
                style: textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: accentColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.correctCount}/${widget.totalQuestions} câu đúng',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 40),

              // Done button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text(
                    'Hoàn thành',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
