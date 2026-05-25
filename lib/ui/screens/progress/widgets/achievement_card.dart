import 'package:flutter/material.dart';

import '../../../../data/repositories/achievement_repository.dart';

/// A single achievement badge card for the grid.
class AchievementCard extends StatelessWidget {
  final AchievementDef definition;
  final AchievementProgress progress;
  final VoidCallback? onTap;

  const AchievementCard({
    super.key,
    required this.definition,
    required this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final unlocked = progress.unlocked;
    final percent = definition.target > 0
        ? (progress.currentProgress / definition.target).clamp(0.0, 1.0)
        : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: unlocked ? Colors.white : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: unlocked
                ? colorScheme.primary.withValues(alpha: 0.4)
                : Colors.grey.shade200,
            width: unlocked ? 1.5 : 1,
          ),
          boxShadow: unlocked
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with optional lock overlay
            Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  definition.icon,
                  style: TextStyle(
                    fontSize: 32,
                    color: unlocked ? null : Colors.grey,
                  ),
                ),
                if (!unlocked)
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // Name
            Text(
              definition.nameVi,
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: unlocked ? Colors.black87 : Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percent,
                minHeight: 4,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation(
                  unlocked ? Colors.green : colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 4),

            // Progress text
            Text(
              unlocked
                  ? '✓'
                  : '${progress.currentProgress}/${definition.target}',
              style: textTheme.labelSmall?.copyWith(
                color: unlocked ? Colors.green : Colors.grey.shade500,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
