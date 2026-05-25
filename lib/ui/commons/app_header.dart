import 'package:flutter/material.dart';
import 'svg_button.dart';
import '../../../generated/assets.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final List<Widget> actions;

  const AppHeader({
    super.key,
    required this.title,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final canPop = Navigator.of(context).canPop();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
      child: Row(
        children: [
          // Left: back button or fixed-width spacer to balance title centering
          if (canPop)
            SvgButton(
              svg: Assets.svgArrowBackIos,
              color: colorScheme.primary,
              onPressed: () => Navigator.of(context).pop(),
            )
          else
            const SizedBox(width: 40),
          // Center: title
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ),
          // Right: actions or fixed-width spacer to balance
          if (actions.isNotEmpty)
            Row(mainAxisSize: MainAxisSize.min, children: actions)
          else
            const SizedBox(width: 40),
        ],
      ),
    );
  }
}
