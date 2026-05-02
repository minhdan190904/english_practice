// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../extra_translation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExtraTranslationImpl _$$ExtraTranslationImplFromJson(
        Map<String, dynamic> json) =>
    _$ExtraTranslationImpl(
      label: json['label'] as String,
      type: json['type'] as String,
      content:
          (json['content'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$ExtraTranslationImplToJson(
        _$ExtraTranslationImpl instance) =>
    <String, dynamic>{
      'label': instance.label,
      'type': instance.type,
      'content': instance.content,
    };
