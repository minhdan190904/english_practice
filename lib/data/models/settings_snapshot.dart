import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../configs/hive/hive_types.dart';

part 'generated/settings_snapshot.freezed.dart';

part 'generated/settings_snapshot.g.dart';

@freezed
@HiveType(typeId: HiveTypes.settingsSnapshot)
class SettingsSnapshot with _$SettingsSnapshot {
  const factory SettingsSnapshot({
    @HiveField(0) @Default(0X2196F3) int seek,
    @HiveField(1) @Default(0) int themeMode,
    /// 'en' = English (default), 'vi' = Vietnamese
    @HiveField(2) @Default('en') String locale,
  }) = _SettingsSnapshot;

  factory SettingsSnapshot.fromJson(Map<String, dynamic> json) => _$SettingsSnapshotFromJson(json);
}