// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../settings_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SettingsEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() getSettings,
    required TResult Function(int? seek, int? themeMode) saveSettings,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? getSettings,
    TResult? Function(int? seek, int? themeMode)? saveSettings,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? getSettings,
    TResult Function(int? seek, int? themeMode)? saveSettings,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GetSettings value) getSettings,
    required TResult Function(_SaveSettings value) saveSettings,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GetSettings value)? getSettings,
    TResult? Function(_SaveSettings value)? saveSettings,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GetSettings value)? getSettings,
    TResult Function(_SaveSettings value)? saveSettings,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsEventCopyWith<$Res> {
  factory $SettingsEventCopyWith(
          SettingsEvent value, $Res Function(SettingsEvent) then) =
      _$SettingsEventCopyWithImpl<$Res, SettingsEvent>;
}

/// @nodoc
class _$SettingsEventCopyWithImpl<$Res, $Val extends SettingsEvent>
    implements $SettingsEventCopyWith<$Res> {
  _$SettingsEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$GetSettingsImplCopyWith<$Res> {
  factory _$$GetSettingsImplCopyWith(
          _$GetSettingsImpl value, $Res Function(_$GetSettingsImpl) then) =
      __$$GetSettingsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GetSettingsImplCopyWithImpl<$Res>
    extends _$SettingsEventCopyWithImpl<$Res, _$GetSettingsImpl>
    implements _$$GetSettingsImplCopyWith<$Res> {
  __$$GetSettingsImplCopyWithImpl(
      _$GetSettingsImpl _value, $Res Function(_$GetSettingsImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$GetSettingsImpl with DiagnosticableTreeMixin implements _GetSettings {
  const _$GetSettingsImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SettingsEvent.getSettings()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'SettingsEvent.getSettings'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$GetSettingsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() getSettings,
    required TResult Function(int? seek, int? themeMode) saveSettings,
  }) {
    return getSettings();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? getSettings,
    TResult? Function(int? seek, int? themeMode)? saveSettings,
  }) {
    return getSettings?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? getSettings,
    TResult Function(int? seek, int? themeMode)? saveSettings,
    required TResult orElse(),
  }) {
    if (getSettings != null) {
      return getSettings();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GetSettings value) getSettings,
    required TResult Function(_SaveSettings value) saveSettings,
  }) {
    return getSettings(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GetSettings value)? getSettings,
    TResult? Function(_SaveSettings value)? saveSettings,
  }) {
    return getSettings?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GetSettings value)? getSettings,
    TResult Function(_SaveSettings value)? saveSettings,
    required TResult orElse(),
  }) {
    if (getSettings != null) {
      return getSettings(this);
    }
    return orElse();
  }
}

abstract class _GetSettings implements SettingsEvent {
  const factory _GetSettings() = _$GetSettingsImpl;
}

/// @nodoc
abstract class _$$SaveSettingsImplCopyWith<$Res> {
  factory _$$SaveSettingsImplCopyWith(
          _$SaveSettingsImpl value, $Res Function(_$SaveSettingsImpl) then) =
      __$$SaveSettingsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int? seek, int? themeMode});
}

/// @nodoc
class __$$SaveSettingsImplCopyWithImpl<$Res>
    extends _$SettingsEventCopyWithImpl<$Res, _$SaveSettingsImpl>
    implements _$$SaveSettingsImplCopyWith<$Res> {
  __$$SaveSettingsImplCopyWithImpl(
      _$SaveSettingsImpl _value, $Res Function(_$SaveSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? seek = freezed,
    Object? themeMode = freezed,
  }) {
    return _then(_$SaveSettingsImpl(
      seek: freezed == seek
          ? _value.seek
          : seek // ignore: cast_nullable_to_non_nullable
              as int?,
      themeMode: freezed == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$SaveSettingsImpl with DiagnosticableTreeMixin implements _SaveSettings {
  const _$SaveSettingsImpl({this.seek, this.themeMode});

  @override
  final int? seek;
  @override
  final int? themeMode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SettingsEvent.saveSettings(seek: $seek, themeMode: $themeMode)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SettingsEvent.saveSettings'))
      ..add(DiagnosticsProperty('seek', seek))
      ..add(DiagnosticsProperty('themeMode', themeMode));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaveSettingsImpl &&
            (identical(other.seek, seek) || other.seek == seek) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, seek, themeMode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SaveSettingsImplCopyWith<_$SaveSettingsImpl> get copyWith =>
      __$$SaveSettingsImplCopyWithImpl<_$SaveSettingsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() getSettings,
    required TResult Function(int? seek, int? themeMode) saveSettings,
  }) {
    return saveSettings(seek, themeMode);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? getSettings,
    TResult? Function(int? seek, int? themeMode)? saveSettings,
  }) {
    return saveSettings?.call(seek, themeMode);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? getSettings,
    TResult Function(int? seek, int? themeMode)? saveSettings,
    required TResult orElse(),
  }) {
    if (saveSettings != null) {
      return saveSettings(seek, themeMode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GetSettings value) getSettings,
    required TResult Function(_SaveSettings value) saveSettings,
  }) {
    return saveSettings(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GetSettings value)? getSettings,
    TResult? Function(_SaveSettings value)? saveSettings,
  }) {
    return saveSettings?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GetSettings value)? getSettings,
    TResult Function(_SaveSettings value)? saveSettings,
    required TResult orElse(),
  }) {
    if (saveSettings != null) {
      return saveSettings(this);
    }
    return orElse();
  }
}

abstract class _SaveSettings implements SettingsEvent {
  const factory _SaveSettings({final int? seek, final int? themeMode}) =
      _$SaveSettingsImpl;

  int? get seek;
  int? get themeMode;
  @JsonKey(ignore: true)
  _$$SaveSettingsImplCopyWith<_$SaveSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SettingsState {
  SettingsSnapshot get settingsSnapshot => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SettingsStateCopyWith<SettingsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsStateCopyWith<$Res> {
  factory $SettingsStateCopyWith(
          SettingsState value, $Res Function(SettingsState) then) =
      _$SettingsStateCopyWithImpl<$Res, SettingsState>;
  @useResult
  $Res call({SettingsSnapshot settingsSnapshot});

  $SettingsSnapshotCopyWith<$Res> get settingsSnapshot;
}

/// @nodoc
class _$SettingsStateCopyWithImpl<$Res, $Val extends SettingsState>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? settingsSnapshot = null,
  }) {
    return _then(_value.copyWith(
      settingsSnapshot: null == settingsSnapshot
          ? _value.settingsSnapshot
          : settingsSnapshot // ignore: cast_nullable_to_non_nullable
              as SettingsSnapshot,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SettingsSnapshotCopyWith<$Res> get settingsSnapshot {
    return $SettingsSnapshotCopyWith<$Res>(_value.settingsSnapshot, (value) {
      return _then(_value.copyWith(settingsSnapshot: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SettingsStateImplCopyWith<$Res>
    implements $SettingsStateCopyWith<$Res> {
  factory _$$SettingsStateImplCopyWith(
          _$SettingsStateImpl value, $Res Function(_$SettingsStateImpl) then) =
      __$$SettingsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SettingsSnapshot settingsSnapshot});

  @override
  $SettingsSnapshotCopyWith<$Res> get settingsSnapshot;
}

/// @nodoc
class __$$SettingsStateImplCopyWithImpl<$Res>
    extends _$SettingsStateCopyWithImpl<$Res, _$SettingsStateImpl>
    implements _$$SettingsStateImplCopyWith<$Res> {
  __$$SettingsStateImplCopyWithImpl(
      _$SettingsStateImpl _value, $Res Function(_$SettingsStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? settingsSnapshot = null,
  }) {
    return _then(_$SettingsStateImpl(
      settingsSnapshot: null == settingsSnapshot
          ? _value.settingsSnapshot
          : settingsSnapshot // ignore: cast_nullable_to_non_nullable
              as SettingsSnapshot,
    ));
  }
}

/// @nodoc

class _$SettingsStateImpl
    with DiagnosticableTreeMixin
    implements _SettingsState {
  const _$SettingsStateImpl({this.settingsSnapshot = const SettingsSnapshot()});

  @override
  @JsonKey()
  final SettingsSnapshot settingsSnapshot;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SettingsState(settingsSnapshot: $settingsSnapshot)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SettingsState'))
      ..add(DiagnosticsProperty('settingsSnapshot', settingsSnapshot));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsStateImpl &&
            (identical(other.settingsSnapshot, settingsSnapshot) ||
                other.settingsSnapshot == settingsSnapshot));
  }

  @override
  int get hashCode => Object.hash(runtimeType, settingsSnapshot);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingsStateImplCopyWith<_$SettingsStateImpl> get copyWith =>
      __$$SettingsStateImplCopyWithImpl<_$SettingsStateImpl>(this, _$identity);
}

abstract class _SettingsState implements SettingsState {
  const factory _SettingsState({final SettingsSnapshot settingsSnapshot}) =
      _$SettingsStateImpl;

  @override
  SettingsSnapshot get settingsSnapshot;
  @override
  @JsonKey(ignore: true)
  _$$SettingsStateImplCopyWith<_$SettingsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
