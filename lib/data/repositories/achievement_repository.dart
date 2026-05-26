import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

/// Definition of a single achievement badge.
class AchievementDef {
  final String id;
  final String nameEn;
  final String nameVi;
  final String icon;
  final String descriptionEn;
  final String descriptionVi;
  final int target;
  final String category; // 'vocab', 'streak', 'ai', 'grammar', 'quiz', 'typing', 'combo'

  const AchievementDef({
    required this.id,
    required this.nameEn,
    required this.nameVi,
    required this.icon,
    required this.descriptionEn,
    required this.descriptionVi,
    required this.target,
    required this.category,
  });
}

/// All 12 achievements defined statically.
const List<AchievementDef> kAchievements = [
  AchievementDef(
    id: 'first_steps',
    nameEn: 'First Steps',
    nameVi: 'Bước đầu tiên',
    icon: '🐣',
    descriptionEn: 'Star 10 words',
    descriptionVi: 'Đánh dấu 10 từ',
    target: 10,
    category: 'vocab',
  ),
  AchievementDef(
    id: 'word_collector',
    nameEn: 'Word Collector',
    nameVi: 'Nhà sưu tầm',
    icon: '📦',
    descriptionEn: 'Star 50 words',
    descriptionVi: 'Đánh dấu 50 từ',
    target: 50,
    category: 'vocab',
  ),
  AchievementDef(
    id: 'big_brain',
    nameEn: 'Big Brain',
    nameVi: 'Thông thái',
    icon: '🧠',
    descriptionEn: 'Master 100 words',
    descriptionVi: 'Thành thạo 100 từ',
    target: 100,
    category: 'vocab',
  ),
  AchievementDef(
    id: 'scholar',
    nameEn: 'Scholar',
    nameVi: 'Học giả',
    icon: '🎓',
    descriptionEn: 'Master 500 words',
    descriptionVi: 'Thành thạo 500 từ',
    target: 500,
    category: 'vocab',
  ),
  AchievementDef(
    id: 'diamond',
    nameEn: 'Diamond',
    nameVi: 'Kim cương',
    icon: '💎',
    descriptionEn: 'Master 1000 words',
    descriptionVi: 'Thành thạo 1000 từ',
    target: 1000,
    category: 'vocab',
  ),
  AchievementDef(
    id: 'on_fire',
    nameEn: 'On Fire',
    nameVi: 'Bùng cháy',
    icon: '🔥',
    descriptionEn: '7 day streak',
    descriptionVi: 'Streak 7 ngày',
    target: 7,
    category: 'streak',
  ),
  AchievementDef(
    id: 'unstoppable',
    nameEn: 'Unstoppable',
    nameVi: 'Không thể cản',
    icon: '⚡',
    descriptionEn: '30 day streak',
    descriptionVi: 'Streak 30 ngày',
    target: 30,
    category: 'streak',
  ),
  AchievementDef(
    id: 'bookworm',
    nameEn: 'Bookworm',
    nameVi: 'Mọt sách',
    icon: '📚',
    descriptionEn: 'Complete 5 AI Lessons',
    descriptionVi: 'Hoàn thành 5 bài AI',
    target: 5,
    category: 'ai',
  ),
  AchievementDef(
    id: 'grammar_guru',
    nameEn: 'Grammar Guru',
    nameVi: 'Bậc thầy ngữ pháp',
    icon: '📝',
    descriptionEn: 'Read 20 grammar lessons',
    descriptionVi: 'Đọc 20 bài ngữ pháp',
    target: 20,
    category: 'grammar',
  ),
  AchievementDef(
    id: 'sharpshooter',
    nameEn: 'Sharpshooter',
    nameVi: 'Thiện xạ',
    icon: '🎯',
    descriptionEn: 'Quiz 100% accuracy 3 times',
    descriptionVi: 'Quiz 100% chính xác 3 lần',
    target: 3,
    category: 'quiz',
  ),
  AchievementDef(
    id: 'speed_typer',
    nameEn: 'Speed Typer',
    nameVi: 'Gõ nhanh',
    icon: '⌨️',
    descriptionEn: 'Typing 100% accuracy 3 times',
    descriptionVi: 'Typing 100% chính xác 3 lần',
    target: 3,
    category: 'typing',
  ),
  AchievementDef(
    id: 'polyglot',
    nameEn: 'Polyglot',
    nameVi: 'Đa ngôn ngữ',
    icon: '🌍',
    descriptionEn: '20 AI Lessons + Master 200 words',
    descriptionVi: '20 bài AI + Thành thạo 200 từ',
    target: 1, // composite check, target=1 means "condition met"
    category: 'combo',
  ),
];

/// Runtime state of a single achievement.
class AchievementProgress {
  final String id;
  bool unlocked;
  DateTime? unlockedAt;
  int currentProgress;

  AchievementProgress({
    required this.id,
    this.unlocked = false,
    this.unlockedAt,
    this.currentProgress = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'unlocked': unlocked,
        'unlockedAt': unlockedAt?.toIso8601String(),
        'currentProgress': currentProgress,
      };

  factory AchievementProgress.fromJson(Map<String, dynamic> json) =>
      AchievementProgress(
        id: json['id'] as String,
        unlocked: json['unlocked'] as bool? ?? false,
        unlockedAt: json['unlockedAt'] != null
            ? DateTime.parse(json['unlockedAt'] as String)
            : null,
        currentProgress: json['currentProgress'] as int? ?? 0,
      );
}

/// Repository for persisting achievement progress via SharedPreferences.
class AchievementRepository {
  static const _key = 'achievements_v1';
  static const _perfectQuizKey = 'perfect_quiz_count';
  static const _perfectTypingKey = 'perfect_typing_count';
  static const _aiLessonCountKey = 'ai_lesson_complete_count';
  final SharedPreferences _prefs;

  final Map<String, AchievementProgress> _cache = {};
  bool _loaded = false;

  AchievementRepository({required SharedPreferences prefs}) : _prefs = prefs;

  void _ensureLoaded() {
    if (_loaded) return;
    _loaded = true;
    final raw = _prefs.getString(_key);
    if (raw == null) return;
    try {
      final list = jsonDecode(raw) as List;
      for (final item in list) {
        final ap = AchievementProgress.fromJson(item as Map<String, dynamic>);
        _cache[ap.id] = ap;
      }
    } catch (_) {
      _cache.clear();
    }
  }

  Future<void> _save() async {
    final list = _cache.values.map((e) => e.toJson()).toList();
    await _prefs.setString(_key, jsonEncode(list));
  }

  /// Get progress for a specific achievement.
  AchievementProgress getProgress(String id) {
    _ensureLoaded();
    return _cache.putIfAbsent(id, () => AchievementProgress(id: id));
  }

  /// Check if an achievement is unlocked.
  bool isUnlocked(String id) {
    _ensureLoaded();
    return _cache[id]?.unlocked ?? false;
  }

  /// Get total unlocked count.
  int get unlockedCount {
    _ensureLoaded();
    return _cache.values.where((a) => a.unlocked).length;
  }

  /// Update progress and check if newly unlocked.
  /// Returns the AchievementDef if newly unlocked, null otherwise.
  Future<AchievementDef?> updateProgress(String id, int progress) async {
    _ensureLoaded();
    final ap = getProgress(id);
    if (ap.unlocked) return null; // already unlocked

    ap.currentProgress = progress;

    // Find the definition to check target
    final def = kAchievements.firstWhere((a) => a.id == id,
        orElse: () => throw ArgumentError('Unknown achievement: $id'));

    if (progress >= def.target) {
      ap.unlocked = true;
      ap.unlockedAt = DateTime.now();
      await _save();
      return def; // newly unlocked!
    }

    await _save();
    return null;
  }

  /// Increment a counter stored in SharedPreferences.
  Future<int> incrementCounter(String key) async {
    final count = (_prefs.getInt(key) ?? 0) + 1;
    await _prefs.setInt(key, count);
    return count;
  }

  /// Get a counter value.
  int getCounter(String key) => _prefs.getInt(key) ?? 0;

  /// Record a perfect quiz (100% accuracy with >=5 words).
  Future<int> recordPerfectQuiz() async {
    return incrementCounter(_perfectQuizKey);
  }

  /// Record a perfect typing challenge (100% accuracy with >=5 words).
  Future<int> recordPerfectTyping() async {
    return incrementCounter(_perfectTypingKey);
  }

  /// Record an AI lesson completion.
  Future<int> recordAiLessonComplete() async {
    return incrementCounter(_aiLessonCountKey);
  }

  int get perfectQuizCount => getCounter(_perfectQuizKey);
  int get perfectTypingCount => getCounter(_perfectTypingKey);
  int get aiLessonCount => getCounter(_aiLessonCountKey);

  // ─── Server Sync Operations ───

  static const _counterPerfectQuizId = '_counter_perfect_quiz';
  static const _counterPerfectTypingId = '_counter_perfect_typing';
  static const _counterAiLessonId = '_counter_ai_lesson';

  /// Sync achievements with server (push-then-pull).
  Future<void> syncWithServer() async {
    try {
      final dio = GetIt.I<Dio>(instanceName: 'BackendDio');
      _ensureLoaded();

      // Build sync data: all achievement progress + counters as special entries
      final syncData = <Map<String, dynamic>>[];

      for (final ap in _cache.values) {
        syncData.add({
          'achievementId': ap.id,
          'currentProgress': ap.currentProgress,
          'unlocked': ap.unlocked,
          'unlockedAt': ap.unlockedAt?.toIso8601String(),
        });
      }

      // Add counter entries
      syncData.add({
        'achievementId': _counterPerfectQuizId,
        'currentProgress': perfectQuizCount,
        'unlocked': false,
      });
      syncData.add({
        'achievementId': _counterPerfectTypingId,
        'currentProgress': perfectTypingCount,
        'unlocked': false,
      });
      syncData.add({
        'achievementId': _counterAiLessonId,
        'currentProgress': aiLessonCount,
        'unlocked': false,
      });

      // Push to server, get merged response
      final response = await dio.post('/achievements/sync', data: syncData);
      if (response.statusCode == 200 && response.data is List) {
        final serverData = (response.data as List)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();

        // Update local cache with server response
        for (final item in serverData) {
          final id = item['achievementId'] as String? ?? item['id'] as String?;
          if (id == null) continue;

          // Handle counter entries
          if (id == _counterPerfectQuizId) {
            final val = item['currentProgress'] as int? ?? 0;
            if (val > perfectQuizCount) await _prefs.setInt(_perfectQuizKey, val);
            continue;
          }
          if (id == _counterPerfectTypingId) {
            final val = item['currentProgress'] as int? ?? 0;
            if (val > perfectTypingCount) await _prefs.setInt(_perfectTypingKey, val);
            continue;
          }
          if (id == _counterAiLessonId) {
            final val = item['currentProgress'] as int? ?? 0;
            if (val > aiLessonCount) await _prefs.setInt(_aiLessonCountKey, val);
            continue;
          }

          // Regular achievement
          _cache[id] = AchievementProgress(
            id: id,
            currentProgress: item['currentProgress'] as int? ?? 0,
            unlocked: item['unlocked'] as bool? ?? false,
            unlockedAt: item['unlockedAt'] != null
                ? DateTime.tryParse(item['unlockedAt'] as String)
                : null,
          );
        }
        await _save();
        debugPrint('🏆 ✅ Achievement sync done: ${serverData.length} entries');
      }
    } catch (e) {
      debugPrint('🏆 ❌ Achievement sync failed: $e');
    }
  }

  /// Pull achievements from server only (for account switch).
  Future<void> pullFromServer() async {
    try {
      final dio = GetIt.I<Dio>(instanceName: 'BackendDio');

      final response = await dio.get('/achievements');
      if (response.statusCode != 200) return;

      final serverData = (response.data as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

      // Clear local cache and rebuild
      _cache.clear();

      for (final item in serverData) {
        final id = item['achievementId'] as String? ?? item['id'] as String?;
        if (id == null) continue;

        // Handle counter entries
        if (id == _counterPerfectQuizId) {
          await _prefs.setInt(_perfectQuizKey, item['currentProgress'] as int? ?? 0);
          continue;
        }
        if (id == _counterPerfectTypingId) {
          await _prefs.setInt(_perfectTypingKey, item['currentProgress'] as int? ?? 0);
          continue;
        }
        if (id == _counterAiLessonId) {
          await _prefs.setInt(_aiLessonCountKey, item['currentProgress'] as int? ?? 0);
          continue;
        }

        _cache[id] = AchievementProgress(
          id: id,
          currentProgress: item['currentProgress'] as int? ?? 0,
          unlocked: item['unlocked'] as bool? ?? false,
          unlockedAt: item['unlockedAt'] != null
              ? DateTime.tryParse(item['unlockedAt'] as String)
              : null,
        );
      }

      await _save();
      debugPrint('🏆 ✅ Pulled ${_cache.length} achievements from server');
    } catch (e) {
      debugPrint('🏆 ❌ Achievement pull failed: $e');
    }
  }

  /// Clear all local achievement data.
  Future<void> clearLocal() async {
    _cache.clear();
    _loaded = false;
    await _prefs.remove(_key);
    await _prefs.remove(_perfectQuizKey);
    await _prefs.remove(_perfectTypingKey);
    await _prefs.remove(_aiLessonCountKey);
    debugPrint('🏆 🗑️ Local achievement data cleared');
  }
}
