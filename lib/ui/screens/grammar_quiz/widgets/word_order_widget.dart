import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/grammar_quiz.dart';
import '../bloc/grammar_quiz_bloc.dart';

/// Word order question widget.
/// Shows shuffled word chips that user taps to arrange into correct sentence.
class WordOrderWidget extends StatelessWidget {
  final QuizQuestion question;
  final GrammarQuizState state;

  const WordOrderWidget({super.key, required this.question, required this.state});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final selectedOrder = state.selectedWordOrder;

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
                'Sắp xếp các từ thành câu đúng:',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (question.question != null) ...[
                const SizedBox(height: 8),
                Text(
                  question.question!,
                  style: textTheme.titleMedium?.copyWith(
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Sentence construction area
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 60),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: state.isAnswered
                ? (state.isCorrect
                    ? Colors.green.withValues(alpha: 0.05)
                    : Colors.red.withValues(alpha: 0.05))
                : colorScheme.primary.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: state.isAnswered
                  ? (state.isCorrect ? Colors.green.withValues(alpha: 0.3) : Colors.red.withValues(alpha: 0.3))
                  : colorScheme.primary.withValues(alpha: 0.2),
              style: state.isAnswered ? BorderStyle.solid : BorderStyle.none,
            ),
          ),
          child: selectedOrder.isEmpty
              ? Text(
                  'Chạm vào các từ bên dưới để sắp xếp...',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                    fontStyle: FontStyle.italic,
                  ),
                )
              : Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: selectedOrder.map((wordIndex) {
                    return _WordChip(
                      word: question.words[wordIndex],
                      isInSentence: true,
                      isAnswered: state.isAnswered,
                      onTap: state.isAnswered
                          ? null
                          : () {
                              final newOrder = List<int>.from(selectedOrder)..remove(wordIndex);
                              context.read<GrammarQuizBloc>().add(SelectWordOrderEvent(newOrder));
                            },
                    );
                  }).toList(),
                ),
        ),

        // Show correct sentence after wrong answer
        if (state.isAnswered && !state.isCorrect && question.correctSentence != null) ...[
          const SizedBox(height: 12),
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
                  question.correctSentence!,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 20),

        // Available words pool
        Text(
          'Các từ:',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.5),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(question.words.length, (index) {
            final isUsed = selectedOrder.contains(index);
            return _WordChip(
              word: question.words[index],
              isUsed: isUsed,
              isAnswered: state.isAnswered,
              onTap: state.isAnswered || isUsed
                  ? null
                  : () {
                      final newOrder = List<int>.from(selectedOrder)..add(index);
                      context.read<GrammarQuizBloc>().add(SelectWordOrderEvent(newOrder));
                    },
            );
          }),
        ),
      ],
    );
  }
}

class _WordChip extends StatelessWidget {
  final String word;
  final bool isUsed;
  final bool isInSentence;
  final bool isAnswered;
  final VoidCallback? onTap;

  const _WordChip({
    required this.word,
    this.isUsed = false,
    this.isInSentence = false,
    this.isAnswered = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Color bgColor;
    Color textColor;
    Color borderColor;

    if (isInSentence) {
      bgColor = colorScheme.primary.withValues(alpha: 0.1);
      textColor = colorScheme.primary;
      borderColor = colorScheme.primary.withValues(alpha: 0.3);
    } else if (isUsed) {
      bgColor = colorScheme.surfaceContainerLow.withValues(alpha: 0.5);
      textColor = colorScheme.onSurface.withValues(alpha: 0.2);
      borderColor = colorScheme.outlineVariant.withValues(alpha: 0.1);
    } else {
      bgColor = colorScheme.surfaceContainerLow;
      textColor = colorScheme.onSurface;
      borderColor = colorScheme.outlineVariant.withValues(alpha: 0.3);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
            boxShadow: isInSentence && !isAnswered
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            word,
            style: textTheme.bodyMedium?.copyWith(
              color: textColor,
              fontWeight: isInSentence ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
