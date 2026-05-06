import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/lesson_result.dart';
import '../models/sample_passage_response.dart';

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

  Future<SamplePassageResponse> generateSamplePassage({
    required String category,
    required String level,
    int minWords = 80,
    int maxWords = 140,
  }) async {
    try {
      final response = await _dio.post(
        '/ai/sample-passage',
        data: {
          'category': category,
          'level': level,
          'minWords': minWords,
          'maxWords': maxWords,
        },
      );

      var data = response.data;
      if (data is String) {
        data = jsonDecode(data);
      }
      return SamplePassageResponse.fromJson(data);
    } catch (e) {
      throw Exception('Failed to generate sample passage: $e');
    }
  }
}
