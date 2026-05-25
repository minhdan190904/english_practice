import 'package:flutter/material.dart';

import '../../../../data/models/word.dart';

class FlashcardResultScreen extends StatelessWidget {
  final int total;
  final int known;
  final List<Word> needReviewWords;
  final VoidCallback onPracticeAgain;
  final VoidCallback onBack;

  const FlashcardResultScreen({
    super.key,
    required this.total,
    required this.known,
    required this.needReviewWords,
    required this.onPracticeAgain,
    required this.onBack,
  });

  int get _needReview => needReviewWords.toSet().length;
  double get _accuracy => total == 0 ? 0 : known / total;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bgColor = colorScheme.primary;

    Color accuracyColor;
    if (_accuracy >= 0.7) {
      accuracyColor = Colors.green;
    } else if (_accuracy >= 0.4) {
      accuracyColor = const Color(0xFFFF9800);
    } else {
      accuracyColor = const Color(0xFFFF5252);
    }

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
          const Spacer(),

          // ── Main result card ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
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
                  // Party popper icon
                  const Text('🎉', style: TextStyle(fontSize: 56)),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    'Practice Completed!',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Subtitle
                  Text(
                    'You knew $known out of $total words',
                    style: textTheme.bodyLarge?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Accuracy
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
                          value: known.toString(),
                          label: 'Known',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatBox(
                          icon: Icons.refresh_rounded,
                          iconColor: Colors.red,
                          backgroundColor: const Color(0xFFFFEBEE),
                          value: _needReview.toString(),
                          label: 'Need Review',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          // ── Bottom buttons ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            child: Row(
              children: [
                // Practice Again
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onPracticeAgain,
                    icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                    label: const Text(
                      'Practice Again',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Back
                Expanded(
                  child: TextButton.icon(
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    label: const Text(
                      'Back',
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
            style: textTheme.headlineSmall?.copyWith(
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
