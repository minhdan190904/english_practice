import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/lesson_result.dart';

class AiRepository {
  final Dio _dio;

  AiRepository({required Dio dio}) : _dio = dio;

  Future<LessonResult> generateLesson({
    String? topic,
    String? customText,
    String level = 'B1 - Intermediate',
  }) async {
    try {
      final response = await _dio.post(
        '/ai/generate-lesson',
        data: {
          'topic': topic,
          'level': level,
          'customText': customText,
        },
      );

      var data = response.data;
      if (data is String) {
        data = jsonDecode(data);
      }
      
      return LessonResult.fromJson(data);
    } catch (e) {
      throw Exception('Failed to generate lesson: $e');
    }
  }
}
