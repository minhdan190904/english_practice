import 'package:hive_flutter/hive_flutter.dart';

import '../../configs/hive/hive_types.dart';

part 'generated/word_status.g.dart';

@HiveType(typeId: HiveTypes.wordStatus)
enum WordStatus {
  @HiveField(0)
  unknown,
  @HiveField(1)
  mastered,
  @HiveField(2)
  star,
  @HiveField(3)
  learning;

  String get value {
    switch (this) {
      case WordStatus.unknown:
        return 'Unknown';
      case WordStatus.mastered:
        return 'Mastered';
      case WordStatus.star:
        return 'Star';
      case WordStatus.learning:
        return 'Learning';
    }
  }

  /// Convert to backend API string (uppercase enum name).
  String toApiString() {
    switch (this) {
      case WordStatus.unknown:
        return 'UNKNOWN';
      case WordStatus.mastered:
        return 'MASTERED';
      case WordStatus.star:
        return 'STARRED';
      case WordStatus.learning:
        return 'LEARNING';
    }
  }

  /// Parse from backend API string.
  static WordStatus fromApiString(String status) {
    switch (status) {
      case 'MASTERED':
        return WordStatus.mastered;
      case 'STARRED':
        return WordStatus.star;
      case 'LEARNING':
        return WordStatus.learning;
      default:
        return WordStatus.unknown;
    }
  }
}