import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../data/data_sources/token_storage.dart';

/// JWT Auth Interceptor — attaches app access token to every request.
/// Uses QueuedInterceptor to handle concurrent 401s without duplicate refreshes.
class AuthInterceptor extends QueuedInterceptor {
  final TokenStorage _tokenStorage;
  final Dio _refreshDio; // Separate Dio instance for refresh calls (avoids interceptor loop)
  bool _isRefreshing = false;

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
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;
      try {
        final refreshToken = await _tokenStorage.getRefreshToken();
        if (refreshToken == null || refreshToken.isEmpty) {
          debugPrint('🔐 No refresh token available, rejecting request');
          _isRefreshing = false;
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
      }
      _isRefreshing = false;
    }
    handler.reject(err);
  }
}
