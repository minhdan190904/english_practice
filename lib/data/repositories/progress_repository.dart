import 'package:dio/dio.dart';
import '../../core/failure.dart';

abstract interface class ProgressRepository {
  Future<void> logSession({
    required int timeSpentSeconds,
    required int wordsLearned,
    required int lessonsCompleted,
  });
}

class ProgressRepositoryImpl implements ProgressRepository {
  final Dio _dio;
  
  ProgressRepositoryImpl({
    required Dio dio,
  }) : _dio = dio;

  @override
  Future<void> logSession({
    required int timeSpentSeconds,
    required int wordsLearned,
    required int lessonsCompleted,
  }) async {
    try {
      await _dio.post(
        '/api/v1/progress/log-session',
        data: {
          'timeSpentSeconds': timeSpentSeconds,
          'wordsLearned': wordsLearned,
          'lessonsCompleted': lessonsCompleted,
        },
      );
    } catch (e) {
      throw Failure(message: e.toString());
    }
  }
}
