import 'package:flutter/material.dart';

import '../quiz_screen.dart';

class QuizQuestionCard extends StatelessWidget {
  final QuizQuestion question;
  final String? selectedAnswer;
  final bool answered;
  final Function(String) onAnswer;

  const QuizQuestionCard({
    super.key,
    required this.question,
    required this.selectedAnswer,
    required this.answered,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildPrompt(context),
          const SizedBox(height: 32),
          ...question.options.map((option) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _OptionButton(
                  text: option,
                  isSelected: selectedAnswer == option,
                  isCorrect: option == question.correctAnswer,
                  answered: answered,
                  onTap: () => onAnswer(option),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildPrompt(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    switch (question.type) {
      case QuizType.meaning:
        return Column(
          children: [
            Text(
              'What does this word mean?',
              style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            Text(
              question.word.word,
              style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary),
              textAlign: TextAlign.center,
            ),
          ],
        );

      case QuizType.word:
        final meaning = question.word.senses.isNotEmpty ? question.word.senses.first.definition : question.word.word;
        return Column(
          children: [
            Text(
              'Which word matches this definition?',
              style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                meaning,
                style: textTheme.titleLarge?.copyWith(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );

      case QuizType.fillIn:
        final sentence = question.word.userDefinition ?? '';
        return Column(
          children: [
            Text(
              'Fill in the blank:',
              style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                sentence,
                style: textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );

      case QuizType.listening:
        return Column(
          children: [
            Text(
              'Which word did you hear?',
              style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.volume_up_rounded, size: 48, color: colorScheme.onPrimaryContainer),
            ),
          ],
        );
    }
  }
}

class _OptionButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool answered;
  final VoidCallback onTap;

  const _OptionButton({
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.answered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    Color backgroundColor = Colors.transparent;
    Color borderColor = colorScheme.outline;
    Color textColor = colorScheme.onSurface;

    if (answered) {
      if (isCorrect) {
        backgroundColor = Colors.green;
        borderColor = Colors.green;
        textColor = Colors.white;
      } else if (isSelected && !isCorrect) {
        backgroundColor = Colors.red;
        borderColor = Colors.red;
        textColor = Colors.white;
      } else {
        borderColor = colorScheme.outlineVariant.withValues(alpha: 0.5);
        textColor = colorScheme.onSurfaceVariant.withValues(alpha: 0.5);
      }
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: answered ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
