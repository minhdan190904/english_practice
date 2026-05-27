import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/data_sources/token_storage.dart';
import '../../navigation/app_router.dart';

/// JWT Auth Interceptor — attaches app access token to every request.
/// Uses QueuedInterceptor to handle concurrent 401s without duplicate refreshes.
/// Also handles 403 (Forbidden) by showing session expired dialog and restarting app.
class AuthInterceptor extends QueuedInterceptor {
  final TokenStorage _tokenStorage;
  final Dio _refreshDio; // Separate Dio instance for refresh calls (avoids interceptor loop)
  bool _isRefreshing = false;
  static bool _isShowingSessionExpired = false; // Prevent multiple dialogs

  AuthInterceptor({
    required TokenStorage tokenStorage,
    required Dio refreshDio,
  })  : _tokenStorage = tokenStorage,
        _refreshDio = refreshDio;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Attach access token
    final accessToken = await _tokenStorage.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    // Ngrok bypass header
    options.headers['ngrok-skip-browser-warning'] = 'true';

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // --- Handle 403 Forbidden: session expired / invalid token ---
    if (err.response?.statusCode == 403) {
      debugPrint('🔐 403 Forbidden — phiên đăng nhập hết hạn');
      await _tokenStorage.clearTokens();
      _showSessionExpiredAndRestart();
      return handler.reject(err);
    }

    // --- Handle 401 Unauthorized: try refresh token ---
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;
      try {
        final refreshToken = await _tokenStorage.getRefreshToken();
        if (refreshToken == null || refreshToken.isEmpty) {
          debugPrint('🔐 No refresh token available, rejecting request');
          _isRefreshing = false;
          await _tokenStorage.clearTokens();
          _showSessionExpiredAndRestart();
          return handler.reject(err);
        }

        debugPrint('🔐 Access token expired, refreshing...');

        // Call refresh endpoint using separate Dio (no interceptors)
        final response = await _refreshDio.post(
          '/user/refresh',
          data: {'refreshToken': refreshToken},
        );

        if (response.statusCode == 200) {
          final data = response.data;
          final newAccessToken = data['accessToken'] as String;
          final newRefreshToken = data['refreshToken'] as String;

          // Save new tokens
          await _tokenStorage.saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
          );
          debugPrint('🔐 Tokens refreshed successfully');

          // Retry the original request with new access token
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $newAccessToken';
          final retryResponse = await _refreshDio.fetch(opts);
          _isRefreshing = false;
          return handler.resolve(retryResponse);
        }
      } catch (e) {
        debugPrint('🔐 Token refresh failed: $e');
        // Clear tokens on refresh failure
        await _tokenStorage.clearTokens();
        _showSessionExpiredAndRestart();
      }
      _isRefreshing = false;
    }
    handler.reject(err);
  }

  /// Show a dialog notifying the user their session has expired,
  /// then navigate back to splash screen to re-initialize.
  void _showSessionExpiredAndRestart() {
    if (_isShowingSessionExpired) return;
    _isShowingSessionExpired = true;

    final context = AppRouter.rootNavigatorKey.currentContext;
    if (context == null) {
      _isShowingSessionExpired = false;
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.lock_clock_rounded, size: 48, color: Colors.orange),
        title: const Text('Phiên đã hết hạn'),
        content: const Text(
          'Phiên đăng nhập của bạn đã hết hạn.\n'
          'Ứng dụng sẽ tự động tải lại để lấy phiên mới.',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _isShowingSessionExpired = false;
              // Navigate to splash to re-initialize everything
              context.go(RoutePaths.splash);
            },
            child: const Text('Đồng ý'),
          ),
        ],
      ),
    ).then((_) {
      _isShowingSessionExpired = false;
    });
  }
}
