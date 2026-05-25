import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/lesson_result.dart';
import '../models/sample_passage_response.dart';
import '../models/word.dart';

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

  Future<LessonResult> generateLessonFromInput({
    required String inputText,
    required String level,
    List<String> learnedWords = const [],
  }) async {
    try {
      final response = await _dio.post(
        '/ai/generate-lesson-from-input',
        data: {
          'inputText': inputText,
          'level': level,
          'learnedWords': learnedWords,
        },
      );

      var data = response.data;
      if (data is String) {
        data = jsonDecode(data);
      }

      return LessonResult.fromJson(data);
    } catch (e) {
      throw Exception('Failed to generate lesson from input: $e');
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

  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final response = await _dio.get('/categories');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      throw Exception('Failed to get categories: $e');
    }
  }

  Future<List<Word>> getCategoryWords(String categoryId) async {
    try {
      final response = await _dio.get('/categories/$categoryId/words');
      var data = response.data as List;
      return data.map((json) => Word.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get category words: $e');
    }
  }

  Future<void> submitReport({
    required String type,
    required String content,
    required String reason,
    String? userId,
  }) async {
    await _dio.post(
      '/report',
      data: {
        'type': type,
        'content': content,
        'reason': reason,
        'userId': userId,
      },
    );
  }
}
