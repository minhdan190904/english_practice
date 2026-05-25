import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_header.dart';

class BasePage extends StatelessWidget {
  final Widget child;
  final String title;
  final EdgeInsets padding;
  final List<Widget> actions;

  const BasePage({
    super.key,
    required this.child,
    required this.title,
    this.actions = const [],
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).colorScheme.surface;
    final brightness = Theme.of(context).brightness;

    // Restore status bar icons to match current theme whenever this page is visible
    final systemUiStyle = brightness == Brightness.dark
        ? SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
          )
        : SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
          );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiStyle,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppHeader(
                title: title,
                actions: actions,
              ),
              Expanded(
                child: Padding(
                  padding: padding,
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
