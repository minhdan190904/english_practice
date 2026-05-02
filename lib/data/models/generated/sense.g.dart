// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../sense.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SenseAdapter extends TypeAdapter<Sense> {
  @override
  final int typeId = 1;

  @override
  Sense read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sense(
      definition: fields[0] as String,
      examples: (fields[1] as List).cast<Example>(),
    );
  }

  @override
  void write(BinaryWriter writer, Sense obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.definition)
      ..writeByte(1)
      ..write(obj.examples);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SenseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SenseImpl _$$SenseImplFromJson(Map<String, dynamic> json) => _$SenseImpl(
      definition: json['definition'] as String? ?? "",
      examples: (json['examples'] as List<dynamic>?)
              ?.map((e) => Example.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$SenseImplToJson(_$SenseImpl instance) =>
    <String, dynamic>{
      'definition': instance.definition,
      'examples': instance.examples.map((e) => e.toJson()).toList(),
    };
