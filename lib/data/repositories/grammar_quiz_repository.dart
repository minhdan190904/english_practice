import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/grammar_quiz.dart';

/// Repository for grammar quiz data and completion tracking.
/// Quiz questions are fetched from backend API.
/// Completion status is synced with backend and cached locally.
class GrammarQuizRepository {
  static const _completedKey = 'grammar_quiz_completed_v1';
  final SharedPreferences _prefs;
  Set<int> _completedCache = {};
  bool _loaded = false;

  GrammarQuizRepository({required SharedPreferences prefs}) : _prefs = prefs;

  void _ensureLoaded() {
    if (_loaded) return;
    _loaded = true;
    final raw = _prefs.getString(_completedKey);
    if (raw != null) {
      try {
        final list = jsonDecode(raw) as List;
        _completedCache = list.map((e) => e as int).toSet();
      } catch (_) {
        _completedCache = {};
      }
    }
  }

  Future<void> _save() async {
    await _prefs.setString(_completedKey, jsonEncode(_completedCache.toList()));
  }

  /// Get quiz questions for a topic from backend.
  Future<GrammarQuiz?> getQuiz(int topicId) async {
    try {
      final dio = GetIt.I<Dio>(instanceName: 'BackendDio');
      final response = await dio.get('/grammar-quiz/$topicId');
      if (response.statusCode == 200 && response.data != null) {
        return GrammarQuiz.fromJson(response.data as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('📝 ❌ Failed to load quiz for topic $topicId: $e');
    }
    return null;
  }

  /// Check if a topic quiz is completed (local cache).
  bool isCompleted(int topicId) {
    _ensureLoaded();
    return _completedCache.contains(topicId);
  }

  /// Get all completed topic IDs (local cache).
  Set<int> getCompletedTopics() {
    _ensureLoaded();
    return Set.from(_completedCache);
  }

  /// Mark a topic as completed and sync with backend.
  Future<void> markCompleted(int topicId) async {
    _ensureLoaded();
    _completedCache.add(topicId);
    await _save();

    // Sync with backend
    try {
      final dio = GetIt.I<Dio>(instanceName: 'BackendDio');
      await dio.post('/grammar-quiz/complete/$topicId');
      debugPrint('📝 ✅ Marked topic $topicId as completed on server');
    } catch (e) {
      debugPrint('📝 ❌ Failed to sync completion for topic $topicId: $e');
    }
  }

  /// Sync completed topics with server (push-then-pull).
  Future<void> syncWithServer() async {
    try {
      _ensureLoaded();
      final dio = GetIt.I<Dio>(instanceName: 'BackendDio');
      final response = await dio.post('/grammar-quiz/sync', data: {
        'completedTopicIds': _completedCache.toList(),
      });
      if (response.statusCode == 200 && response.data is List) {
        final serverIds = (response.data as List).map((e) => e as int).toSet();
        _completedCache = serverIds;
        await _save();
        debugPrint('📝 ✅ Grammar quiz sync done: ${serverIds.length} completed');
      }
    } catch (e) {
      debugPrint('📝 ❌ Grammar quiz sync failed: $e');
    }
  }

  /// Pull completed topics from server only (for account switch).
  Future<void> pullFromServer() async {
    try {
      final dio = GetIt.I<Dio>(instanceName: 'BackendDio');
      final response = await dio.get('/grammar-quiz/completed');
      if (response.statusCode == 200 && response.data is List) {
        _completedCache = (response.data as List).map((e) => e as int).toSet();
        await _save();
        debugPrint('📝 ✅ Pulled ${_completedCache.length} completed quizzes from server');
      }
    } catch (e) {
      debugPrint('📝 ❌ Grammar quiz pull failed: $e');
    }
  }

  /// Clear all local data.
  Future<void> clearLocal() async {
    _completedCache.clear();
    _loaded = false;
    await _prefs.remove(_completedKey);
    debugPrint('📝 🗑️ Local grammar quiz data cleared');
  }
}
