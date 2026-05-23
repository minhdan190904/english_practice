import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/auth_repository.dart';
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

  /// Link anonymous account with Google
  Future<LinkResult> linkWithGoogle() async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      final result = await _authRepository.linkWithGoogle();
      emit(state.copyWith(isLoading: false));
      return result;
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      return LinkResult.error;
    }
  }

  /// Sign in directly with Google (used when user chooses to load existing data)
  Future<void> signInWithGoogle() async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      await _authRepository.signInWithGoogle();
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  /// Use a different Google account to link
  Future<LinkResult> linkWithDifferentGoogle() async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      final result = await _authRepository.linkWithDifferentGoogle();
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
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
