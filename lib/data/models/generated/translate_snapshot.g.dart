// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../translate_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TranslateSnapshotImpl _$$TranslateSnapshotImplFromJson(
        Map<String, dynamic> json) =>
    _$TranslateSnapshotImpl(
      content: json['content'] as String? ?? '',
      spelling: json['spelling'] as String?,
      type: json['type'] as String?,
      moreTranslations: (json['more_translations'] as List<dynamic>?)
              ?.map((e) => ExtraTranslation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TranslateSnapshotImplToJson(
        _$TranslateSnapshotImpl instance) =>
    <String, dynamic>{
      'content': instance.content,
      'spelling': instance.spelling,
      'type': instance.type,
      'more_translations':
          instance.moreTranslations.map((e) => e.toJson()).toList(),
    };
