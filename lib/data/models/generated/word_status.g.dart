// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../word_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordStatusAdapter extends TypeAdapter<WordStatus> {
  @override
  final int typeId = 3;

  @override
  WordStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WordStatus.unknown;
      case 1:
        return WordStatus.mastered;
      case 2:
        return WordStatus.star;
      default:
        return WordStatus.unknown;
    }
  }

  @override
  void write(BinaryWriter writer, WordStatus obj) {
    switch (obj) {
      case WordStatus.unknown:
        writer.writeByte(0);
        break;
      case WordStatus.mastered:
        writer.writeByte(1);
        break;
      case WordStatus.star:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
