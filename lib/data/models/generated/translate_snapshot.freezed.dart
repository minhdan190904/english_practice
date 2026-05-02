// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../translate_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TranslateSnapshot _$TranslateSnapshotFromJson(Map<String, dynamic> json) {
  return _TranslateSnapshot.fromJson(json);
}

/// @nodoc
mixin _$TranslateSnapshot {
  String get content => throw _privateConstructorUsedError;
  String? get spelling => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  List<ExtraTranslation> get moreTranslations =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TranslateSnapshotCopyWith<TranslateSnapshot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TranslateSnapshotCopyWith<$Res> {
  factory $TranslateSnapshotCopyWith(
          TranslateSnapshot value, $Res Function(TranslateSnapshot) then) =
      _$TranslateSnapshotCopyWithImpl<$Res, TranslateSnapshot>;
  @useResult
  $Res call(
      {String content,
      String? spelling,
      String? type,
      List<ExtraTranslation> moreTranslations});
}

/// @nodoc
class _$TranslateSnapshotCopyWithImpl<$Res, $Val extends TranslateSnapshot>
    implements $TranslateSnapshotCopyWith<$Res> {
  _$TranslateSnapshotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? spelling = freezed,
    Object? type = freezed,
    Object? moreTranslations = null,
  }) {
    return _then(_value.copyWith(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      spelling: freezed == spelling
          ? _value.spelling
          : spelling // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      moreTranslations: null == moreTranslations
          ? _value.moreTranslations
          : moreTranslations // ignore: cast_nullable_to_non_nullable
              as List<ExtraTranslation>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TranslateSnapshotImplCopyWith<$Res>
    implements $TranslateSnapshotCopyWith<$Res> {
  factory _$$TranslateSnapshotImplCopyWith(_$TranslateSnapshotImpl value,
          $Res Function(_$TranslateSnapshotImpl) then) =
      __$$TranslateSnapshotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String content,
      String? spelling,
      String? type,
      List<ExtraTranslation> moreTranslations});
}

/// @nodoc
class __$$TranslateSnapshotImplCopyWithImpl<$Res>
    extends _$TranslateSnapshotCopyWithImpl<$Res, _$TranslateSnapshotImpl>
    implements _$$TranslateSnapshotImplCopyWith<$Res> {
  __$$TranslateSnapshotImplCopyWithImpl(_$TranslateSnapshotImpl _value,
      $Res Function(_$TranslateSnapshotImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? spelling = freezed,
    Object? type = freezed,
    Object? moreTranslations = null,
  }) {
    return _then(_$TranslateSnapshotImpl(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      spelling: freezed == spelling
          ? _value.spelling
          : spelling // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      moreTranslations: null == moreTranslations
          ? _value._moreTranslations
          : moreTranslations // ignore: cast_nullable_to_non_nullable
              as List<ExtraTranslation>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TranslateSnapshotImpl implements _TranslateSnapshot {
  const _$TranslateSnapshotImpl(
      {this.content = '',
      this.spelling,
      this.type,
      final List<ExtraTranslation> moreTranslations = const []})
      : _moreTranslations = moreTranslations;

  factory _$TranslateSnapshotImpl.fromJson(Map<String, dynamic> json) =>
      _$$TranslateSnapshotImplFromJson(json);

  @override
  @JsonKey()
  final String content;
  @override
  final String? spelling;
  @override
  final String? type;
  final List<ExtraTranslation> _moreTranslations;
  @override
  @JsonKey()
  List<ExtraTranslation> get moreTranslations {
    if (_moreTranslations is EqualUnmodifiableListView)
      return _moreTranslations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_moreTranslations);
  }

  @override
  String toString() {
    return 'TranslateSnapshot(content: $content, spelling: $spelling, type: $type, moreTranslations: $moreTranslations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TranslateSnapshotImpl &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.spelling, spelling) ||
                other.spelling == spelling) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other._moreTranslations, _moreTranslations));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, content, spelling, type,
      const DeepCollectionEquality().hash(_moreTranslations));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TranslateSnapshotImplCopyWith<_$TranslateSnapshotImpl> get copyWith =>
      __$$TranslateSnapshotImplCopyWithImpl<_$TranslateSnapshotImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TranslateSnapshotImplToJson(
      this,
    );
  }
}

abstract class _TranslateSnapshot implements TranslateSnapshot {
  const factory _TranslateSnapshot(
      {final String content,
      final String? spelling,
      final String? type,
      final List<ExtraTranslation> moreTranslations}) = _$TranslateSnapshotImpl;

  factory _TranslateSnapshot.fromJson(Map<String, dynamic> json) =
      _$TranslateSnapshotImpl.fromJson;

  @override
  String get content;
  @override
  String? get spelling;
  @override
  String? get type;
  @override
  List<ExtraTranslation> get moreTranslations;
  @override
  @JsonKey(ignore: true)
  _$$TranslateSnapshotImplCopyWith<_$TranslateSnapshotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
