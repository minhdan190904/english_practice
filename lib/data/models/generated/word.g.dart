// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../word.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordAdapter extends TypeAdapter<Word> {
  @override
  final int typeId = 2;

  @override
  Word read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Word(
      word: fields[0] as String,
      pos: fields[1] as String,
      phonetic: fields[2] as String,
      phoneticText: fields[3] as String,
      phoneticAm: fields[4] as String,
      phoneticAmText: fields[5] as String,
      senses: (fields[6] as List).cast<Sense>(),
      status: fields[7] as WordStatus,
      index: fields[8] as int,
      userDefinition: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Word obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.word)
      ..writeByte(1)
      ..write(obj.pos)
      ..writeByte(2)
      ..write(obj.phonetic)
      ..writeByte(3)
      ..write(obj.phoneticText)
      ..writeByte(4)
      ..write(obj.phoneticAm)
      ..writeByte(5)
      ..write(obj.phoneticAmText)
      ..writeByte(6)
      ..write(obj.senses)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.index)
      ..writeByte(9)
      ..write(obj.userDefinition);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WordImpl _$$WordImplFromJson(Map<String, dynamic> json) => _$WordImpl(
      word: json['word'] as String? ?? "",
      pos: json['pos'] as String? ?? "",
      phonetic: json['phonetic'] as String? ?? "",
      phoneticText: json['phonetic_text'] as String? ?? "",
      phoneticAm: json['phonetic_am'] as String? ?? "",
      phoneticAmText: json['phonetic_am_text'] as String? ?? "",
      senses: (json['senses'] as List<dynamic>?)
              ?.map((e) => Sense.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      status: $enumDecodeNullable(_$WordStatusEnumMap, json['status']) ??
          WordStatus.unknown,
      index: (json['index'] as num?)?.toInt() ?? 0,
      userDefinition: json['user_definition'] as String? ?? null,
    );

Map<String, dynamic> _$$WordImplToJson(_$WordImpl instance) =>
    <String, dynamic>{
      'word': instance.word,
      'pos': instance.pos,
      'phonetic': instance.phonetic,
      'phonetic_text': instance.phoneticText,
      'phonetic_am': instance.phoneticAm,
      'phonetic_am_text': instance.phoneticAmText,
      'senses': instance.senses.map((e) => e.toJson()).toList(),
      'status': _$WordStatusEnumMap[instance.status]!,
      'index': instance.index,
      'user_definition': instance.userDefinition,
    };

const _$WordStatusEnumMap = {
  WordStatus.unknown: 'unknown',
  WordStatus.mastered: 'mastered',
  WordStatus.star: 'star',
};
