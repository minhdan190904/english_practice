import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// SRS (Spaced Repetition System) data for a single word
class SrsData {
  final int wordIndex;
  final int reviewCount; // 0-4+
  final DateTime? nextReviewDate;

  const SrsData({
    required this.wordIndex,
    required this.reviewCount,
    this.nextReviewDate,
  });

  /// Days until next review based on reviewCount (SM-2 simplified)
  /// 0→1d, 1→3d, 2→7d, 3→21d, 4+=mastered
  static int intervalDays(int reviewCount) {
    const intervals = [1, 3, 7, 21];
    if (reviewCount >= intervals.length) return 9999;
    return intervals[reviewCount];
  }

  bool get isDueToday {
    if (nextReviewDate == null) return true;
    final now = DateTime.now();
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return nextReviewDate!.isBefore(todayEnd);
  }

  bool get isMastered => reviewCount >= 4;

  SrsData copyWithCorrect() {
    final newCount = reviewCount + 1;
    final days = intervalDays(newCount);
    final next = DateTime.now().add(Duration(days: days));
    return SrsData(wordIndex: wordIndex, reviewCount: newCount, nextReviewDate: next);
  }

  SrsData copyWithWrong() {
    final next = DateTime.now().add(const Duration(days: 1));
    return SrsData(wordIndex: wordIndex, reviewCount: 0, nextReviewDate: next);
  }

  Map<String, dynamic> toJson() => {
        'wordIndex': wordIndex,
        'reviewCount': reviewCount,
        'nextReviewDate': nextReviewDate?.millisecondsSinceEpoch,
      };

  factory SrsData.fromJson(Map<String, dynamic> json) => SrsData(
        wordIndex: json['wordIndex'] as int,
        reviewCount: json['reviewCount'] as int,
        nextReviewDate: json['nextReviewDate'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['nextReviewDate'] as int)
            : null,
      );
}

/// Repository for SRS data — stored in SharedPreferences as JSON
/// Separate from Hive to avoid migration complexity
class SrsRepository {
  static const _key = 'srs_data';
  static SharedPreferences? _prefs;
  static Map<int, SrsData> _cache = {};
  static bool _loaded = false;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<Map<int, SrsData>> _load() async {
    if (_loaded) return _cache;
    await init();
    final raw = _prefs?.getString(_key);
    if (raw == null || raw.isEmpty) {
      _loaded = true;
      return _cache;
    }
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      _cache = map.map((k, v) {
        final idx = int.parse(k);
        return MapEntry(idx, SrsData.fromJson(v as Map<String, dynamic>));
      });
    } catch (_) {
      _cache = {};
    }
    _loaded = true;
    return _cache;
  }

  static Future<void> _save() async {
    await init();
    final map = _cache.map((k, v) => MapEntry(k.toString(), v.toJson()));
    await _prefs?.setString(_key, jsonEncode(map));
  }

  /// Get SRS data for a word (null = never reviewed)
  static Future<SrsData?> get(int wordIndex) async {
    final all = await _load();
    return all[wordIndex];
  }

  /// Get all SRS data
  static Future<Map<int, SrsData>> getAll() async => _load();

  /// Record a correct answer → advance interval
  static Future<SrsData> recordCorrect(int wordIndex) async {
    await _load();
    final current = _cache[wordIndex] ?? SrsData(wordIndex: wordIndex, reviewCount: 0);
    final updated = current.copyWithCorrect();
    _cache[wordIndex] = updated;
    await _save();
    return updated;
  }

  /// Record a wrong answer → reset interval
  static Future<SrsData> recordWrong(int wordIndex) async {
    await _load();
    final current = _cache[wordIndex] ?? SrsData(wordIndex: wordIndex, reviewCount: 0);
    final updated = current.copyWithWrong();
    _cache[wordIndex] = updated;
    await _save();
    return updated;
  }

  /// Count how many words from given indexes are due today
  static Future<int> dueCount(List<int> wordIndexes) async {
    final all = await _load();
    int count = 0;
    for (final idx in wordIndexes) {
      final srs = all[idx];
      if (srs == null || srs.isDueToday) count++;
    }
    return count;
  }

  /// Reset / clear all SRS data
  static Future<void> clear() async {
    _cache = {};
    _loaded = true;
    await _prefs?.remove(_key);
  }
}
