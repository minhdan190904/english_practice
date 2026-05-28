import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../configs/di.dart';
import '../../../data/models/grammar_quiz.dart';
import '../../../data/repositories/grammar_quiz_repository.dart';
import 'bloc/grammar_quiz_bloc.dart';
import 'widgets/fill_in_blank_widget.dart';
import 'widgets/multiple_choice_widget.dart';
import 'widgets/sentence_correction_widget.dart';
import 'widgets/word_order_widget.dart';
import 'widgets/quiz_result_widget.dart';

class GrammarQuizScreen extends StatelessWidget {
  final int topicId;
  final String topicTitle;

  const GrammarQuizScreen({
    super.key,
    required this.topicId,
    required this.topicTitle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GrammarQuizBloc(
        repository: DI().sl<GrammarQuizRepository>(),
      )..add(LoadQuizEvent(topicId)),
      child: _GrammarQuizBody(topicTitle: topicTitle),
    );
  }
}

class _GrammarQuizBody extends StatelessWidget {
  final String topicTitle;

  const _GrammarQuizBody({required this.topicTitle});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          topicTitle,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<GrammarQuizBloc, GrammarQuizState>(
        builder: (context, state) {
          return switch (state.status) {
            GrammarQuizStatus.loading => _buildLoading(colorScheme),
            GrammarQuizStatus.error => _buildError(context, state, colorScheme),
            GrammarQuizStatus.completed => QuizResultWidget(
                correctCount: state.correctCount,
                totalQuestions: state.questions.length,
              ),
            _ => _buildQuiz(context, state, colorScheme, textTheme),
          };
        },
      ),
    );
  }

  Widget _buildLoading(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            'Đang tải bài tập...',
            style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6)),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, GrammarQuizState state, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              state.errorMessage ?? 'Đã xảy ra lỗi',
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.onSurface),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Quay lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuiz(
    BuildContext context,
    GrammarQuizState state,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final question = state.questions[state.currentIndex];
    final progress = (state.currentIndex + 1) / state.questions.length;

    return SafeArea(
      child: Column(
        children: [
          // Progress header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Câu ${state.currentIndex + 1}/${state.questions.length}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.check_circle, size: 16, color: Colors.green.shade400),
                        const SizedBox(width: 4),
                        Text(
                          '${state.correctCount}',
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.green.shade400,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: progress),
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    builder: (context, value, _) {
                      return LinearProgressIndicator(
                        value: value,
                        backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                        minHeight: 6,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Question type badge
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getTypeColor(question.type, colorScheme).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getTypeLabel(question.type),
                  style: textTheme.labelSmall?.copyWith(
                    color: _getTypeColor(question.type, colorScheme),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          // Question content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: _buildQuestionWidget(question, state),
            ),
          ),

          // Bottom actions
          _buildBottomBar(context, state, question, colorScheme, textTheme),
        ],
      ),
    );
  }

  Widget _buildQuestionWidget(QuizQuestion question, GrammarQuizState state) {
    return switch (question.type) {
      'fill_in_blank' => FillInBlankWidget(question: question, state: state),
      'multiple_choice' => MultipleChoiceWidget(question: question, state: state),
      'sentence_correction' => SentenceCorrectionWidget(question: question, state: state),
      'word_order' => WordOrderWidget(question: question, state: state),
      _ => MultipleChoiceWidget(question: question, state: state),
    };
  }

  Widget _buildBottomBar(
    BuildContext context,
    GrammarQuizState state,
    QuizQuestion question,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final bloc = context.read<GrammarQuizBloc>();
    final canSubmit = state.selectedAnswer >= 0 ||
        (question.type == 'word_order' && state.selectedWordOrder.length == question.words.length);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: state.isAnswered
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Feedback
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: state.isCorrect
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: state.isCorrect
                          ? Colors.green.withValues(alpha: 0.3)
                          : Colors.red.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        state.isCorrect ? Icons.check_circle : Icons.cancel,
                        color: state.isCorrect ? Colors.green : Colors.red,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.isCorrect ? 'Chính xác! 🎉' : 'Chưa đúng 😅',
                              style: textTheme.titleSmall?.copyWith(
                                color: state.isCorrect ? Colors.green.shade700 : Colors.red.shade700,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (question.explanation != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                question.explanation!,
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Next button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => bloc.add(const NextQuestionEvent()),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      state.currentIndex >= state.questions.length - 1
                          ? 'Xem kết quả'
                          : 'Câu tiếp theo',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                  ),
                ),
              ],
            )
          : SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: canSubmit
                    ? () => bloc.add(const SubmitAnswerEvent())
                    : null,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Kiểm tra',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            ),
    );
  }

  Color _getTypeColor(String type, ColorScheme colorScheme) {
    return switch (type) {
      'fill_in_blank' => Colors.blue,
      'multiple_choice' => Colors.purple,
      'sentence_correction' => Colors.orange,
      'word_order' => Colors.teal,
      _ => colorScheme.primary,
    };
  }

  String _getTypeLabel(String type) {
    return switch (type) {
      'fill_in_blank' => '✏️ Điền từ',
      'multiple_choice' => '🔘 Chọn đáp án',
      'sentence_correction' => '🔍 Sửa lỗi sai',
      'word_order' => '🔀 Sắp xếp từ',
      _ => '📝 Bài tập',
    };
  }
}
