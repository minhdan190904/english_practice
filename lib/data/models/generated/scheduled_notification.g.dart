// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../scheduled_notification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScheduledNotificationAdapter extends TypeAdapter<ScheduledNotification> {
  @override
  final int typeId = 5;

  @override
  ScheduledNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScheduledNotification(
      id: fields[0] as int,
      title: fields[1] as String,
      body: fields[2] as String,
      scheduledDate: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ScheduledNotification obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.scheduledDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduledNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScheduledNotificationImpl _$$ScheduledNotificationImplFromJson(
        Map<String, dynamic> json) =>
    _$ScheduledNotificationImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? "",
      body: json['body'] as String? ?? "",
      scheduledDate: json['scheduled_date'] as String? ?? "",
    );

Map<String, dynamic> _$$ScheduledNotificationImplToJson(
        _$ScheduledNotificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'scheduled_date': instance.scheduledDate,
    };
