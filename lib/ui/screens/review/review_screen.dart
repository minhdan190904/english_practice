import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/word.dart';
import '../../../data/models/word_status.dart';

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


  @override
  Widget build(BuildContext context) {
    final vocabularyState = context.watch<VocabularyBloc>().state;
    final reviewWords = vocabularyState.words.where((word) => word.status == WordStatus.star).toList();
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
          : EmptyReviewPage(
              hasWords: vocabularyState.words.any((word) => word.status == WordStatus.unknown),
            ),
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
