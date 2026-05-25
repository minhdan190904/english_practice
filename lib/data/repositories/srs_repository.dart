import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// SRS (Spaced Repetition System) data for a single word.
class SrsData {
  final int wordIndex;
  double easeFactor;
  int interval; // days
  int repetitions; // consecutive correct
  DateTime? nextReviewDate;
  DateTime? lastReviewDate;

  SrsData({
    required this.wordIndex,
    this.easeFactor = 2.5,
    this.interval = 0,
    this.repetitions = 0,
    this.nextReviewDate,
    this.lastReviewDate,
  });

  Map<String, dynamic> toJson() => {
        'wordIndex': wordIndex,
        'easeFactor': easeFactor,
        'interval': interval,
        'repetitions': repetitions,
        'nextReviewDate': nextReviewDate?.toIso8601String(),
        'lastReviewDate': lastReviewDate?.toIso8601String(),
      };

  factory SrsData.fromJson(Map<String, dynamic> json) => SrsData(
        wordIndex: json['wordIndex'] as int,
        easeFactor: (json['easeFactor'] as num?)?.toDouble() ?? 2.5,
        interval: json['interval'] as int? ?? 0,
        repetitions: json['repetitions'] as int? ?? 0,
        nextReviewDate: json['nextReviewDate'] != null
            ? DateTime.parse(json['nextReviewDate'] as String)
            : null,
        lastReviewDate: json['lastReviewDate'] != null
            ? DateTime.parse(json['lastReviewDate'] as String)
            : null,
      );

  /// Apply SM-2 algorithm after a review.
  /// [correct] = true if user answered correctly.
  void recordReview(bool correct) {
    lastReviewDate = DateTime.now();
    final today = DateTime.now();

    if (correct) {
      repetitions += 1;
      if (repetitions == 1) {
        interval = 1;
      } else if (repetitions == 2) {
        interval = 3;
      } else if (repetitions == 3) {
        interval = 7;
      } else {
        interval = (interval * easeFactor).round();
      }
      easeFactor = (easeFactor + 0.1).clamp(1.3, 3.0);
    } else {
      repetitions = 0;
      interval = 1;
      easeFactor = (easeFactor - 0.2).clamp(1.3, 3.0);
    }

    nextReviewDate = DateTime(today.year, today.month, today.day)
        .add(Duration(days: interval));
  }

  /// Whether this word is due for review today or overdue.
  bool get isDueToday {
    if (nextReviewDate == null) return false;
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final dueDate = DateTime(
        nextReviewDate!.year, nextReviewDate!.month, nextReviewDate!.day);
    return dueDate.compareTo(todayDate) <= 0;
  }

  /// Whether this word is overdue (due before today).
  bool get isOverdue {
    if (nextReviewDate == null) return false;
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final dueDate = DateTime(
        nextReviewDate!.year, nextReviewDate!.month, nextReviewDate!.day);
    return dueDate.isBefore(todayDate);
  }
}

/// Repository for persisting SRS data via SharedPreferences.
class SrsRepository {
  static const _key = 'srs_data_v1';
  final SharedPreferences _prefs;

  // In-memory cache
  final Map<int, SrsData> _cache = {};
  bool _loaded = false;

  SrsRepository({required SharedPreferences prefs}) : _prefs = prefs;

  /// Load all SRS data from disk into cache.
  void _ensureLoaded() {
    if (_loaded) return;
    _loaded = true;
    final raw = _prefs.getString(_key);
    if (raw == null) return;
    try {
      final list = jsonDecode(raw) as List;
      for (final item in list) {
        final srs = SrsData.fromJson(item as Map<String, dynamic>);
        _cache[srs.wordIndex] = srs;
      }
    } catch (_) {
      // Corrupted data — start fresh
      _cache.clear();
    }
  }

  /// Persist cache to disk.
  Future<void> _save() async {
    final list = _cache.values.map((e) => e.toJson()).toList();
    await _prefs.setString(_key, jsonEncode(list));
  }

  /// Get SRS data for a specific word index.
  SrsData? get(int wordIndex) {
    _ensureLoaded();
    return _cache[wordIndex];
  }

  /// Get or create SRS data for a word index.
  SrsData getOrCreate(int wordIndex) {
    _ensureLoaded();
    return _cache.putIfAbsent(wordIndex, () => SrsData(wordIndex: wordIndex));
  }

  /// Record a review result and persist.
  Future<void> recordReview(int wordIndex, bool correct) async {
    final srs = getOrCreate(wordIndex);
    srs.recordReview(correct);
    await _save();
  }

  /// Schedule a word for SRS (called when user stars a word).
  Future<void> scheduleWord(int wordIndex) async {
    _ensureLoaded();
    if (!_cache.containsKey(wordIndex)) {
      final srs = SrsData(wordIndex: wordIndex);
      final today = DateTime.now();
      srs.nextReviewDate = DateTime(today.year, today.month, today.day)
          .add(const Duration(days: 1));
      _cache[wordIndex] = srs;
      await _save();
    }
  }

  /// Remove SRS data for a word (called when user un-stars or masters a word).
  Future<void> removeWord(int wordIndex) async {
    _ensureLoaded();
    _cache.remove(wordIndex);
    await _save();
  }

  /// Get all words due for review today (including overdue).
  List<SrsData> getDueWords() {
    _ensureLoaded();
    return _cache.values.where((srs) => srs.isDueToday).toList()
      ..sort((a, b) {
        // Overdue first, then by date
        if (a.isOverdue && !b.isOverdue) return -1;
        if (!a.isOverdue && b.isOverdue) return 1;
        if (a.nextReviewDate == null) return 1;
        if (b.nextReviewDate == null) return -1;
        return a.nextReviewDate!.compareTo(b.nextReviewDate!);
      });
  }

  /// Count of words due today.
  int get dueCount {
    _ensureLoaded();
    return _cache.values.where((srs) => srs.isDueToday).length;
  }

  /// Count of overdue words.
  int get overdueCount {
    _ensureLoaded();
    return _cache.values.where((srs) => srs.isOverdue).length;
  }

  /// Total SRS-tracked words count.
  int get totalTracked {
    _ensureLoaded();
    return _cache.length;
  }
}
