import '../../../../utils/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:english_practice/ui/commons/rounded_button.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:share_plus/share_plus.dart';

import '../../../generated/assets.dart';
import '../../../utils/global_values.dart';
import '../../commons/ads/banner_ad_widget.dart';
import '../../commons/base_page.dart';
import 'bloc/streak_bloc.dart';

class StreakScreen extends StatefulWidget {
  const StreakScreen({super.key});

  @override
  State<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends State<StreakScreen> {
  bool _isShared = GlobalValues.isShowFreeTrial;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    return BlocBuilder<StreakBloc, StreakState>(
      builder: (context, state) {
        final percent = state.spentTimeToday / StreakBloc.timePerDayNeeded;
        return Column(
          children: [
            Expanded(
              child: BasePage(
                title: "Streak",
                actions: [
                  Text(
                    "Longest: ",
                    style: textTheme.titleSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Image.asset(Assets.pngFlame, width: 16),
                  const SizedBox(width: 2.0),
                  Text(
                    state.longestStreak.toString(),
                    style: textTheme.titleSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: size.shortestSide * 0.2,
                      child: CircularPercentIndicator(
                        radius: size.shortestSide * 0.2,
                        lineWidth: 10.0,
                        circularStrokeCap: CircularStrokeCap.round,
                        percent: percent > 1 ? 1 : percent,
                        center: Image.asset(state.streak != 0 ? Assets.pngFlame : Assets.pngFlameInactive),
                        progressColor: const Color(0xFFf5a623),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      state.streak.toString(),
                      style: textTheme.headlineLarge?.copyWith(
                        color: state.streak != 0 ? const Color(0xFFf5a623) : colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Streaks",
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "Keep up the good work!",
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.secondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      "Study at least 5 minutes a day to keep the streak going! Small steps lead to big results. 🚀",
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.secondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16.0),
                    if (!_isShared) RoundedButton(
                      borderRadius: 16,
                      onPressed: state.streak != 0 ? () async {
                        final result = await Share.share('''🚀 Master English with 6000 Oxford Words and Grammar Handbook! 📚✨
🔥 I have been studying English for ${state.streak} days in a row! 🔥
Boost your English skill with:
  ✅ 6000 Oxford Words – Learn essential English words
  ✅ Flashcards – Easy and effective memorization
  ✅ Notification Reminders – Never miss a learning session
  ✅ Grammar Handbook – Master English grammar
Start your journey to fluent English today! 🔥📖
👉 ${const String.fromEnvironment("APP_URL")}
''');
                        if (result.status == ShareResultStatus.success && mounted) {
                          setState(() {
                            _isShared = true;
                          });
                          GlobalValues.isShowFreeTrial = true;
                        }
                      } : null,
                      child: Text(L10n.tr(context, 'share_streak_for_trial')),
                    )
                  ],
                ),
              ),
            ),
            const BannerAdWidget(),
          ],
        );
      },
    );
  }
}
