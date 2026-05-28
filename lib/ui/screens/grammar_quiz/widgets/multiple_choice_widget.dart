import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/grammar_quiz.dart';
import '../bloc/grammar_quiz_bloc.dart';

/// Multiple choice question widget.
/// Shows "Which sentence is correct?" with 4 sentence options.
class MultipleChoiceWidget extends StatelessWidget {
  final QuizQuestion question;
  final GrammarQuizState state;

  const MultipleChoiceWidget({super.key, required this.question, required this.state});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
          ),
          child: Text(
            question.question ?? 'Câu nào đúng ngữ pháp?',
            style: textTheme.titleMedium?.copyWith(
              height: 1.6,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 20),

        Text(
          'Chọn đáp án đúng:',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.5),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),

        ...List.generate(question.options.length, (index) {
          final isSelected = state.selectedAnswer == index;
          final isCorrect = index == question.correctAnswer;

          Color bgColor;
          Color borderColor;

          if (state.isAnswered) {
            if (isCorrect) {
              bgColor = Colors.green.withValues(alpha: 0.1);
              borderColor = Colors.green;
            } else if (isSelected) {
              bgColor = Colors.red.withValues(alpha: 0.1);
              borderColor = Colors.red;
            } else {
              bgColor = colorScheme.surfaceContainerLow;
              borderColor = colorScheme.outlineVariant.withValues(alpha: 0.2);
            }
          } else {
            bgColor = isSelected
                ? colorScheme.primary.withValues(alpha: 0.08)
                : colorScheme.surfaceContainerLow;
            borderColor = isSelected
                ? colorScheme.primary
                : colorScheme.outlineVariant.withValues(alpha: 0.3);
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              onTap: state.isAnswered
                  ? null
                  : () => context.read<GrammarQuizBloc>().add(SelectAnswerEvent(index)),
              borderRadius: BorderRadius.circular(14),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: borderColor,
                    width: isSelected || (state.isAnswered && isCorrect) ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    if (state.isAnswered && isCorrect)
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(Icons.check_circle, size: 20, color: Colors.green),
                      )
                    else if (state.isAnswered && isSelected && !isCorrect)
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(Icons.cancel, size: 20, color: Colors.red),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
                              width: 2,
                            ),
                            color: isSelected ? colorScheme.primary.withValues(alpha: 0.2) : Colors.transparent,
                          ),
                        ),
                      ),
                    Expanded(
                      child: Text(
                        question.options[index],
                        style: textTheme.bodyMedium?.copyWith(
                          color: state.isAnswered && !isCorrect && !isSelected
                              ? colorScheme.onSurface.withValues(alpha: 0.4)
                              : colorScheme.onSurface,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
