// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../settings_snapshot.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsSnapshotAdapter extends TypeAdapter<SettingsSnapshot> {
  @override
  final int typeId = 4;

  @override
  SettingsSnapshot read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsSnapshot(
      seek: fields[0] as int,
      themeMode: fields[1] as int,
      // Backward compatible: nếu user cũ chưa có field 2 thì dùng 'en'
      locale: fields[2] as String? ?? 'en',
    );
  }

  @override
  void write(BinaryWriter writer, SettingsSnapshot obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.seek)
      ..writeByte(1)
      ..write(obj.themeMode)
      ..writeByte(2)
      ..write(obj.locale);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsSnapshotAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettingsSnapshotImpl _$$SettingsSnapshotImplFromJson(
        Map<String, dynamic> json) =>
    _$SettingsSnapshotImpl(
      seek: (json['seek'] as num?)?.toInt() ?? 0X2196F3,
      themeMode: (json['theme_mode'] as num?)?.toInt() ?? 0,
      locale: json['locale'] as String? ?? 'en',
    );

Map<String, dynamic> _$$SettingsSnapshotImplToJson(
        _$SettingsSnapshotImpl instance) =>
    <String, dynamic>{
      'seek': instance.seek,
      'theme_mode': instance.themeMode,
      'locale': instance.locale,
    };
