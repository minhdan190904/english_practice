import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../data_sources/token_storage.dart';
import '../models/saved_lesson.dart';
import '../../configs/app_secrets.dart';

/// Result type for linking Google account to anonymous user
enum LinkResult {
  success,
  credentialAlreadyInUse,
  cancelled,
  error,
}

class AuthRepository {
  static const String _apiKey = AppSecrets.apiClientKey;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final TokenStorage _tokenStorage;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    required TokenStorage tokenStorage,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _tokenStorage = tokenStorage;

  Stream<User?> get user => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  /// Register/login with backend — exchanges Firebase token for app JWT.
  /// Called after any Firebase sign-in (anonymous or Google).
  Future<void> registerWithBackend() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) {
        debugPrint('🔐 No Firebase user, skipping backend register');
        return;
      }

      final firebaseToken = await firebaseUser.getIdToken();
      if (firebaseToken == null) {
        debugPrint('🔐 No Firebase token, skipping backend register');
        return;
      }

      debugPrint('🔐 Registering with backend...');
      final dio = GetIt.I<Dio>(instanceName: 'BackendDio');
      
      // Use a raw Dio call without auth interceptor for register
      final rawDio = Dio()
        ..options = BaseOptions(
          baseUrl: dio.options.baseUrl,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'ngrok-skip-browser-warning': 'true',
            'X-API-KEY': _apiKey,
          },
          connectTimeout: dio.options.connectTimeout,
          receiveTimeout: dio.options.receiveTimeout,
        );

      final response = await rawDio.post(
        '/user/register',
        data: {'firebaseToken': firebaseToken},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        await _tokenStorage.saveTokens(
          accessToken: data['accessToken'] as String,
          refreshToken: data['refreshToken'] as String,
        );
        debugPrint('🔐 ✅ Backend register success — tokens saved');
      }
    } catch (e) {
      debugPrint('🔐 ❌ Backend register error: $e');
    }
  }

  /// Refresh app JWT tokens using the stored refresh token.
  Future<bool> refreshTokens() async {
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null) return false;

      final dio = GetIt.I<Dio>(instanceName: 'BackendDio');
      final rawDio = Dio()
        ..options = BaseOptions(
          baseUrl: dio.options.baseUrl,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'ngrok-skip-browser-warning': 'true',
            'X-API-KEY': _apiKey,
          },
        );

      final response = await rawDio.post(
        '/user/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        await _tokenStorage.saveTokens(
          accessToken: data['accessToken'] as String,
          refreshToken: data['refreshToken'] as String,
        );
        debugPrint('🔐 ✅ Token refresh success');
        return true;
      }
    } catch (e) {
      debugPrint('🔐 ❌ Token refresh failed: $e');
    }
    return false;
  }

  /// Sign in anonymously (for first-time users)
  Future<UserCredential?> signInAnonymously() async {
    try {
      final credential = await _firebaseAuth.signInAnonymously();
      // Register with backend to get app JWT
      await registerWithBackend();
      return credential;
    } catch (e) {
      throw Exception('Failed to sign in anonymously: $e');
    }
  }

  /// Link anonymous account with Google credential
  Future<LinkResult> linkWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return LinkResult.cancelled;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final currentUser = _firebaseAuth.currentUser;
      if (currentUser != null && currentUser.isAnonymous) {
        await currentUser.linkWithCredential(credential);
        // Re-register with backend (now has email)
        await registerWithBackend();
        return LinkResult.success;
      } else {
        await _firebaseAuth.signInWithCredential(credential);
        await registerWithBackend();
        return LinkResult.success;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use' || e.code == 'provider-already-linked') {
        return LinkResult.credentialAlreadyInUse;
      }
      throw Exception('Failed to link with Google: $e');
    } catch (e) {
      throw Exception('Failed to link with Google: $e');
    }
  }

  /// Sign in directly with Google (for loading existing data)
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credentialObj = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign out current anonymous user first
      await _firebaseAuth.signOut();
      await _tokenStorage.clearTokens();

      final credential = await _firebaseAuth.signInWithCredential(credentialObj);

      // Register with backend
      await registerWithBackend();

      return credential;
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  /// Use a different Google account (for account conflict resolution)
  Future<LinkResult> linkWithDifferentGoogle() async {
    await _googleSignIn.signOut();
    return linkWithGoogle();
  }

  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
        _tokenStorage.clearTokens(),
      ]);
      // Clear local data from previous account
      await SavedLessonsRepository().clearLocal();
      // After sign out, sign in anonymously again so user can still use the app
      await _firebaseAuth.signInAnonymously();
      await registerWithBackend();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }
}
