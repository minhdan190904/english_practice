import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import '../../data/data_sources/token_storage.dart';
import '../app_secrets.dart';
import 'connectivity_interceptor.dart';
import 'logging_interceptor.dart';
import 'auth_interceptor.dart';

export 'connectivity_interceptor.dart';
export 'logging_interceptor.dart';

abstract class AppDio {
  Dio? _dio;

  Dio get dio {
    _dio ??= _get();
    return _dio!;
  }

  Dio _get();
}

class TranslationDio extends AppDio {
  final int _connectTimeout = 60000;
  final int _receiveTimeout = 60000;
  final Connectivity _connectivity;

  TranslationDio({
    required Connectivity connectivity,
  }) : _connectivity = connectivity;

  @override
  Dio _get() {
    return Dio()
      ..options = BaseOptions(
        baseUrl: const String.fromEnvironment("TRANSLATION_BASE_URL"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        connectTimeout: Duration(milliseconds: _connectTimeout),
        receiveTimeout: Duration(milliseconds: _receiveTimeout),
      )
      ..interceptors.addAll([
        LoggingInterceptor(),
        ConnectivityInterceptor(
          connectivity: _connectivity,
        ),
      ]);
  }
}

class BackendDio extends AppDio {
  final int _connectTimeout = 60000;
  final int _receiveTimeout = 60000;
  final Connectivity _connectivity;
  final TokenStorage _tokenStorage;

  static const String _baseUrl = "http://152.42.188.203:8080/api/v1";
  static const String _apiKey = AppSecrets.apiClientKey;

  BackendDio({
    required Connectivity connectivity,
    required TokenStorage tokenStorage,
  }) : _connectivity = connectivity,
       _tokenStorage = tokenStorage;

  @override
  Dio _get() {
    // Separate Dio for refresh calls (no auth interceptor to avoid loops)
    final refreshDio = Dio()
      ..options = BaseOptions(
        baseUrl: _baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          'X-API-KEY': _apiKey,
        },
        connectTimeout: Duration(milliseconds: _connectTimeout),
        receiveTimeout: Duration(milliseconds: _receiveTimeout),
      )
      ..interceptors.addAll([
        LoggingInterceptor(),
      ]);

    return Dio()
      ..options = BaseOptions(
        baseUrl: _baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-API-KEY': _apiKey,
        },
        connectTimeout: Duration(milliseconds: _connectTimeout),
        receiveTimeout: Duration(milliseconds: _receiveTimeout),
      )
      ..interceptors.addAll([
        LoggingInterceptor(),
        ConnectivityInterceptor(
          connectivity: _connectivity,
        ),
        AuthInterceptor(
          tokenStorage: _tokenStorage,
          refreshDio: refreshDio,
        ),
      ]);
  }
}
