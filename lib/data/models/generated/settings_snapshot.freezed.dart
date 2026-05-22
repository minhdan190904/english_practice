// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../settings_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SettingsSnapshot _$SettingsSnapshotFromJson(Map<String, dynamic> json) {
  return _SettingsSnapshot.fromJson(json);
}

/// @nodoc
mixin _$SettingsSnapshot {
  @HiveField(0)
  int get seek => throw _privateConstructorUsedError;
  @HiveField(1)
  int get themeMode => throw _privateConstructorUsedError;
  @HiveField(2)
  String get locale => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SettingsSnapshotCopyWith<SettingsSnapshot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsSnapshotCopyWith<$Res> {
  factory $SettingsSnapshotCopyWith(
          SettingsSnapshot value, $Res Function(SettingsSnapshot) then) =
      _$SettingsSnapshotCopyWithImpl<$Res, SettingsSnapshot>;
  @useResult
  $Res call({@HiveField(0) int seek, @HiveField(1) int themeMode, @HiveField(2) String locale});
}

/// @nodoc
class _$SettingsSnapshotCopyWithImpl<$Res, $Val extends SettingsSnapshot>
    implements $SettingsSnapshotCopyWith<$Res> {
  _$SettingsSnapshotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? seek = null,
    Object? themeMode = null,
    Object? locale = null,
  }) {
    return _then(_value.copyWith(
      seek: null == seek
          ? _value.seek
          : seek // ignore: cast_nullable_to_non_nullable
              as int,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as int,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SettingsSnapshotImplCopyWith<$Res>
    implements $SettingsSnapshotCopyWith<$Res> {
  factory _$$SettingsSnapshotImplCopyWith(_$SettingsSnapshotImpl value,
          $Res Function(_$SettingsSnapshotImpl) then) =
      __$$SettingsSnapshotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@HiveField(0) int seek, @HiveField(1) int themeMode, @HiveField(2) String locale});
}

/// @nodoc
class __$$SettingsSnapshotImplCopyWithImpl<$Res>
    extends _$SettingsSnapshotCopyWithImpl<$Res, _$SettingsSnapshotImpl>
    implements _$$SettingsSnapshotImplCopyWith<$Res> {
  __$$SettingsSnapshotImplCopyWithImpl(_$SettingsSnapshotImpl _value,
      $Res Function(_$SettingsSnapshotImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? seek = null,
    Object? themeMode = null,
    Object? locale = null,
  }) {
    return _then(_$SettingsSnapshotImpl(
      seek: null == seek
          ? _value.seek
          : seek // ignore: cast_nullable_to_non_nullable
              as int,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as int,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SettingsSnapshotImpl implements _SettingsSnapshot {
  const _$SettingsSnapshotImpl(
      {@HiveField(0) this.seek = 0X2196F3,
      @HiveField(1) this.themeMode = 0,
      @HiveField(2) this.locale = 'en'});

  factory _$SettingsSnapshotImpl.fromJson(Map<String, dynamic> json) =>
      _$$SettingsSnapshotImplFromJson(json);

  @override
  @JsonKey()
  @HiveField(0)
  final int seek;
  @override
  @JsonKey()
  @HiveField(1)
  final int themeMode;
  @override
  @JsonKey()
  @HiveField(2)
  final String locale;

  @override
  String toString() {
    return 'SettingsSnapshot(seek: $seek, themeMode: $themeMode, locale: $locale)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsSnapshotImpl &&
            (identical(other.seek, seek) || other.seek == seek) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.locale, locale) || other.locale == locale));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, seek, themeMode, locale);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingsSnapshotImplCopyWith<_$SettingsSnapshotImpl> get copyWith =>
      __$$SettingsSnapshotImplCopyWithImpl<_$SettingsSnapshotImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SettingsSnapshotImplToJson(
      this,
    );
  }
}

abstract class _SettingsSnapshot implements SettingsSnapshot {
  const factory _SettingsSnapshot(
      {@HiveField(0) final int seek,
      @HiveField(1) final int themeMode,
      @HiveField(2) final String locale}) = _$SettingsSnapshotImpl;

  factory _SettingsSnapshot.fromJson(Map<String, dynamic> json) =
      _$SettingsSnapshotImpl.fromJson;

  @override
  @HiveField(0)
  int get seek;
  @override
  @HiveField(1)
  int get themeMode;
  @override
  @HiveField(2)
  String get locale;
  @override
  @JsonKey(ignore: true)
  _$$SettingsSnapshotImplCopyWith<_$SettingsSnapshotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
