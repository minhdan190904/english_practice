import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/failure.dart';
import '../../../generated/assets.dart';
import '../../../utils/app_snack_bar.dart';
import '../../../utils/extensions/go_router_extension.dart';
import '../../../navigation/app_router.dart';
import '../notifications/bloc/notifications_bloc.dart';
import '../streak/bloc/streak_bloc.dart';
import '../vocabulary/bloc/vocabulary_bloc.dart';
import '../settings/bloc/settings_bloc.dart';
import '../../../utils/l10n.dart';
import 'widget/streak_button.dart';

class HomeNavigation extends StatefulWidget {
  final StatefulNavigationShell child;

  const HomeNavigation({super.key, required this.child});

  /// Thứ tự tabs: Vocabulary(0) → AI(1) → Progress(2) → Grammar(3) → Settings(4)
  static const routes = [
    RoutePaths.vocabulary,
    RoutePaths.aiLesson,
    RoutePaths.progress,
    RoutePaths.grammar,
    RoutePaths.settings,
  ];

  static const unselectedIcons = [
    Assets.svgVocabularyThin,
    Assets.svgAiLessonThin,
    Assets.svgStreakThin,
    Assets.svgGrammarThin,
    Assets.svgSettingThin,
  ];

  static const selectedIcons = [
    Assets.svgVocabularyFilled,
    Assets.svgAiLessonFilled,
    Assets.svgStreakFilled,
    Assets.svgGrammarFilled,
    Assets.svgSettingFilled,
  ];

  static const translationKeys = [
    "vocabulary",
    "ai_lesson",
    "progress",
    "grammar",
    "settings",
  ];

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  late final AppLifecycleListener _appLifecycleListener;
  bool _didInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      _didInit = true;
      _initBlocs();
    }
  }

  void _initBlocs() {
    final notifBloc = context.read<NotificationsBloc>();
    if (!notifBloc.isClosed) {
      notifBloc.add(const NotificationsEvent.requestPermissions());
      notifBloc.add(const NotificationsEvent.handleOpenAppFromNotification());
    }
    final streakBloc = context.read<StreakBloc>();
    if (!streakBloc.isClosed) {
      streakBloc.add(const StreakEvent.watchStreak());
    }
    final vocabBloc = context.read<VocabularyBloc>();
    if (!vocabBloc.isClosed) {
      vocabBloc.add(const VocabularyEvent.getAllOxfordWords());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch settings bloc to rebuild bottom bar on locale change
    context.watch<SettingsBloc>().state.settingsSnapshot.locale;
    final colorScheme = Theme.of(context).colorScheme;

    // Dùng currentIndex của shell để xác định tab đang active,
    // tránh lỗi khi đang ở sub-route (flashcards, word_details...)
    final currentRoute = GoRouter.of(context).currentRoute;
    var selectedIndex = HomeNavigation.routes.indexOf(currentRoute);
    if (selectedIndex == -1) {
      // Sub-route (flashcards, word_details, review, category, lesson...): dùng currentIndex của shell
      selectedIndex = widget.child.currentIndex;
    }

    final selectedColor = colorScheme.primary;
    final unselectedColor = Colors.grey[600]!;

    return MultiBlocListener(
      listeners: [
        BlocListener<NotificationsBloc, NotificationsState>(
          listener: (context, state) {
            _handleError(context, state.failure);
            if (state.wordIdFromNotification != null) {
              context.go(RoutePaths.vocabulary, extra: {'wordId': state.wordIdFromNotification});
            }
            if (state.message != null) {
              AppSnackBar.showSuccess(context, state.message!);
            }
          },
        ),
      ],
      child: Scaffold(
        // StreakButton chỉ hiện ở Tab 0 (Vocabulary branch)
        // [BUG FIX] Dùng context.push thay vì goBranch vì /streak là top-level route (ngoài StatefulShell)
        floatingActionButton: widget.child.currentIndex == 0
            ? StreakButton(
                onPressed: () {
                  context.push(RoutePaths.streak);
                },
              )
            : null,
        body: widget.child,
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            showUnselectedLabels: true,
            currentIndex: selectedIndex == -1 ? 0 : selectedIndex,
            selectedFontSize: 12,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: selectedColor,
            unselectedItemColor: unselectedColor,
            onTap: _onSelect,
            items: List.generate(
              HomeNavigation.translationKeys.length,
              (index) => BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: SvgPicture.asset(
                    index == selectedIndex ? HomeNavigation.selectedIcons[index] : HomeNavigation.unselectedIcons[index],
                    colorFilter: ColorFilter.mode(
                      index == selectedIndex ? selectedColor : unselectedColor,
                      BlendMode.srcIn,
                    ),
                    height: 24,
                  ),
                ),
                label: L10n.tr(context, HomeNavigation.translationKeys[index]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _appLifecycleListener = AppLifecycleListener(
      onShow: () {
        debugPrint('NotificationsScreen: onShow');
        // Use mounted check + context.read to always get the current bloc instance
        if (mounted) {
          final bloc = context.read<NotificationsBloc>();
          if (!bloc.isClosed) {
            bloc.add(const NotificationsEvent.requestPermissions());
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _appLifecycleListener.dispose();
    super.dispose();
  }

  void _onSelect(int value) {
    widget.child.goBranch(value);
  }

  void _handleError(BuildContext context, Failure? failure) {
    if (failure != null) {
      AppSnackBar.showError(context, failure.message);
    }
  }
}
