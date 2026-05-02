// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../example.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExampleAdapter extends TypeAdapter<Example> {
  @override
  final int typeId = 0;

  @override
  Example read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Example(
      cf: fields[0] as String,
      x: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Example obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.cf)
      ..writeByte(1)
      ..write(obj.x);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExampleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExampleImpl _$$ExampleImplFromJson(Map<String, dynamic> json) =>
    _$ExampleImpl(
      cf: json['cf'] as String? ?? "",
      x: json['x'] as String? ?? "",
    );

Map<String, dynamic> _$$ExampleImplToJson(_$ExampleImpl instance) =>
    <String, dynamic>{
      'cf': instance.cf,
      'x': instance.x,
    };
