import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../configs/di.dart';
import '../../../data/models/word.dart';
import '../../../data/models/word_status.dart';
import '../../../data/repositories/srs_repository.dart';

import '../../../navigation/app_router.dart';
import '../../../utils/global_values.dart';
import '../../commons/ads/banner_ad_widget.dart';
import '../../commons/base_page.dart';
import '../../commons/rounded_button.dart';
import '../vocabulary/bloc/vocabulary_bloc.dart';
import '../vocabulary/widgets/vocabulary_item.dart';
import 'widgets/empty_review_page.dart';
import 'widgets/schedule_modal.dart';
import '../../../utils/l10n.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final SrsRepository _srsRepository = DI().sl<SrsRepository>();

  @override
  Widget build(BuildContext context) {
    final vocabularyState = context.watch<VocabularyBloc>().state;

    // Get SRS due words and filter vocabulary to only those
    final dueWordData = _srsRepository.getDueWords();
    final dueIndices = dueWordData.map((srs) => srs.wordIndex).toSet();
    final reviewWords = vocabularyState.words
        .where((word) => word.status == WordStatus.star && dueIndices.contains(word.index))
        .toList();

    // Sort: overdue words first, then today's due words
    reviewWords.sort((a, b) {
      final srsA = _srsRepository.get(a.index);
      final srsB = _srsRepository.get(b.index);
      final aOverdue = srsA?.isOverdue ?? false;
      final bOverdue = srsB?.isOverdue ?? false;
      if (aOverdue && !bOverdue) return -1;
      if (!aOverdue && bOverdue) return 1;
      final aDate = srsA?.nextReviewDate;
      final bDate = srsB?.nextReviewDate;
      if (aDate == null) return 1;
      if (bDate == null) return -1;
      return aDate.compareTo(bDate);
    });

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return BasePage(
      title: L10n.tr(context, 'review'),
      actions: [
        if (vocabularyState.words.any((word) => word.status == WordStatus.unknown))
          TextButton(
            onPressed: () => _showScheduleModal(context, reviewWords),
            child: Text(
              L10n.tr(context, 'schedule'),
              style: textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
      ],
      child: reviewWords.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    '${reviewWords.length} word${reviewWords.length == 1 ? '' : 's'} due for review',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withAlpha(160),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: reviewWords.length,
                    itemBuilder: (context, index) {
                      final word = reviewWords[index];
                      return Column(
                        children: [
                          VocabularyItem(
                            word: word,
                            showReviewButton: false,
                          ),
                          if (index == 1) ...[
                            const BannerAdWidget(
                              paddingHorizontal: 16,
                              paddingVertical: 8,
                            ),
                          ]
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: RoundedButton(
                        onPressed: () => _startFlashcards(context, reviewWords),
                        borderRadius: 16,
                        child: Text(
                          '📝',
                          style: textTheme.titleSmall?.copyWith(color: colorScheme.onPrimary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: RoundedButton(
                        onPressed: () => _startTyping(context, reviewWords),
                        borderRadius: 16,
                        backgroundColor: colorScheme.secondary,
                        child: Text(
                          '⌨️',
                          style: textTheme.titleSmall?.copyWith(color: colorScheme.onSecondary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: RoundedButton(
                        onPressed: () => _startQuiz(context, reviewWords),
                        borderRadius: 16,
                        backgroundColor: colorScheme.tertiary,
                        child: Text(
                          '🧠',
                          style: textTheme.titleSmall?.copyWith(color: colorScheme.onTertiary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            )
          : _buildEmptyState(context, vocabularyState),
    );
  }

  Widget _buildEmptyState(BuildContext context, VocabularyState vocabularyState) {
    final hasStarredWords = vocabularyState.words.any((word) => word.status == WordStatus.star);
    final hasUnknownWords = vocabularyState.words.any((word) => word.status == WordStatus.unknown);

    if (hasStarredWords) {
      // Has starred words but none are due — all caught up!
      final textTheme = Theme.of(context).textTheme;
      final colorScheme = Theme.of(context).colorScheme;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              'All caught up!',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'No words are due for review right now.\nCome back later!',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withAlpha(150),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    return EmptyReviewPage(
      hasWords: hasUnknownWords,
    );
  }

  void _showScheduleModal(BuildContext context, List<Word> reviewWords) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ScheduleModal(
        reviewWords: reviewWords,
      ),
    );
  }

  void _startFlashcards(BuildContext context, List<Word> reviewWords) {
    context.push(RoutePaths.flashcards, extra: {'words': reviewWords});
    GlobalValues.setLastReviewTime(DateTime.now());
  }

  void _startTyping(BuildContext context, List<Word> reviewWords) {
    context.push(RoutePaths.typingChallenge, extra: {'words': reviewWords});
    GlobalValues.setLastReviewTime(DateTime.now());
  }

  void _startQuiz(BuildContext context, List<Word> reviewWords) {
    context.push(RoutePaths.quiz, extra: {'studyWords': reviewWords});
    GlobalValues.setLastReviewTime(DateTime.now());
  }
}
