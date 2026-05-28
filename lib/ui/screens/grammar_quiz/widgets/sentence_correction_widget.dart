import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/grammar_quiz.dart';
import '../bloc/grammar_quiz_bloc.dart';

/// Sentence correction question widget.
/// Shows a sentence with a grammar error and 4 highlighted words/phrases to pick the wrong one.
class SentenceCorrectionWidget extends StatelessWidget {
  final QuizQuestion question;
  final GrammarQuizState state;

  const SentenceCorrectionWidget({super.key, required this.question, required this.state});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Instruction
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tìm lỗi sai trong câu:',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                question.sentence ?? question.question ?? '',
                style: textTheme.titleMedium?.copyWith(
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Show corrected sentence after answering
        if (state.isAnswered && question.correctedSentence != null) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Câu đúng:',
                  style: textTheme.labelSmall?.copyWith(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  question.correctedSentence!,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        Text(
          'Chọn từ/cụm từ sai:',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.5),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),

        // Options as chips
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(question.options.length, (index) {
            final isSelected = state.selectedAnswer == index;
            final isCorrect = index == question.correctAnswer;

            Color bgColor;
            Color borderColor;
            Color textColor;

            if (state.isAnswered) {
              if (isCorrect) {
                bgColor = Colors.red.withValues(alpha: 0.15); // The wrong word = marked in red
                borderColor = Colors.red;
                textColor = Colors.red.shade700;
              } else if (isSelected) {
                bgColor = Colors.orange.withValues(alpha: 0.1);
                borderColor = Colors.orange;
                textColor = Colors.orange.shade700;
              } else {
                bgColor = colorScheme.surfaceContainerLow;
                borderColor = colorScheme.outlineVariant.withValues(alpha: 0.2);
                textColor = colorScheme.onSurface.withValues(alpha: 0.4);
              }
            } else {
              bgColor = isSelected
                  ? colorScheme.primary.withValues(alpha: 0.1)
                  : colorScheme.surfaceContainerLow;
              borderColor = isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant.withValues(alpha: 0.3);
              textColor = colorScheme.onSurface;
            }

            return InkWell(
              onTap: state.isAnswered
                  ? null
                  : () => context.read<GrammarQuizBloc>().add(SelectAnswerEvent(index)),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: borderColor,
                    width: isSelected || (state.isAnswered && isCorrect) ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state.isAnswered && isCorrect)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Icon(Icons.error, size: 18, color: Colors.red.shade700),
                      ),
                    Text(
                      question.options[index],
                      style: textTheme.bodyLarge?.copyWith(
                        color: textColor,
                        fontWeight: isSelected || (state.isAnswered && isCorrect) ? FontWeight.w700 : FontWeight.w500,
                        decoration: state.isAnswered && isCorrect ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
