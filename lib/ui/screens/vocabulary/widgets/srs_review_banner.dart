import 'package:flutter/material.dart';

import '../../../../data/repositories/srs_repository.dart';

/// A gradient banner card showing "X words due today" with a "Review Now" button.
/// Displayed at the top of VocabularyScreen when there are due words.
class SrsReviewBanner extends StatelessWidget {
  final SrsRepository srsRepository;
  final VoidCallback onReviewNow;

  const SrsReviewBanner({
    super.key,
    required this.srsRepository,
    required this.onReviewNow,
  });

  @override
  Widget build(BuildContext context) {
    final dueCount = srsRepository.dueCount;
    final overdueCount = srsRepository.overdueCount;
    final todayCount = dueCount - overdueCount;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                dueCount > 0 ? Icons.local_fire_department_rounded : Icons.check_circle_rounded,
                color: Colors.white.withValues(alpha: 0.9),
                size: 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  dueCount > 0 ? '$dueCount words due today' : 'All caught up!',
                  style: textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (overdueCount > 0) ...[
            const SizedBox(height: 4),
            Text(
              '$overdueCount overdue · $todayCount today',
              style: textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
          if (dueCount == 0) ...[
            const SizedBox(height: 4),
            Text(
              'No words due for review right now.',
              style: textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: dueCount > 0 ? onReviewNow : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: colorScheme.primary,
                disabledBackgroundColor: Colors.white.withValues(alpha: 0.5),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                dueCount > 0 ? '▶  Review Now' : 'Check back later',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: dueCount > 0 ? colorScheme.primary : Colors.black38,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
