import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../configs/di.dart';
import '../../../data/models/saved_lesson.dart';
import '../../../data/repositories/achievement_repository.dart';
import '../../../data/repositories/srs_repository.dart';
import '../../../data/repositories/streak_repository.dart';
import '../../../generated/assets.dart';
import '../../../navigation/app_router.dart';
import '../../../utils/global_values.dart';
import '../vocabulary/bloc/vocabulary_bloc.dart';

/// App splash screen shown during startup initialization.
/// Displays logo, app name, and a smooth loading animation with status text.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;

  late final AnimationController _textController;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  String _statusText = '';
  double _progress = 0.0;
  bool _isDone = false;

  @override
  void initState() {
    super.initState();

    // Logo animation — fade in + scale up with elastic bounce
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoFade = CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Text animation — fade in + slide up (delayed after logo)
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _textFade = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    // Sequence the animations then start sync
    _logoController.forward().then((_) {
      if (mounted) {
        _textController.forward();
        _runSync();
      }
    });
  }

  Future<void> _runSync() async {
    try {
      // Step 1: Sync saved lessons
      _updateStatus('Syncing lessons...', 0.15);
      try {
        final savedLessonsRepo = SavedLessonsRepository();
        await savedLessonsRepo.syncWithServer();
      } catch (_) {}

      // Step 2: Sync SRS + word statuses
      _updateStatus('Syncing vocabulary...', 0.4);
      try {
        final srsRepo = DI().sl<SrsRepository>();
        await srsRepo.syncWithServer();
      } catch (_) {}

      // Step 3: Refresh VocabularyBloc
      _updateStatus('Loading words...', 0.65);
      try {
        final vocabBloc = DI().sl<VocabularyBloc>();
        if (!vocabBloc.isClosed) {
          vocabBloc.refreshWordsFromHive();
        }
      } catch (_) {}

      // Step 4: Sync achievements
      _updateStatus('Syncing progress...', 0.8);
      try {
        final achievementRepo = DI().sl<AchievementRepository>();
        await achievementRepo.syncWithServer();
      } catch (_) {}

      // Step 5: Sync streak
      _updateStatus('Almost done...', 0.9);
      try {
        final streakRepo = DI().sl<StreakRepository>();
        await streakRepo.syncWithServer();
      } catch (_) {}

      // Done!
      _updateStatus('Ready! ✨', 1.0);
      setState(() => _isDone = true);

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      // Navigate to onboarding or home
      if (!GlobalValues.isShowOnboarding) {
        GlobalValues.isShowOnboarding = true;
        context.go(RoutePaths.onboarding);
      } else {
        context.go(RoutePaths.vocabulary);
      }
    } catch (e) {
      debugPrint('Splash sync error: $e');
      if (mounted) context.go(RoutePaths.vocabulary);
    }
  }

  void _updateStatus(String text, double progress) {
    if (!mounted) return;
    setState(() {
      _statusText = text;
      _progress = progress;
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Logo with glow ──
              FadeTransition(
                opacity: _logoFade,
                child: ScaleTransition(
                  scale: _logoScale,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: isDark ? 0.4 : 0.25),
                          blurRadius: 50,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(36),
                      child: Image.asset(
                        Assets.pngLauncherPlaystore,
                        width: 130,
                        height: 130,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // ── App name + tagline ──
              SlideTransition(
                position: _textSlide,
                child: FadeTransition(
                  opacity: _textFade,
                  child: Column(
                    children: [
                      Text(
                        'English Handbook',
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onSurface,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Master English, One Word at a Time',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // ── Progress bar ──
              FadeTransition(
                opacity: _textFade,
                child: Column(
                  children: [
                    // Smooth animated progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: SizedBox(
                        height: 5,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: _progress),
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                          builder: (context, value, _) {
                            return LinearProgressIndicator(
                              value: value,
                              backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _isDone
                                    ? Colors.green.shade400
                                    : colorScheme.primary.withValues(alpha: 0.8),
                              ),
                              minHeight: 5,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Status text with animated switch
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        key: ValueKey(_statusText),
                        children: [
                          if (_isDone)
                            Icon(
                              Icons.check_circle_rounded,
                              size: 16,
                              color: Colors.green.shade400,
                            )
                          else
                            SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                color: colorScheme.primary.withValues(alpha: 0.5),
                              ),
                            ),
                          const SizedBox(width: 8),
                          Text(
                            _statusText,
                            style: TextStyle(
                              fontSize: 13,
                              color: colorScheme.onSurface.withValues(alpha: 0.45),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
