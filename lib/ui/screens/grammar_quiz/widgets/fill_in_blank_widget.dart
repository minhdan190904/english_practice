import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/grammar_quiz.dart';
import '../bloc/grammar_quiz_bloc.dart';

/// Fill-in-the-blank question widget.
/// Shows a sentence with ___ and 4 option buttons.
class FillInBlankWidget extends StatelessWidget {
  final QuizQuestion question;
  final GrammarQuizState state;

  const FillInBlankWidget({super.key, required this.question, required this.state});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question with blank
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
          ),
          child: Text(
            question.question ?? '',
            style: textTheme.titleMedium?.copyWith(
              height: 1.6,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Options
        Text(
          'Chọn đáp án đúng:',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.5),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        ...List.generate(question.options.length, (index) {
          return _OptionTile(
            index: index,
            text: question.options[index],
            isSelected: state.selectedAnswer == index,
            isAnswered: state.isAnswered,
            isCorrect: index == question.correctAnswer,
            onTap: () {
              context.read<GrammarQuizBloc>().add(SelectAnswerEvent(index));
            },
          );
        }),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  final int index;
  final String text;
  final bool isSelected;
  final bool isAnswered;
  final bool isCorrect;
  final VoidCallback onTap;

  const _OptionTile({
    required this.index,
    required this.text,
    required this.isSelected,
    required this.isAnswered,
    required this.isCorrect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Color bgColor;
    Color borderColor;
    Color textColor;

    if (isAnswered) {
      if (isCorrect) {
        bgColor = Colors.green.withValues(alpha: 0.1);
        borderColor = Colors.green;
        textColor = Colors.green.shade700;
      } else if (isSelected && !isCorrect) {
        bgColor = Colors.red.withValues(alpha: 0.1);
        borderColor = Colors.red;
        textColor = Colors.red.shade700;
      } else {
        bgColor = colorScheme.surfaceContainerLow;
        borderColor = colorScheme.outlineVariant.withValues(alpha: 0.2);
        textColor = colorScheme.onSurface.withValues(alpha: 0.4);
      }
    } else {
      bgColor = isSelected
          ? colorScheme.primary.withValues(alpha: 0.08)
          : colorScheme.surfaceContainerLow;
      borderColor = isSelected
          ? colorScheme.primary
          : colorScheme.outlineVariant.withValues(alpha: 0.3);
      textColor = colorScheme.onSurface;
    }

    final labels = ['A', 'B', 'C', 'D'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isAnswered ? null : onTap,
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: isSelected || (isAnswered && isCorrect) ? 2 : 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected || (isAnswered && isCorrect)
                        ? borderColor.withValues(alpha: 0.15)
                        : colorScheme.surfaceContainerHigh,
                  ),
                  child: Center(
                    child: isAnswered && isCorrect
                        ? const Icon(Icons.check, size: 18, color: Colors.green)
                        : isAnswered && isSelected && !isCorrect
                            ? const Icon(Icons.close, size: 18, color: Colors.red)
                            : Text(
                                labels[index],
                                style: textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isSelected ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                              ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    text,
                    style: textTheme.bodyLarge?.copyWith(
                      color: textColor,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
