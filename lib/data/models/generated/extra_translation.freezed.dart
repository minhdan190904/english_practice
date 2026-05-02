// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../extra_translation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExtraTranslation _$ExtraTranslationFromJson(Map<String, dynamic> json) {
  return _ExtraTranslation.fromJson(json);
}

/// @nodoc
mixin _$ExtraTranslation {
  String get label => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  List<String> get content => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExtraTranslationCopyWith<ExtraTranslation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExtraTranslationCopyWith<$Res> {
  factory $ExtraTranslationCopyWith(
          ExtraTranslation value, $Res Function(ExtraTranslation) then) =
      _$ExtraTranslationCopyWithImpl<$Res, ExtraTranslation>;
  @useResult
  $Res call({String label, String type, List<String> content});
}

/// @nodoc
class _$ExtraTranslationCopyWithImpl<$Res, $Val extends ExtraTranslation>
    implements $ExtraTranslationCopyWith<$Res> {
  _$ExtraTranslationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? type = null,
    Object? content = null,
  }) {
    return _then(_value.copyWith(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExtraTranslationImplCopyWith<$Res>
    implements $ExtraTranslationCopyWith<$Res> {
  factory _$$ExtraTranslationImplCopyWith(_$ExtraTranslationImpl value,
          $Res Function(_$ExtraTranslationImpl) then) =
      __$$ExtraTranslationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String label, String type, List<String> content});
}

/// @nodoc
class __$$ExtraTranslationImplCopyWithImpl<$Res>
    extends _$ExtraTranslationCopyWithImpl<$Res, _$ExtraTranslationImpl>
    implements _$$ExtraTranslationImplCopyWith<$Res> {
  __$$ExtraTranslationImplCopyWithImpl(_$ExtraTranslationImpl _value,
      $Res Function(_$ExtraTranslationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? type = null,
    Object? content = null,
  }) {
    return _then(_$ExtraTranslationImpl(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value._content
          : content // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExtraTranslationImpl implements _ExtraTranslation {
  const _$ExtraTranslationImpl(
      {required this.label,
      required this.type,
      required final List<String> content})
      : _content = content;

  factory _$ExtraTranslationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExtraTranslationImplFromJson(json);

  @override
  final String label;
  @override
  final String type;
  final List<String> _content;
  @override
  List<String> get content {
    if (_content is EqualUnmodifiableListView) return _content;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_content);
  }

  @override
  String toString() {
    return 'ExtraTranslation(label: $label, type: $type, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExtraTranslationImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._content, _content));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, label, type, const DeepCollectionEquality().hash(_content));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExtraTranslationImplCopyWith<_$ExtraTranslationImpl> get copyWith =>
      __$$ExtraTranslationImplCopyWithImpl<_$ExtraTranslationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExtraTranslationImplToJson(
      this,
    );
  }
}

abstract class _ExtraTranslation implements ExtraTranslation {
  const factory _ExtraTranslation(
      {required final String label,
      required final String type,
      required final List<String> content}) = _$ExtraTranslationImpl;

  factory _ExtraTranslation.fromJson(Map<String, dynamic> json) =
      _$ExtraTranslationImpl.fromJson;

  @override
  String get label;
  @override
  String get type;
  @override
  List<String> get content;
  @override
  @JsonKey(ignore: true)
  _$$ExtraTranslationImplCopyWith<_$ExtraTranslationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
