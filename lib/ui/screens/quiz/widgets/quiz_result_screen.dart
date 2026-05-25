import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../quiz_screen.dart';

class QuizResultScreen extends StatelessWidget {
  final int total;
  final int correct;
  final List<QuizQuestion> questions;
  final List<bool> results;

  const QuizResultScreen({
    super.key,
    required this.total,
    required this.correct,
    required this.questions,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final double percentage = total == 0 ? 0 : correct / total;
    Color scoreColor = Colors.green;
    String message = 'Great job! 🎉';
    
    if (percentage < 0.5) {
      scoreColor = Colors.red;
      message = 'Keep practicing! 📚';
    } else if (percentage < 0.7) {
      scoreColor = Colors.orange;
      message = 'Good effort! 💪';
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: CircularProgressIndicator(
                            value: percentage,
                            strokeWidth: 12,
                            backgroundColor: colorScheme.surfaceContainerHighest,
                            valueColor: AlwaysStoppedAnimation(scoreColor),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$correct',
                              style: textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: scoreColor,
                              ),
                            ),
                            Text(
                              'out of $total',
                              style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    if (correct < total) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Review Mistakes',
                          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...List.generate(questions.length, (index) {
                        if (results[index]) return const SizedBox.shrink();
                        final q = questions[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      q.word.word,
                                      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      q.correctAnswer,
                                      style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.error_outline, color: Colors.red),
                            ],
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => context.pop(),
                  child: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
