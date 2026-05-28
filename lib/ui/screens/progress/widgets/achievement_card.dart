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
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: unlocked ? colorScheme.surfaceContainer : colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: unlocked
                ? colorScheme.primary.withValues(alpha: 0.4)
                : colorScheme.outlineVariant,
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
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  FittedBox(
                    child: Text(
                      definition.icon,
                      style: TextStyle(
                        fontSize: 32,
                        color: unlocked ? null : colorScheme.outline,
                      ),
                    ),
                  ),
                  if (!unlocked)
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: colorScheme.outline,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.lock,
                          size: 10,
                          color: colorScheme.surface,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Name
            Text(
              definition.nameVi,
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: unlocked ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
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
                backgroundColor: colorScheme.surfaceContainerHighest,
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
                color: unlocked ? Colors.green : colorScheme.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
