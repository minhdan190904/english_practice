import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/saved_lesson.dart';
import '../../../data/repositories/streak_repository.dart';
import '../../../data/repositories/srs_repository.dart';
import '../../../data/repositories/achievement_repository.dart';
import '../../../configs/di.dart';
import '../../../generated/assets.dart';
import '../../../navigation/app_router.dart';
import '../settings/bloc/settings_bloc.dart';

/// Full-screen splash shown after login/signout.
/// Re-initializes tokens + syncs data, then navigates to home.
class PostAuthSplashScreen extends StatefulWidget {
  /// 'login' or 'signout'
  final String mode;

  const PostAuthSplashScreen({super.key, required this.mode});

  @override
  State<PostAuthSplashScreen> createState() => _PostAuthSplashScreenState();
}

class _PostAuthSplashScreenState extends State<PostAuthSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  late final Animation<double> _scale;

  String _statusText = '';
  bool _isDone = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) => _runInit());
  }

  Future<void> _runInit() async {
    try {
      setState(() => _statusText = _getStatusText(0));

      if (widget.mode == 'login') {
        // Google was just linked — tokens already updated by linkWithGoogle
        // Clear old local data + pull from server
        setState(() => _statusText = _getStatusText(2));
        final lessonsRepo = SavedLessonsRepository();
        await lessonsRepo.clearLocal();
        await lessonsRepo.pullFromServer();

        // Sync streak
        setState(() => _statusText = _getStatusText(3));
        try {
          final streakRepo = DI().sl<StreakRepository>();
          await streakRepo.syncWithServer();
        } catch (_) {}

        // Pull SRS and achievements for new account
        try {
          final srsRepo = DI().sl<SrsRepository>();
          await srsRepo.pullFromServer();
        } catch (_) {}
        try {
          final achievementRepo = DI().sl<AchievementRepository>();
          await achievementRepo.pullFromServer();
        } catch (_) {}
      } else {
        // Sign out flow — Google unlinked, already back to device account
        setState(() => _statusText = _getStatusText(1));
        await Future.delayed(const Duration(milliseconds: 600));
      }

      setState(() {
        _statusText = _getStatusText(4);
        _isDone = true;
      });

      // Brief pause to show "Done!" then navigate
      await Future.delayed(const Duration(milliseconds: 800));

      if (!mounted) return;
      context.go(RoutePaths.vocabulary);
    } catch (e) {
      debugPrint('PostAuthSplash error: $e');
      if (mounted) context.go(RoutePaths.vocabulary);
    }
  }

  String _getStatusText(int step) {
    final locale = context.read<SettingsBloc>().state.settingsSnapshot.locale;
    final isVi = locale == 'vi';
    if (widget.mode == 'login') {
      switch (step) {
        case 0: return isVi ? 'Đang khởi tạo...' : 'Initializing...';
        case 2: return isVi ? 'Đang đồng bộ dữ liệu...' : 'Syncing data...';
        case 3: return isVi ? 'Đang cập nhật tiến trình...' : 'Updating progress...';
        case 4: return isVi ? 'Hoàn tất! ✨' : 'All done! ✨';
        default: return '';
      }
    } else {
      switch (step) {
        case 0: return isVi ? 'Đang đăng xuất...' : 'Signing out...';
        case 1: return isVi ? 'Đang cập nhật phiên...' : 'Updating session...';
        case 4: return isVi ? 'Hoàn tất! ✨' : 'All done! ✨';
        default: return '';
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: FadeTransition(
          opacity: _fadeIn,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // App logo
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 40,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Image.asset(
                      Assets.pngLauncher,
                      width: 120,
                      height: 120,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // App name
                Text(
                  'VG English',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 32),

                // Loading indicator
                if (!_isDone)
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: colorScheme.primary,
                    ),
                  )
                else
                  Icon(
                    Icons.check_circle_rounded,
                    size: 32,
                    color: Colors.green.shade500,
                  ),
                const SizedBox(height: 16),

                // Status text
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _statusText,
                    key: ValueKey(_statusText),
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
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
