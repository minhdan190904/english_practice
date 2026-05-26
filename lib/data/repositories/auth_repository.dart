import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../data_sources/token_storage.dart';
import '../models/app_user.dart';
import '../../configs/app_secrets.dart';

/// Result of checking if a Google account exists on the backend
class CheckGoogleResult {
  final bool exists;
  final int? existingUserId;
  final String? existingEmail;
  final String? existingDisplayName;
  final String? existingAvatarUrl;

  CheckGoogleResult({
    required this.exists,
    this.existingUserId,
    this.existingEmail,
    this.existingDisplayName,
    this.existingAvatarUrl,
  });

  factory CheckGoogleResult.fromJson(Map<String, dynamic> json) {
    return CheckGoogleResult(
      exists: json['exists'] as bool,
      existingUserId: json['existingUserId'] as int?,
      existingEmail: json['existingEmail'] as String?,
      existingDisplayName: json['existingDisplayName'] as String?,
      existingAvatarUrl: json['existingAvatarUrl'] as String?,
    );
  }
}

/// Result type for Google sync operations
enum SyncResult {
  success,
  cancelled,
  error,
}

class AuthRepository {
  static const String _apiKey = AppSecrets.apiClientKey;

  final GoogleSignIn _googleSignIn;
  final TokenStorage _tokenStorage;

  /// Cached user info from backend
  AppUser? _currentUser;

  AuthRepository({
    GoogleSignIn? googleSignIn,
    required TokenStorage tokenStorage,
  })  : _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _tokenStorage = tokenStorage;

  AppUser? get currentUser => _currentUser;

  /// Get a raw Dio (no auth interceptor) for public endpoints
  Dio _rawDio() {
    final dio = GetIt.I<Dio>(instanceName: 'BackendDio');
    return Dio()
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
  }

  /// Get authenticated Dio for protected endpoints
  Dio _authedDio() {
    return GetIt.I<Dio>(instanceName: 'BackendDio');
  }

  // ─── Device ID Registration ────────────────────────────────────

  /// Register/login with Android device ID.
  /// Called on app start — creates a guest account or returns existing one.
  Future<AppUser?> registerWithDeviceId(String deviceId) async {
    try {
      debugPrint('🔐 Registering with device ID: $deviceId');
      final response = await _rawDio().post(
        '/user/register-device',
        data: {'deviceId': deviceId},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        await _tokenStorage.saveTokens(
          accessToken: data['accessToken'] as String,
          refreshToken: data['refreshToken'] as String,
        );

        if (data['user'] != null) {
          _currentUser = AppUser.fromJson(data['user'] as Map<String, dynamic>);
        }

        debugPrint('🔐 ✅ Device register success — user: ${_currentUser?.id}');
        return _currentUser;
      }
    } catch (e) {
      debugPrint('🔐 ❌ Device register error: $e');
    }
    return null;
  }

  // ─── Google Sign-In Helper ─────────────────────────────────────

  /// Perform Google Sign-In and get Firebase ID token.
  /// Returns null if cancelled.
  Future<String?> getFirebaseIdToken({bool forceNewAccount = false}) async {
    try {
      if (forceNewAccount) {
        await _googleSignIn.signOut();
      }

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // cancelled

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final firebase_auth.OAuthCredential credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final firebase_auth.UserCredential firebaseCredential =
          await firebase_auth.FirebaseAuth.instance.signInWithCredential(credential);

      final String? firebaseIdToken = await firebaseCredential.user?.getIdToken();
      return firebaseIdToken;
    } catch (e) {
      debugPrint('🔐 ❌ getFirebaseIdToken error: $e');
      return null;
    }
  }

  // ─── Check Google ──────────────────────────────────────────────

  /// Check if a Google account is already linked to an existing user.
  Future<CheckGoogleResult?> checkGoogle(String firebaseIdToken) async {
    try {
      final response = await _authedDio().post(
        '/user/check-google',
        data: {'googleIdToken': firebaseIdToken},
      );

      if (response.statusCode == 200) {
        return CheckGoogleResult.fromJson(response.data as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('🔐 ❌ Check Google error: $e');
    }
    return null;
  }

  // ─── Link Google ───────────────────────────────────────────────

  /// Link Google account to current account (keeps current ID, adds Google info).
  /// Used when user wants to sync their current guest account with Google.
  Future<SyncResult> linkGoogle(String firebaseIdToken) async {
    try {
      final response = await _authedDio().post(
        '/user/link-google',
        data: {'googleIdToken': firebaseIdToken},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        await _tokenStorage.saveTokens(
          accessToken: data['accessToken'] as String,
          refreshToken: data['refreshToken'] as String,
        );
        if (data['user'] != null) {
          _currentUser = AppUser.fromJson(data['user'] as Map<String, dynamic>);
        }
        debugPrint('🔐 ✅ Google linked successfully');
        return SyncResult.success;
      }
      return SyncResult.error;
    } catch (e) {
      debugPrint('🔐 ❌ Link Google error: $e');
      return SyncResult.error;
    }
  }

  // ─── Switch to existing Google account ─────────────────────────

  /// Switch to an EXISTING Google-linked account.
  /// Abandons current account and logs into the target account.
  Future<SyncResult> switchToGoogleAccount(String firebaseIdToken) async {
    try {
      final response = await _authedDio().post(
        '/user/switch-to-google',
        data: {'googleIdToken': firebaseIdToken},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        await _tokenStorage.saveTokens(
          accessToken: data['accessToken'] as String,
          refreshToken: data['refreshToken'] as String,
        );
        if (data['user'] != null) {
          _currentUser = AppUser.fromJson(data['user'] as Map<String, dynamic>);
        }
        debugPrint('🔐 ✅ Switched to Google account');
        return SyncResult.success;
      }
      return SyncResult.error;
    } catch (e) {
      debugPrint('🔐 ❌ Switch to Google error: $e');
      return SyncResult.error;
    }
  }

  // ─── Create new account with Google ────────────────────────────

  /// Create a brand new INDEPENDENT account using Google info.
  /// The old account stays as-is. This creates a completely separate account.
  Future<SyncResult> createWithGoogle(String firebaseIdToken) async {
    try {
      final response = await _authedDio().post(
        '/user/create-with-google',
        data: {'googleIdToken': firebaseIdToken},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        await _tokenStorage.saveTokens(
          accessToken: data['accessToken'] as String,
          refreshToken: data['refreshToken'] as String,
        );
        if (data['user'] != null) {
          _currentUser = AppUser.fromJson(data['user'] as Map<String, dynamic>);
        }
        debugPrint('🔐 ✅ Created new account with Google');
        return SyncResult.success;
      }
      return SyncResult.error;
    } catch (e) {
      debugPrint('🔐 ❌ Create with Google error: $e');
      return SyncResult.error;
    }
  }

  // ─── Token Management ──────────────────────────────────────────

  /// Refresh app JWT tokens using the stored refresh token.
  Future<bool> refreshTokens() async {
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _rawDio().post(
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

  /// Fetch current user info from backend
  Future<AppUser?> fetchUserInfo() async {
    try {
      final response = await _authedDio().get('/user/me');
      if (response.statusCode == 200) {
        _currentUser = AppUser.fromJson(response.data as Map<String, dynamic>);
        return _currentUser;
      }
    } catch (e) {
      debugPrint('🔐 ❌ Fetch user info error: $e');
    }
    return null;
  }
}
