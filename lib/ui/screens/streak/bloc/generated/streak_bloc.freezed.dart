// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../streak_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$StreakEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() watchStreak,
    required TResult Function(StreakState state) emitState,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? watchStreak,
    TResult? Function(StreakState state)? emitState,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? watchStreak,
    TResult Function(StreakState state)? emitState,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WatchStreak value) watchStreak,
    required TResult Function(EmitState value) emitState,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WatchStreak value)? watchStreak,
    TResult? Function(EmitState value)? emitState,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WatchStreak value)? watchStreak,
    TResult Function(EmitState value)? emitState,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StreakEventCopyWith<$Res> {
  factory $StreakEventCopyWith(
          StreakEvent value, $Res Function(StreakEvent) then) =
      _$StreakEventCopyWithImpl<$Res, StreakEvent>;
}

/// @nodoc
class _$StreakEventCopyWithImpl<$Res, $Val extends StreakEvent>
    implements $StreakEventCopyWith<$Res> {
  _$StreakEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$WatchStreakImplCopyWith<$Res> {
  factory _$$WatchStreakImplCopyWith(
          _$WatchStreakImpl value, $Res Function(_$WatchStreakImpl) then) =
      __$$WatchStreakImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$WatchStreakImplCopyWithImpl<$Res>
    extends _$StreakEventCopyWithImpl<$Res, _$WatchStreakImpl>
    implements _$$WatchStreakImplCopyWith<$Res> {
  __$$WatchStreakImplCopyWithImpl(
      _$WatchStreakImpl _value, $Res Function(_$WatchStreakImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$WatchStreakImpl implements WatchStreak {
  const _$WatchStreakImpl();

  @override
  String toString() {
    return 'StreakEvent.watchStreak()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$WatchStreakImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() watchStreak,
    required TResult Function(StreakState state) emitState,
  }) {
    return watchStreak();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? watchStreak,
    TResult? Function(StreakState state)? emitState,
  }) {
    return watchStreak?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? watchStreak,
    TResult Function(StreakState state)? emitState,
    required TResult orElse(),
  }) {
    if (watchStreak != null) {
      return watchStreak();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WatchStreak value) watchStreak,
    required TResult Function(EmitState value) emitState,
  }) {
    return watchStreak(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WatchStreak value)? watchStreak,
    TResult? Function(EmitState value)? emitState,
  }) {
    return watchStreak?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WatchStreak value)? watchStreak,
    TResult Function(EmitState value)? emitState,
    required TResult orElse(),
  }) {
    if (watchStreak != null) {
      return watchStreak(this);
    }
    return orElse();
  }
}

abstract class WatchStreak implements StreakEvent {
  const factory WatchStreak() = _$WatchStreakImpl;
}

/// @nodoc
abstract class _$$EmitStateImplCopyWith<$Res> {
  factory _$$EmitStateImplCopyWith(
          _$EmitStateImpl value, $Res Function(_$EmitStateImpl) then) =
      __$$EmitStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({StreakState state});

  $StreakStateCopyWith<$Res> get state;
}

/// @nodoc
class __$$EmitStateImplCopyWithImpl<$Res>
    extends _$StreakEventCopyWithImpl<$Res, _$EmitStateImpl>
    implements _$$EmitStateImplCopyWith<$Res> {
  __$$EmitStateImplCopyWithImpl(
      _$EmitStateImpl _value, $Res Function(_$EmitStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
  }) {
    return _then(_$EmitStateImpl(
      null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as StreakState,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $StreakStateCopyWith<$Res> get state {
    return $StreakStateCopyWith<$Res>(_value.state, (value) {
      return _then(_value.copyWith(state: value));
    });
  }
}

/// @nodoc

class _$EmitStateImpl implements EmitState {
  const _$EmitStateImpl(this.state);

  @override
  final StreakState state;

  @override
  String toString() {
    return 'StreakEvent.emitState(state: $state)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmitStateImpl &&
            (identical(other.state, state) || other.state == state));
  }

  @override
  int get hashCode => Object.hash(runtimeType, state);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EmitStateImplCopyWith<_$EmitStateImpl> get copyWith =>
      __$$EmitStateImplCopyWithImpl<_$EmitStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() watchStreak,
    required TResult Function(StreakState state) emitState,
  }) {
    return emitState(state);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? watchStreak,
    TResult? Function(StreakState state)? emitState,
  }) {
    return emitState?.call(state);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? watchStreak,
    TResult Function(StreakState state)? emitState,
    required TResult orElse(),
  }) {
    if (emitState != null) {
      return emitState(state);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WatchStreak value) watchStreak,
    required TResult Function(EmitState value) emitState,
  }) {
    return emitState(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WatchStreak value)? watchStreak,
    TResult? Function(EmitState value)? emitState,
  }) {
    return emitState?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WatchStreak value)? watchStreak,
    TResult Function(EmitState value)? emitState,
    required TResult orElse(),
  }) {
    if (emitState != null) {
      return emitState(this);
    }
    return orElse();
  }
}

abstract class EmitState implements StreakEvent {
  const factory EmitState(final StreakState state) = _$EmitStateImpl;

  StreakState get state;
  @JsonKey(ignore: true)
  _$$EmitStateImplCopyWith<_$EmitStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$StreakState {
  int get streak => throw _privateConstructorUsedError;
  int get longestStreak => throw _privateConstructorUsedError;
  int get spentTimeToday => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $StreakStateCopyWith<StreakState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StreakStateCopyWith<$Res> {
  factory $StreakStateCopyWith(
          StreakState value, $Res Function(StreakState) then) =
      _$StreakStateCopyWithImpl<$Res, StreakState>;
  @useResult
  $Res call({int streak, int longestStreak, int spentTimeToday});
}

/// @nodoc
class _$StreakStateCopyWithImpl<$Res, $Val extends StreakState>
    implements $StreakStateCopyWith<$Res> {
  _$StreakStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? streak = null,
    Object? longestStreak = null,
    Object? spentTimeToday = null,
  }) {
    return _then(_value.copyWith(
      streak: null == streak
          ? _value.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      spentTimeToday: null == spentTimeToday
          ? _value.spentTimeToday
          : spentTimeToday // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StreakStateImplCopyWith<$Res>
    implements $StreakStateCopyWith<$Res> {
  factory _$$StreakStateImplCopyWith(
          _$StreakStateImpl value, $Res Function(_$StreakStateImpl) then) =
      __$$StreakStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int streak, int longestStreak, int spentTimeToday});
}

/// @nodoc
class __$$StreakStateImplCopyWithImpl<$Res>
    extends _$StreakStateCopyWithImpl<$Res, _$StreakStateImpl>
    implements _$$StreakStateImplCopyWith<$Res> {
  __$$StreakStateImplCopyWithImpl(
      _$StreakStateImpl _value, $Res Function(_$StreakStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? streak = null,
    Object? longestStreak = null,
    Object? spentTimeToday = null,
  }) {
    return _then(_$StreakStateImpl(
      streak: null == streak
          ? _value.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      spentTimeToday: null == spentTimeToday
          ? _value.spentTimeToday
          : spentTimeToday // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$StreakStateImpl implements _StreakState {
  const _$StreakStateImpl(
      {this.streak = 0, this.longestStreak = 0, this.spentTimeToday = 0});

  @override
  @JsonKey()
  final int streak;
  @override
  @JsonKey()
  final int longestStreak;
  @override
  @JsonKey()
  final int spentTimeToday;

  @override
  String toString() {
    return 'StreakState(streak: $streak, longestStreak: $longestStreak, spentTimeToday: $spentTimeToday)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreakStateImpl &&
            (identical(other.streak, streak) || other.streak == streak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.spentTimeToday, spentTimeToday) ||
                other.spentTimeToday == spentTimeToday));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, streak, longestStreak, spentTimeToday);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StreakStateImplCopyWith<_$StreakStateImpl> get copyWith =>
      __$$StreakStateImplCopyWithImpl<_$StreakStateImpl>(this, _$identity);
}

abstract class _StreakState implements StreakState {
  const factory _StreakState(
      {final int streak,
      final int longestStreak,
      final int spentTimeToday}) = _$StreakStateImpl;

  @override
  int get streak;
  @override
  int get longestStreak;
  @override
  int get spentTimeToday;
  @override
  @JsonKey(ignore: true)
  _$$StreakStateImplCopyWith<_$StreakStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
