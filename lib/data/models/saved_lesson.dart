import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedLesson {
  final String id;
  final String title;
  final String passage;
  final String? passageVi;
  final List<SavedWord> words;
  final DateTime createdAt;
  final String? imageBase64;

  SavedLesson({
    required this.id,
    required this.title,
    required this.passage,
    this.passageVi,
    required this.words,
    required this.createdAt,
    this.imageBase64,
  });

  int get wordCount => words.length;

  String get passagePreview {
    if (passage.length <= 90) return passage;
    return '${passage.substring(0, 90)}...';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'passage': passage,
        'passageVi': passageVi,
        'words': words.map((w) => w.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'imageBase64': imageBase64,
      };

  /// Convert to API sync format
  Map<String, dynamic> toSyncJson() => {
        'lessonId': id,
        'title': title,
        'passage': passage,
        'passageVi': passageVi,
        'imageBase64': imageBase64,
        'words': words.map((w) => w.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory SavedLesson.fromJson(Map<String, dynamic> json) => SavedLesson(
        id: json['id'] ?? json['lessonId'] ?? '',
        title: json['title'] ?? '',
        passage: json['passage'] ?? '',
        passageVi: json['passageVi'],
        words: (json['words'] as List? ?? [])
            .map((w) => SavedWord.fromJson(w is Map<String, dynamic> ? w : Map<String, dynamic>.from(w)))
            .toList(),
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
        imageBase64: json['imageBase64'],
      );
}

class SavedWord {
  final String word;
  final String? definition;
  final String? definitionVi;
  final String? shortMeaningVi;
  final String? example;
  final String? phoneticText;
  final String? phoneticAmText;
  final String? phoneticUrl;
  final String? phoneticAmUrl;
  final String? pos;
  final String level;
  final String category;

  SavedWord({
    required this.word,
    this.definition,
    this.definitionVi,
    this.shortMeaningVi,
    this.example,
    this.phoneticText,
    this.phoneticAmText,
    this.phoneticUrl,
    this.phoneticAmUrl,
    this.pos,
    required this.level,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
        'word': word,
        'definition': definition,
        'definitionVi': definitionVi,
        'shortMeaningVi': shortMeaningVi,
        'example': example,
        'phoneticText': phoneticText,
        'phoneticAmText': phoneticAmText,
        'phoneticUrl': phoneticUrl,
        'phoneticAmUrl': phoneticAmUrl,
        'pos': pos,
        'level': level,
        'category': category,
      };

  factory SavedWord.fromJson(Map<String, dynamic> json) => SavedWord(
        word: json['word'] ?? '',
        definition: json['definition'],
        definitionVi: json['definitionVi'],
        shortMeaningVi: json['shortMeaningVi'],
        example: json['example'],
        phoneticText: json['phoneticText'],
        phoneticAmText: json['phoneticAmText'],
        phoneticUrl: json['phoneticUrl'],
        phoneticAmUrl: json['phoneticAmUrl'],
        pos: json['pos'],
        level: json['level'] ?? '',
        category: json['category'] ?? '',
      );
}

class SavedLessonsRepository {
  static const String _key = 'saved_ai_lessons_v2';

  // ─── Local Operations ───

  Future<List<SavedLesson>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List;
      final lessons = list.map((e) => SavedLesson.fromJson(e)).toList();
      lessons.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return lessons;
    } catch (_) {
      return [];
    }
  }

  Future<void> save(SavedLesson lesson) async {
    final prefs = await SharedPreferences.getInstance();
    final lessons = await getAll();
    lessons.removeWhere((l) => l.id == lesson.id);
    lessons.insert(0, lesson);
    final toSave = lessons.take(50).toList();
    await prefs.setString(_key, jsonEncode(toSave.map((l) => l.toJson()).toList()));

    // Background sync to server
    _syncSingleToServer(lesson);
  }

  Future<void> delete(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final lessons = await getAll();
    lessons.removeWhere((l) => l.id == id);
    await prefs.setString(_key, jsonEncode(lessons.map((l) => l.toJson()).toList()));

    // Background delete from server
    _deleteFromServer(id);
  }

  // ─── Server Sync Operations ───

  /// Clear all local lessons (call before account switch)
  Future<void> clearLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    debugPrint('📖 🗑️ Local lessons cleared');
  }

  /// Pull lessons from server only (no push). For account switch.
  Future<void> pullFromServer() async {
    try {
      final dio = GetIt.I<Dio>(instanceName: 'BackendDio');
      final response = await dio.get('/lessons');
      if (response.statusCode == 200) {
        final serverLessons = (response.data as List)
            .map((e) => SavedLesson.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        await _saveAllLocal(serverLessons);
        debugPrint('📖 ✅ Pulled ${serverLessons.length} lessons from server');
      }
    } catch (e) {
      debugPrint('📖 ❌ Pull lessons failed: $e');
    }
  }

  /// Sync all local lessons to server. Call on app start (NOT on account switch).
  Future<void> syncWithServer() async {
    try {
      final dio = GetIt.I<Dio>(instanceName: 'BackendDio');
      final localLessons = await getAll();

      if (localLessons.isEmpty) {
        // No local lessons — pull from server
        await pullFromServer();
        return;
      }

      // Push local lessons to server
      final syncData = localLessons.map((l) => l.toSyncJson()).toList();
      final response = await dio.post('/lessons/sync', data: syncData);

      if (response.statusCode == 200) {
        // Server returns merged list — save locally
        final serverLessons = (response.data as List)
            .map((e) => SavedLesson.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        await _saveAllLocal(serverLessons);
        debugPrint('📖 ✅ Synced ${serverLessons.length} lessons with server');
      }
    } catch (e) {
      debugPrint('📖 ❌ Lesson sync failed: $e');
    }
  }

  /// Sync a single lesson to server (background, fire-and-forget)
  void _syncSingleToServer(SavedLesson lesson) async {
    try {
      final dio = GetIt.I<Dio>(instanceName: 'BackendDio');
      await dio.post('/lessons/sync', data: [lesson.toSyncJson()]);
      debugPrint('📖 ✅ Lesson synced: ${lesson.title}');
    } catch (e) {
      debugPrint('📖 ❌ Lesson sync failed: $e');
    }
  }

  /// Delete a lesson from server (background)
  void _deleteFromServer(String lessonId) async {
    try {
      final dio = GetIt.I<Dio>(instanceName: 'BackendDio');
      await dio.delete('/lessons/$lessonId');
      debugPrint('📖 ✅ Lesson deleted from server: $lessonId');
    } catch (e) {
      debugPrint('📖 ❌ Lesson delete failed: $e');
    }
  }

  /// Save all lessons to local storage
  Future<void> _saveAllLocal(List<SavedLesson> lessons) async {
    final prefs = await SharedPreferences.getInstance();
    lessons.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final toSave = lessons.take(50).toList();
    await prefs.setString(_key, jsonEncode(toSave.map((l) => l.toJson()).toList()));
  }
}
