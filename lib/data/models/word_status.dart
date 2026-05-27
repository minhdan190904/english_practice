import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import '../../utils/l10n.dart';
import '../../configs/hive/hive_types.dart';

part 'generated/word_status.g.dart';

@HiveType(typeId: HiveTypes.wordStatus)
enum WordStatus {
  @HiveField(0)
  unknown,
  @HiveField(1)
  mastered,
  @HiveField(2)
  studying;

  String get value {
    switch (this) {
      case WordStatus.unknown:
        return 'Unknown';
      case WordStatus.mastered:
        return 'Mastered';
      case WordStatus.studying:
        return 'Studying';
    }
  }

  String localizedValue(BuildContext context) {
    switch (this) {
      case WordStatus.unknown:
        return L10n.tr(context, 'status_unknown');
      case WordStatus.mastered:
        return L10n.tr(context, 'status_mastered');
      case WordStatus.studying:
        return L10n.tr(context, 'status_studying');
    }
  }

  /// Convert to backend API string (uppercase enum name).
  String toApiString() {
    switch (this) {
      case WordStatus.unknown:
        return 'UNKNOWN';
      case WordStatus.mastered:
        return 'MASTERED';
      case WordStatus.studying:
        return 'STUDYING';
    }
  }

  /// Parse from backend API string.
  /// Backward compatible: STARRED and LEARNING map to studying.
  static WordStatus fromApiString(String status) {
    switch (status) {
      case 'MASTERED':
        return WordStatus.mastered;
      case 'STUDYING':
      case 'STARRED':
      case 'LEARNING':
        return WordStatus.studying;
      default:
        return WordStatus.unknown;
    }
  }
}