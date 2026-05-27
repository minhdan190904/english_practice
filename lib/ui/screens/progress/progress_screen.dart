import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../data/models/word_status.dart';
import '../../../generated/assets.dart';
import '../../../utils/l10n.dart';
import '../../../configs/di.dart';
import '../../../data/repositories/achievement_repository.dart';
import '../../commons/base_page.dart';
import '../grammar/bloc/lesson_bloc.dart';
import '../streak/bloc/streak_bloc.dart';
import '../vocabulary/bloc/vocabulary_bloc.dart';
import 'widgets/achievement_grid.dart';

/// Màn hình Progress — Learning Progress Dashboard (Phase 3).
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Listen to all three blocs
    final vocabularyState = context.watch<VocabularyBloc>().state;
    final lessonState = context.watch<LessonBloc>().state;
    final streakState = context.watch<StreakBloc>().state;

    // Calculate Vocabulary Stats
    final totalWords = vocabularyState.words.length;
    final starredWords = vocabularyState.words.where((w) => w.status == WordStatus.studying).length;
    final masteredWords = vocabularyState.words.where((w) => w.status == WordStatus.mastered).length;

    // Calculate Grammar Stats
    final completedLessons = lessonState.markedLessons.values.where((v) => v).length;
    const totalLessons = 37; // Based on 37 grammar files
    final grammarPercent = totalLessons == 0 ? 0.0 : (completedLessons / totalLessons);

    // Calculate Streak
    final streakPercent = streakState.spentTimeToday / StreakBloc.timePerDayNeeded;
    final safeStreakPercent = streakPercent > 1.0 ? 1.0 : streakPercent;

    return DefaultTabController(
      length: 2,
      child: BasePage(
        title: L10n.tr(context, 'progress'),
        padding: EdgeInsets.zero, // Remove padding from BasePage so TabBar reaches edges
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabBar(
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.6),
              indicatorColor: colorScheme.primary,
              tabs: [
                Tab(text: L10n.tr(context, 'statistics')),
                Tab(text: L10n.tr(context, 'achievements')),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Tab 1: Statistics
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildSectionTitle(context, L10n.tr(context, 'streak'), Icons.local_fire_department_rounded, colorScheme.primary),
                          const SizedBox(height: 16),
                          _buildStreakCard(context, safeStreakPercent, streakState, colorScheme, textTheme),
                          const SizedBox(height: 32),
                          
                          _buildSectionTitle(context, L10n.tr(context, 'vocabulary_stats'), Icons.library_books_outlined, colorScheme.secondary),
                          const SizedBox(height: 16),
                          _buildVocabularyStats(context, totalWords, starredWords, masteredWords, colorScheme, textTheme),
                          const SizedBox(height: 32),
                          
                          _buildSectionTitle(context, L10n.tr(context, 'grammar_progress'), Icons.school_rounded, colorScheme.tertiary),
                          const SizedBox(height: 16),
                          _buildGrammarStats(context, completedLessons, totalLessons, grammarPercent, colorScheme, textTheme),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),

                  // Tab 2: Achievements
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      child: AchievementGrid(repository: DI().sl<AchievementRepository>()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon, Color color) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStreakCard(BuildContext context, double percent, StreakState state, ColorScheme colorScheme, TextTheme textTheme) {
    final size = MediaQuery.of(context).size;
    final isDone = percent >= 1.0;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    L10n.tr(context, 'longest_streak'),
                    style: textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimaryContainer.withValues(alpha: 0.7)),
                  ),
                  Row(
                    children: [
                      Image.asset(Assets.pngFlame, width: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${state.longestStreak} ${L10n.tr(context, 'streaks').toLowerCase()}',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (isDone)
                Icon(Icons.check_circle_rounded, color: Colors.green, size: 28),
            ],
          ),
          const SizedBox(height: 24),
          CircularPercentIndicator(
            radius: size.shortestSide * 0.2,
            lineWidth: 12.0,
            circularStrokeCap: CircularStrokeCap.round,
            percent: percent,
            center: Image.asset(state.streak != 0 ? Assets.pngFlame : Assets.pngFlameInactive, width: size.shortestSide * 0.15),
            progressColor: const Color(0xFFf5a623),
            backgroundColor: colorScheme.onPrimaryContainer.withValues(alpha: 0.1),
          ),
          const SizedBox(height: 16),
          Text(
            '${state.streak} ${L10n.tr(context, 'streaks')}',
            style: textTheme.headlineMedium?.copyWith(
              color: state.streak != 0 ? const Color(0xFFf5a623) : colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isDone ? L10n.tr(context, 'keep_up_the_good_work') : L10n.tr(context, 'study_at_least_5_mins'),
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVocabularyStats(BuildContext context, int total, int starred, int mastered, ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.secondaryContainer),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(context, label: L10n.tr(context, 'total'), value: total.toString(), icon: Icons.library_books_outlined, colorScheme: colorScheme, textTheme: textTheme),
          _buildStatDivider(colorScheme),
          _buildStatItem(context, label: L10n.tr(context, 'studying'), value: starred.toString(), icon: Icons.star_rounded, iconColor: colorScheme.tertiary, colorScheme: colorScheme, textTheme: textTheme),
          _buildStatDivider(colorScheme),
          _buildStatItem(context, label: L10n.tr(context, 'mastered'), value: mastered.toString(), icon: Icons.check_circle_rounded, iconColor: Colors.green, colorScheme: colorScheme, textTheme: textTheme),
        ],
      ),
    );
  }

  Widget _buildGrammarStats(BuildContext context, int completed, int total, double percent, ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.tertiaryContainer),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                L10n.tr(context, 'lessons_completed'),
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                '$completed / $total',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.tertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearPercentIndicator(
            lineHeight: 12.0,
            percent: percent,
            barRadius: const Radius.circular(6),
            progressColor: colorScheme.tertiary,
            backgroundColor: colorScheme.onSurface.withValues(alpha: 0.1),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, {required String label, required String value, required IconData icon, Color? iconColor, required ColorScheme colorScheme, required TextTheme textTheme}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: iconColor ?? colorScheme.secondary),
            const SizedBox(width: 6),
            Text(
              value,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider(ColorScheme colorScheme) {
    return Container(
      height: 32,
      width: 1,
      color: colorScheme.onSurface.withValues(alpha: 0.15),
    );
  }
}
