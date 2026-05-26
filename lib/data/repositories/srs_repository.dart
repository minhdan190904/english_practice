import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import '../data_sources/local_data.dart';
import '../models/word_status.dart';

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
    // Push to server in background
    pushSingleReview(wordIndex, correct);
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

  // ─── Server Sync Operations ───

  /// Build lookup maps between wordIndex and word text.
  Map<int, String> _buildIndexToWordMap() {
    try {
      final localData = GetIt.I<LocalData>();
      final words = localData.getWords();
      return {for (final w in words) w.index: w.word};
    } catch (e) {
      debugPrint('🔄 ❌ Failed to build word lookup: $e');
      return {};
    }
  }

  /// Sync SRS data with server (pull-first strategy).
  Future<void> syncWithServer() async {
    try {
      final dio = GetIt.I<Dio>(instanceName: 'BackendDio');
      final indexToWord = _buildIndexToWordMap();
      if (indexToWord.isEmpty) {
        debugPrint('🔄 ⚠️ No words loaded, skipping SRS sync');
        return;
      }
      final wordToIndex = {for (final e in indexToWord.entries) e.value.toLowerCase(): e.key};

      // Step 1: Pull from server (source of truth for SRS fields)
      final response = await dio.get('/vocabularies');
      if (response.statusCode != 200) return;

      final serverVocabs = (response.data as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

      _ensureLoaded();

      // Step 2: Update local cache with server data
      final serverWords = <int>{};
      for (final sv in serverVocabs) {
        final wordText = (sv['word'] as String?)?.toLowerCase();
        if (wordText == null) continue;
        final idx = wordToIndex[wordText];
        if (idx == null) continue;
        serverWords.add(idx);

        _cache[idx] = SrsData(
          wordIndex: idx,
          easeFactor: (sv['easeFactor'] as num?)?.toDouble() ?? 2.5,
          interval: sv['srsInterval'] as int? ?? 0,
          repetitions: sv['repetitions'] as int? ?? 0,
          nextReviewDate: sv['nextReviewDate'] != null
              ? DateTime.tryParse(sv['nextReviewDate'] as String)
              : null,
          lastReviewDate: sv['lastReviewDate'] != null
              ? DateTime.tryParse(sv['lastReviewDate'] as String)
              : null,
        );
      }

      // Step 3: Push local-only entries to server
      final localOnly = _cache.values
          .where((srs) => !serverWords.contains(srs.wordIndex))
          .toList();

      if (localOnly.isNotEmpty) {
        // Build a status lookup from Hive words
        final statusLookup = <int, WordStatus>{};
        try {
          final localData = GetIt.I<LocalData>();
          for (final w in localData.getWords()) {
            statusLookup[w.index] = w.status;
          }
        } catch (_) {}

        final syncData = localOnly
            .where((srs) => indexToWord.containsKey(srs.wordIndex))
            .map((srs) => {
                  'word': indexToWord[srs.wordIndex],
                  'status': (statusLookup[srs.wordIndex] ?? WordStatus.star).toApiString(),
                  'easeFactor': srs.easeFactor,
                  'srsInterval': srs.interval,
                  'repetitions': srs.repetitions,
                  'nextReviewDate': srs.nextReviewDate?.toIso8601String(),
                  'lastReviewDate': srs.lastReviewDate?.toIso8601String(),
                })
            .toList();

        if (syncData.isNotEmpty) {
          await dio.post('/vocabularies/sync', data: syncData);
          debugPrint('🔄 ⬆️ Pushed ${syncData.length} local SRS entries to server');
        }
      }

      // Step 4: Apply server word statuses to Hive (so Word.status is correct)
      _applyServerStatusesToHive(serverVocabs, wordToIndex);

      await _save();
      debugPrint('🔄 ✅ SRS sync done: ${serverVocabs.length} from server, ${localOnly.length} local-only');
    } catch (e) {
      debugPrint('🔄 ❌ SRS sync failed: $e');
    }
  }

  /// Pull SRS data from server only (for account switch).
  Future<void> pullFromServer() async {
    try {
      final dio = GetIt.I<Dio>(instanceName: 'BackendDio');
      final indexToWord = _buildIndexToWordMap();
      if (indexToWord.isEmpty) {
        debugPrint('🔄 ⚠️ No words loaded, skipping SRS pull');
        return;
      }
      final wordToIndex = {for (final e in indexToWord.entries) e.value.toLowerCase(): e.key};

      final response = await dio.get('/vocabularies');
      if (response.statusCode != 200) return;

      final serverVocabs = (response.data as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

      // Clear local cache and rebuild from server
      _cache.clear();
      for (final sv in serverVocabs) {
        final wordText = (sv['word'] as String?)?.toLowerCase();
        if (wordText == null) continue;
        final idx = wordToIndex[wordText];
        if (idx == null) continue;

        _cache[idx] = SrsData(
          wordIndex: idx,
          easeFactor: (sv['easeFactor'] as num?)?.toDouble() ?? 2.5,
          interval: sv['srsInterval'] as int? ?? 0,
          repetitions: sv['repetitions'] as int? ?? 0,
          nextReviewDate: sv['nextReviewDate'] != null
              ? DateTime.tryParse(sv['nextReviewDate'] as String)
              : null,
          lastReviewDate: sv['lastReviewDate'] != null
              ? DateTime.tryParse(sv['lastReviewDate'] as String)
              : null,
        );
      }

      // Apply server word statuses to Hive
      _applyServerStatusesToHive(serverVocabs, wordToIndex);

      await _save();
      debugPrint('🔄 ✅ Pulled ${_cache.length} SRS entries from server');
    } catch (e) {
      debugPrint('🔄 ❌ SRS pull failed: $e');
    }
  }

  /// Apply word statuses from server response to local Hive Word objects.
  /// This ensures that Word.status in Hive matches what the server has.
  void _applyServerStatusesToHive(
    List<Map<String, dynamic>> serverVocabs,
    Map<String, int> wordToIndex,
  ) {
    try {
      final localData = GetIt.I<LocalData>();
      final allWords = localData.getWords();
      if (allWords.isEmpty) return;

      // Build index → Word lookup
      final wordByIndex = <int, dynamic>{};
      for (final w in allWords) {
        wordByIndex[w.index] = w;
      }

      int updatedCount = 0;
      for (final sv in serverVocabs) {
        final wordText = (sv['word'] as String?)?.toLowerCase();
        if (wordText == null) continue;
        final idx = wordToIndex[wordText];
        if (idx == null) continue;

        final serverStatusStr = sv['status'] as String? ?? 'UNKNOWN';
        final serverStatus = WordStatus.fromApiString(serverStatusStr);

        final localWord = wordByIndex[idx];
        if (localWord == null) continue;

        // Only update if status differs
        if (localWord.status != serverStatus) {
          final updated = localWord.copyWith(status: serverStatus);
          localData.saveWord(updated);
          updatedCount++;
        }
      }

      if (updatedCount > 0) {
        debugPrint('🔄 💾 Updated $updatedCount word statuses in Hive from server');
      }
    } catch (e) {
      debugPrint('🔄 ⚠️ Failed to apply server statuses to Hive: $e');
    }
  }

  /// Push a single review to server (fire-and-forget, background).
  void pushSingleReview(int wordIndex, bool correct) async {
    try {
      final indexToWord = _buildIndexToWordMap();
      final wordText = indexToWord[wordIndex];
      if (wordText == null) return;

      final srs = _cache[wordIndex];
      if (srs == null) return;

      // Look up actual status from Hive
      String actualStatus = 'STARRED';
      try {
        final localData = GetIt.I<LocalData>();
        final words = localData.getWords();
        final word = words.firstWhere((w) => w.index == wordIndex,
            orElse: () => words.first);
        if (word.index == wordIndex) {
          actualStatus = word.status.toApiString();
        }
      } catch (_) {}

      final dio = GetIt.I<Dio>(instanceName: 'BackendDio');
      await dio.post('/vocabularies/sync', data: [
        {
          'word': wordText,
          'status': actualStatus,
          'easeFactor': srs.easeFactor,
          'srsInterval': srs.interval,
          'repetitions': srs.repetitions,
          'nextReviewDate': srs.nextReviewDate?.toIso8601String(),
          'lastReviewDate': srs.lastReviewDate?.toIso8601String(),
        }
      ]);
      debugPrint('🔄 ✅ Pushed review for "$wordText" (status=$actualStatus) to server');
    } catch (e) {
      debugPrint('🔄 ❌ Push review failed: $e');
    }
  }

  /// Push word status change to server (fire-and-forget, background).
  /// Used when user changes word status (star, mastered, unknown).
  void pushWordStatus(int wordIndex, String status) async {
    try {
      final indexToWord = _buildIndexToWordMap();
      final wordText = indexToWord[wordIndex];
      if (wordText == null) return;

      final srs = _cache[wordIndex];
      final dio = GetIt.I<Dio>(instanceName: 'BackendDio');
      await dio.post('/vocabularies/sync', data: [
        {
          'word': wordText,
          'status': status,
          'easeFactor': srs?.easeFactor ?? 2.5,
          'srsInterval': srs?.interval ?? 0,
          'repetitions': srs?.repetitions ?? 0,
          'nextReviewDate': srs?.nextReviewDate?.toIso8601String(),
          'lastReviewDate': srs?.lastReviewDate?.toIso8601String(),
        }
      ]);
      debugPrint('🔄 ✅ Pushed status "$status" for "$wordText" to server');
    } catch (e) {
      debugPrint('🔄 ❌ Push word status failed: $e');
    }
  }

  /// Clear all local SRS data.
  Future<void> clearLocal() async {
    _cache.clear();
    await _prefs.remove(_key);
    debugPrint('🔄 🗑️ Local SRS data cleared');
  }
}
