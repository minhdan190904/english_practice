import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/app_user.dart';
import '../../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthState(user: authRepository.currentUser));

  AuthRepository get repository => _authRepository;

  /// Initialize with user info (called after registerWithDeviceId)
  void setUser(AppUser? user) {
    if (!isClosed) {
      emit(AuthState(user: user));
    }
  }

  /// Get Firebase ID token from Google Sign-In.
  /// Returns null if user cancelled.
  Future<String?> getFirebaseIdToken({bool forceNewAccount = false}) async {
    return _authRepository.getFirebaseIdToken(forceNewAccount: forceNewAccount);
  }

  /// Check if Google account exists on backend
  Future<CheckGoogleResult?> checkGoogle(String firebaseIdToken) async {
    return _authRepository.checkGoogle(firebaseIdToken);
  }

  /// Link current device account with Google (keeps current ID, attaches Google info)
  Future<SyncResult> linkGoogle(String firebaseIdToken) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      final result = await _authRepository.linkGoogle(firebaseIdToken);
      if (result == SyncResult.success) {
        emit(AuthState(user: _authRepository.currentUser, isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false));
      }
      return result;
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      return SyncResult.error;
    }
  }

  /// Switch to an existing Google-linked account (abandons current account, logs into that one)
  Future<SyncResult> switchToGoogleAccount(String firebaseIdToken) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      final result = await _authRepository.switchToGoogleAccount(firebaseIdToken);
      if (result == SyncResult.success) {
        emit(AuthState(user: _authRepository.currentUser, isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false));
      }
      return result;
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      return SyncResult.error;
    }
  }

  /// Create a brand new independent account using Google info
  Future<SyncResult> createWithGoogle(String firebaseIdToken) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      final result = await _authRepository.createWithGoogle(firebaseIdToken);
      if (result == SyncResult.success) {
        emit(AuthState(user: _authRepository.currentUser, isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false));
      }
      return result;
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      return SyncResult.error;
    }
  }
}
