import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/repositories/streak_repository.dart';
import '../../../../data/repositories/progress_repository.dart';
import '../../../../utils/achievement_checker.dart';

part 'streak_event.dart';

part 'streak_state.dart';

part 'generated/streak_bloc.freezed.dart';

class StreakBloc extends Bloc<StreakEvent, StreakState> {
  final StreakRepository _streakRepository;
  final ProgressRepository _progressRepository;
  final AchievementChecker _achievementChecker;
  static const int timePerDayNeeded = 60 * 5; // 5 minutes

  Timer? _streakTimer;

  StreakBloc({
    required StreakRepository streakRepository,
    required ProgressRepository progressRepository,
    required AchievementChecker achievementChecker,
  })  : _streakRepository = streakRepository,
        _progressRepository = progressRepository,
        _achievementChecker = achievementChecker,
        super(const StreakState()) {
    on<StreakEvent>((event, emit) async {
      await event.map(
        watchStreak: (event) => _onWatchStreak(event, emit),
        emitState: (event) => _onEmitState(event, emit),
      );
    });
  }

  Future<void> _onWatchStreak(WatchStreak event, Emitter<StreakState> emit) async {
    // Step 1: Reset streak locally if user missed yesterday (best practice: do this
    // once at startup, not inside a getter to avoid side-effects)
    await _streakRepository.resetStreakIfBroken();

    // Step 2: Sync with server to restore correct values after device change/reinstall
    await _streakRepository.syncWithServer();

    // Step 3: Emit initial state from (now-corrected) local storage
    emit(StreakState(
      spentTimeToday: _streakRepository.getTimeStreak(),
      longestStreak: _streakRepository.longestStreak,
      streak: _streakRepository.streak,
    ));

    // Step 4: Start timer — ticks every second while app is in foreground
    _streakTimer?.cancel();
    _streakTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }

      // Don't keep counting time if user already earned streak today
      if (_streakRepository.streakedToday) return;

      final newSpentTimeToday = _streakRepository.getTimeStreak() + 1;
      _streakRepository.setTimeStreak(newSpentTimeToday);

      // Only rebuild UI when value changed
      if (newSpentTimeToday != state.spentTimeToday) {
        add(StreakEvent.emitState(state.copyWith(spentTimeToday: newSpentTimeToday)));
      }

      // Threshold reached → earn streak for today
      if (newSpentTimeToday >= timePerDayNeeded) {
        final newStreak = _streakRepository.streak + 1;
        // FIX: read longestStreak AFTER newStreak is computed (old code read it before)
        final newLongestStreak = newStreak > _streakRepository.longestStreak
            ? newStreak
            : _streakRepository.longestStreak;

        _streakRepository.setStreak(newStreak); // also updates longestStreak locally
        _achievementChecker.checkStreakAchievements(newStreak);

        // Fire-and-forget server calls (non-blocking)
        _streakRepository.checkInWithServer();
        _progressRepository.logSession(
          timeSpentSeconds: timePerDayNeeded,
          wordsLearned: 0,
          lessonsCompleted: 0,
        );

        add(StreakEvent.emitState(state.copyWith(
          streak: newStreak,
          longestStreak: newLongestStreak,
          spentTimeToday: newSpentTimeToday,
        )));
      }
    });
  }

  Future<void> _onEmitState(EmitState event, Emitter<StreakState> emit) async {
    emit(event.state);
  }

  @override
  Future<void> close() {
    _streakTimer?.cancel();
    _streakTimer = null;
    return super.close();
  }
}

