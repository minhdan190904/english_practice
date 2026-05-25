import 'package:flutter/material.dart';

import '../../../../data/models/word.dart';

/// Result data for a single typing attempt.
class TypingResult {
  final Word word;
  final bool correct;
  final int stars;

  const TypingResult({
    required this.word,
    required this.correct,
    required this.stars,
  });
}

/// Result screen shown after completing a Typing Challenge.
/// Design matches FlashcardResultScreen pattern.
class TypingResultScreen extends StatelessWidget {
  final int total;
  final int totalStars;
  final int maxPossibleStars;
  final int correctCount;
  final List<TypingResult> results;
  final VoidCallback onPracticeAgain;
  final VoidCallback onBack;

  const TypingResultScreen({
    super.key,
    required this.total,
    required this.totalStars,
    required this.maxPossibleStars,
    required this.correctCount,
    required this.results,
    required this.onPracticeAgain,
    required this.onBack,
  });

  int get _wrongCount => total - correctCount;
  double get _accuracy => total == 0 ? 0 : correctCount / total;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bgColor = colorScheme.primary;

    Color accuracyColor;
    String emoji;
    String message;
    if (_accuracy >= 0.7) {
      accuracyColor = Colors.green;
      emoji = '🎉';
      message = 'Excellent!';
    } else if (_accuracy >= 0.4) {
      accuracyColor = const Color(0xFFFF9800);
      emoji = '💪';
      message = 'Good effort!';
    } else {
      accuracyColor = const Color(0xFFFF5252);
      emoji = '📚';
      message = 'Keep practicing!';
    }

    final wrongResults = results.where((r) => !r.correct).toList();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: onBack,
        ),
        title: const Text(
          'Practice Complete',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  // ── Main result card ──
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 36, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 30,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(emoji, style: const TextStyle(fontSize: 56)),
                        const SizedBox(height: 16),
                        Text(
                          message,
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'You typed $correctCount out of $total words correctly',
                          style: textTheme.bodyLarge
                              ?.copyWith(color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${(_accuracy * 100).toInt()}% accuracy',
                          style: textTheme.titleLarge?.copyWith(
                            color: accuracyColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Stat boxes
                        Row(
                          children: [
                            Expanded(
                              child: _StatBox(
                                icon: Icons.check_circle_rounded,
                                iconColor: Colors.green,
                                backgroundColor: const Color(0xFFE8F5E9),
                                value: correctCount.toString(),
                                label: 'Correct',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _StatBox(
                                icon: Icons.close_rounded,
                                iconColor: Colors.red,
                                backgroundColor: const Color(0xFFFFEBEE),
                                value: _wrongCount.toString(),
                                label: 'Wrong',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _StatBox(
                                icon: Icons.star_rounded,
                                iconColor: const Color(0xFFFFC107),
                                backgroundColor: const Color(0xFFFFF8E1),
                                value: '$totalStars/$maxPossibleStars',
                                label: 'Stars',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ── Wrong words list ──
                  if (wrongResults.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          'Words to review',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...wrongResults.map((r) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.close_rounded,
                                  color: Colors.white70, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      r.word.word,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    if (r.word.senses.isNotEmpty)
                                      Text(
                                        r.word.senses.first.definition,
                                        style: TextStyle(
                                          color: Colors.white
                                              .withValues(alpha: 0.7),
                                          fontSize: 13,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // ── Bottom buttons ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onPracticeAgain,
                    icon: const Icon(Icons.refresh_rounded,
                        color: Colors.white),
                    label: const Text(
                      'Practice Again',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side:
                          const BorderSide(color: Colors.white, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextButton.icon(
                    onPressed: onBack,
                    icon: const Icon(Icons.check_rounded,
                        color: Colors.white, size: 20),
                    label: const Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String value;
  final String label;

  const _StatBox({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
