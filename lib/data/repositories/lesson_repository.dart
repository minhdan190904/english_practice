import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../../../core/failure.dart';
import '../data_sources/pair_storage.dart';

abstract interface class LessonRepository {
  Map<int, bool> getMarkedLesson();

  Future<Either<Failure, void>> saveMarkedLesson(Map<int, bool> markedLessons);

  /// Sync lesson marks with server
  Future<void> syncWithServer();
}

class LessonRepositoryImpl implements LessonRepository {
  final PairStorage _pairStorage;

  const LessonRepositoryImpl({
    required PairStorage pairStorage,
  }) : _pairStorage = pairStorage;

  @override
  Map<int, bool> getMarkedLesson() {
    return _pairStorage.getMarkedLesson();
  }

  @override
  Future<Either<Failure, void>> saveMarkedLesson(Map<int, bool> markedLessons) async {
    try {
      await _pairStorage.saveMarkedLesson(markedLessons);
      // Background sync to server
      _syncMarksToServer(markedLessons);
      return const Right(null);
    } on Exception {
      return Left(Failure());
    }
  }

  @override
  Future<void> syncWithServer() async {
    try {
      final dio = GetIt.I<Dio>(instanceName: 'BackendDio');

      // Get local marks
      final localMarks = _pairStorage.getMarkedLesson();

      if (localMarks.isEmpty) {
        // No local data — pull from server
        final response = await dio.get('/grammar-quiz/marks');
        if (response.statusCode == 200 && response.data != null) {
          final serverMarks = _parseServerMarks(response.data);
          if (serverMarks.isNotEmpty) {
            await _pairStorage.saveMarkedLesson(serverMarks);
            debugPrint('📋 ✅ Pulled ${serverMarks.length} lesson marks from server');
          }
        }
        return;
      }

      // Has local data — sync both ways
      final marksForSync = localMarks.map(
        (key, value) => MapEntry(key.toString(), value),
      );

      final response = await dio.post(
        '/grammar-quiz/marks/sync',
        data: {'marks': marksForSync},
      );

      if (response.statusCode == 200 && response.data != null) {
        final mergedMarks = _parseServerMarks(response.data);
        await _pairStorage.saveMarkedLesson(mergedMarks);
        debugPrint('📋 ✅ Synced lesson marks: ${mergedMarks.length} total');
      }
    } catch (e) {
      debugPrint('📋 ❌ Lesson marks sync failed: $e');
    }
  }

  /// Fire-and-forget sync to server
  void _syncMarksToServer(Map<int, bool> marks) async {
    try {
      final dio = GetIt.I<Dio>(instanceName: 'BackendDio');
      final marksForSync = marks.map(
        (key, value) => MapEntry(key.toString(), value),
      );
      await dio.post('/grammar-quiz/marks/sync', data: {'marks': marksForSync});
      debugPrint('📋 ✅ Lesson marks synced to server');
    } catch (e) {
      debugPrint('📋 ❌ Lesson marks sync failed: $e');
    }
  }

  /// Parse server response (Map<String, bool>) to Map<int, bool>
  Map<int, bool> _parseServerMarks(dynamic data) {
    if (data is Map) {
      return data.map((key, value) => MapEntry(
        int.parse(key.toString()),
        value as bool,
      ));
    }
    return {};
  }
}
