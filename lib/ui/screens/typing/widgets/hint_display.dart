import 'package:flutter/material.dart';

/// Displays a word as letter boxes with hints based on hint level.
/// - Level 0: All underscores `_ _ _ _ _ _ _`
/// - Level 1: First and last letter shown `a _ _ _ _ _ n`
/// - Level 2: Alternating letters `a _ a _ d _ n`
/// - Level 3: Full word revealed
class HintDisplay extends StatelessWidget {
  final String word;
  final int hintLevel;

  const HintDisplay({
    super.key,
    required this.word,
    required this.hintLevel,
  });

  bool _isRevealed(int index) {
    switch (hintLevel) {
      case 0:
        return false;
      case 1:
        return index == 0 || index == word.length - 1;
      case 2:
        return index % 2 == 0 || index == word.length - 1;
      default: // 3+
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 3,
          runSpacing: 4,
          children: List.generate(word.length, (index) {
            final isLetter = RegExp(r"[a-zA-Z]").hasMatch(word[index]);
            if (!isLetter) {
              // Non-letter chars (apostrophe, hyphen) always shown
              return SizedBox(
                width: 20,
                height: 36,
                child: Center(
                  child: Text(
                    word[index],
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              );
            }

            final revealed = _isRevealed(index);
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: 28,
              height: 36,
              decoration: BoxDecoration(
                color: revealed
                    ? colorScheme.primaryContainer.withValues(alpha: 0.6)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: revealed
                      ? colorScheme.primary.withValues(alpha: 0.3)
                      : Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    revealed ? word[index].toUpperCase() : '_',
                    key: ValueKey('${index}_${revealed}_$hintLevel'),
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: revealed ? colorScheme.primary : Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          '(${word.length} letters)',
          style: textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}
