import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/saved_lesson.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/streak_repository.dart';
import '../../../configs/di.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthState(user: authRepository.currentUser)) {
    _authRepository.user.listen((user) {
      emit(AuthState(user: user));
    });
  }

  /// Force refresh the current user state from Firebase
  void _refreshUser() {
    final user = _authRepository.currentUser;
    emit(AuthState(user: user));
  }

  /// Sync all data from server after account switch.
  /// IMPORTANT: clears local data first to avoid merging old account's data.
  Future<void> _syncAllData() async {
    try {
      debugPrint('🔄 Account switch — clearing local data & pulling from server...');

      // 1. Clear all local data (old account's data)
      final lessonsRepo = SavedLessonsRepository();
      await lessonsRepo.clearLocal();

      // 2. Pull fresh data from new account's server
      await lessonsRepo.pullFromServer();

      // 3. Sync Streak
      try {
        final streakRepo = DI().sl<StreakRepository>();
        await streakRepo.syncWithServer();
      } catch (e) {
        debugPrint('🔄 Streak sync skipped: $e');
      }

      debugPrint('🔄 ✅ All data synced for new account!');
    } catch (e) {
      debugPrint('🔄 ❌ Data sync error: $e');
    }
  }

  /// Link anonymous account with Google
  Future<LinkResult> linkWithGoogle() async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      final result = await _authRepository.linkWithGoogle();

      // Force reload Firebase user to get updated profile (name, email, photo)
      await FirebaseAuth.instance.currentUser?.reload();
      _refreshUser();

      if (result == LinkResult.success) {
        // Sync all data from the newly linked account
        await _syncAllData();
      }

      emit(state.copyWith(isLoading: false));
      return result;
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      return LinkResult.error;
    }
  }

  /// Sign in directly with Google (used when user chooses to load existing data)
  Future<bool> signInWithGoogle() async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      final credential = await _authRepository.signInWithGoogle();

      if (credential == null) {
        emit(state.copyWith(isLoading: false));
        return false;
      }

      // Force reload Firebase user to get updated profile
      await FirebaseAuth.instance.currentUser?.reload();
      _refreshUser();

      // Sync all data from the existing account
      await _syncAllData();

      emit(state.copyWith(isLoading: false));
      return true;
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      return false;
    }
  }

  /// Use a different Google account to link
  Future<LinkResult> linkWithDifferentGoogle() async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      final result = await _authRepository.linkWithDifferentGoogle();
      await FirebaseAuth.instance.currentUser?.reload();
      _refreshUser();

      if (result == LinkResult.success) {
        await _syncAllData();
      }

      emit(state.copyWith(isLoading: false));
      return result;
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      return LinkResult.error;
    }
  }

  Future<void> signOut() async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      await _authRepository.signOut();
      _refreshUser();
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
