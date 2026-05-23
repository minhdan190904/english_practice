import '../../../utils/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../generated/assets.dart';

class PaywallPage extends StatelessWidget {
  const PaywallPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final spacing = size.width <= 320 ? 2.0 : 8.0;
    return Column(
      children: [
        SizedBox(height: spacing),
        ListTile(
          leading: SvgPicture.asset(Assets.svgTimerPlay, color: colorScheme.primary, width: 24, height: 24),
          title: Text(L10n.tr(context, 'no_ads'), style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface)),
          subtitle: Text(L10n.tr(context, 'enjoy_no_ads')),
        ),
        ListTile(
          leading: Icon(Icons.group, color: colorScheme.primary),
          title: Text(L10n.tr(context, 'support_anywhere'), style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface)),
          subtitle: Text(L10n.tr(context, 'get_support')),
        ),
        ListTile(
          leading: Icon(Icons.check, color: colorScheme.primary),
          title: Text(L10n.tr(context, 'best_performance'), style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface)),
          subtitle: Text(L10n.tr(context, 'server_prioritize')),
        ),
      ],
    );
  }
}
