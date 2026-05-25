import 'package:flutter/material.dart';

import '../../../../data/repositories/achievement_repository.dart';
import 'achievement_card.dart';

/// Grid widget displaying all 12 achievements.
/// Shows section title with count and a 3-column grid of AchievementCards.
class AchievementGrid extends StatelessWidget {
  final AchievementRepository repository;

  const AchievementGrid({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final unlockedCount = repository.unlockedCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Row(
          children: [
            Icon(Icons.emoji_events_rounded,
                color: const Color(0xFFFFC107), size: 24),
            const SizedBox(width: 8),
            Text(
              'Achievements',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$unlockedCount/${kAchievements.length}',
                style: textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.85,
          ),
          itemCount: kAchievements.length,
          itemBuilder: (context, index) {
            final def = kAchievements[index];
            final progress = repository.getProgress(def.id);
            return AchievementCard(
              definition: def,
              progress: progress,
              onTap: () => _showAchievementDetail(context, def, progress),
            );
          },
        ),
      ],
    );
  }

  void _showAchievementDetail(
    BuildContext context,
    AchievementDef def,
    AchievementProgress progress,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),

            // Icon
            Text(def.icon, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 16),

            // Name
            Text(
              def.nameVi,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              def.descriptionVi,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),

            // Progress
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: def.target > 0
                    ? (progress.currentProgress / def.target).clamp(0.0, 1.0)
                    : 0.0,
                minHeight: 10,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation(
                  progress.unlocked ? Colors.green : colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              progress.unlocked
                  ? '✅ Completed${progress.unlockedAt != null ? ' on ${_formatDate(progress.unlockedAt!)}' : ''}'
                  : '${progress.currentProgress} / ${def.target}',
              style: textTheme.bodySmall?.copyWith(
                color: progress.unlocked ? Colors.green : Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
