import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Result type for linking Google account to anonymous user
enum LinkResult {
  success,
  credentialAlreadyInUse,
  cancelled,
  error,
}

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  Stream<User?> get user => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  /// Sign in anonymously (for first-time users)
  Future<UserCredential?> signInAnonymously() async {
    try {
      return await _firebaseAuth.signInAnonymously();
    } catch (e) {
      throw Exception('Failed to sign in anonymously: $e');
    }
  }

  /// Link anonymous account with Google credential
  /// Returns LinkResult indicating what happened
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
        // Try to link the Google credential to the anonymous account
        await currentUser.linkWithCredential(credential);
        // Sync with backend
        await _syncWithBackend();
        return LinkResult.success;
      } else {
        // User is not anonymous, just sign in with Google
        await _firebaseAuth.signInWithCredential(credential);
        await _syncWithBackend();
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

      final credential = await _firebaseAuth.signInWithCredential(credentialObj);

      // Sync with backend
      await _syncWithBackend();

      return credential;
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  /// Use a different Google account (for account conflict resolution)
  Future<LinkResult> linkWithDifferentGoogle() async {
    // Sign out of Google first to force account picker
    await _googleSignIn.signOut();
    // Then try linking again
    return linkWithGoogle();
  }

  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
      // After sign out, sign in anonymously again so user can still use the app
      await _firebaseAuth.signInAnonymously();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  Future<void> _syncWithBackend() async {
    try {
      final token = await _firebaseAuth.currentUser?.getIdToken();
      if (token != null) {
        final dio = GetIt.I<Dio>(instanceName: 'BackendDio');
        await dio.get('/users/me');
      }
    } catch (e) {
      print('Backend sync error: $e');
    }
  }
}
