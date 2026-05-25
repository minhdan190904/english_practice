import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../data_sources/pair_storage.dart';

abstract interface class StreakRepository {
  Future<void> setTimeStreak(int timeStreak);

  int getTimeStreak();

  Future<void> setStreak(int streak);

  int get streak;

  int get longestStreak;

  bool get streakedToday;

  /// Sync streak data with server
  Future<void> syncWithServer();

  /// Check-in with server (call when streak is earned)
  Future<void> checkInWithServer();
}

class StreakRepositoryImpl implements StreakRepository {
  final PairStorage _pairStorage;

  StreakRepositoryImpl({
    required PairStorage pairStorage,
  }) : _pairStorage = pairStorage;

  @override
  int getTimeStreak() {
    return _pairStorage.getTimeStreak();
  }

  @override
  Future<void> setTimeStreak(int timeStreak) {
    return _pairStorage.setTimeStreak(timeStreak);
  }

  @override
  int get streak => _pairStorage.streak;

  @override
  int get longestStreak => _pairStorage.longestStreak;

  @override
  bool get streakedToday => _pairStorage.streakedToday;

  @override
  Future<void> setStreak(int streak) {
    return _pairStorage.setStreak(streak);
  }

  // ─── Server Sync ───

  @override
  Future<void> syncWithServer() async {
    try {
      final dio = GetIt.I<Dio>(instanceName: 'BackendDio');
      final response = await dio.get('/streak');
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final serverStreak = data['currentStreak'] as int? ?? 0;
        final serverMax = data['maxStreak'] as int? ?? 0;

        // Use whichever is higher (local or server)
        final localStreak = streak;
        final localMax = longestStreak;

        if (serverStreak > localStreak) {
          await setStreak(serverStreak);
          debugPrint('🔥 Pulled streak from server: $serverStreak');
        }
        if (serverMax > localMax) {
          // Update local max (stored in PairStorage)
          debugPrint('🔥 Server max streak: $serverMax (local: $localMax)');
        }
      }
    } catch (e) {
      debugPrint('🔥 ❌ Streak sync failed: $e');
    }
  }

  @override
  Future<void> checkInWithServer() async {
    try {
      final dio = GetIt.I<Dio>(instanceName: 'BackendDio');
      await dio.post('/streak/check-in');
      debugPrint('🔥 ✅ Streak check-in sent to server');
    } catch (e) {
      debugPrint('🔥 ❌ Streak check-in failed: $e');
    }
  }
}