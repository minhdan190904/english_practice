// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../lesson_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LessonEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int id, bool isMarked) markLesson,
    required TResult Function() loadMarkedLessons,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int id, bool isMarked)? markLesson,
    TResult? Function()? loadMarkedLessons,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int id, bool isMarked)? markLesson,
    TResult Function()? loadMarkedLessons,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_MarkLesson value) markLesson,
    required TResult Function(_LoadMarkedLessons value) loadMarkedLessons,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_MarkLesson value)? markLesson,
    TResult? Function(_LoadMarkedLessons value)? loadMarkedLessons,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_MarkLesson value)? markLesson,
    TResult Function(_LoadMarkedLessons value)? loadMarkedLessons,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LessonEventCopyWith<$Res> {
  factory $LessonEventCopyWith(
          LessonEvent value, $Res Function(LessonEvent) then) =
      _$LessonEventCopyWithImpl<$Res, LessonEvent>;
}

/// @nodoc
class _$LessonEventCopyWithImpl<$Res, $Val extends LessonEvent>
    implements $LessonEventCopyWith<$Res> {
  _$LessonEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$MarkLessonImplCopyWith<$Res> {
  factory _$$MarkLessonImplCopyWith(
          _$MarkLessonImpl value, $Res Function(_$MarkLessonImpl) then) =
      __$$MarkLessonImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int id, bool isMarked});
}

/// @nodoc
class __$$MarkLessonImplCopyWithImpl<$Res>
    extends _$LessonEventCopyWithImpl<$Res, _$MarkLessonImpl>
    implements _$$MarkLessonImplCopyWith<$Res> {
  __$$MarkLessonImplCopyWithImpl(
      _$MarkLessonImpl _value, $Res Function(_$MarkLessonImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? isMarked = null,
  }) {
    return _then(_$MarkLessonImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      isMarked: null == isMarked
          ? _value.isMarked
          : isMarked // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$MarkLessonImpl implements _MarkLesson {
  const _$MarkLessonImpl({required this.id, required this.isMarked});

  @override
  final int id;
  @override
  final bool isMarked;

  @override
  String toString() {
    return 'LessonEvent.markLesson(id: $id, isMarked: $isMarked)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarkLessonImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.isMarked, isMarked) ||
                other.isMarked == isMarked));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, isMarked);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MarkLessonImplCopyWith<_$MarkLessonImpl> get copyWith =>
      __$$MarkLessonImplCopyWithImpl<_$MarkLessonImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int id, bool isMarked) markLesson,
    required TResult Function() loadMarkedLessons,
  }) {
    return markLesson(id, isMarked);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int id, bool isMarked)? markLesson,
    TResult? Function()? loadMarkedLessons,
  }) {
    return markLesson?.call(id, isMarked);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int id, bool isMarked)? markLesson,
    TResult Function()? loadMarkedLessons,
    required TResult orElse(),
  }) {
    if (markLesson != null) {
      return markLesson(id, isMarked);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_MarkLesson value) markLesson,
    required TResult Function(_LoadMarkedLessons value) loadMarkedLessons,
  }) {
    return markLesson(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_MarkLesson value)? markLesson,
    TResult? Function(_LoadMarkedLessons value)? loadMarkedLessons,
  }) {
    return markLesson?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_MarkLesson value)? markLesson,
    TResult Function(_LoadMarkedLessons value)? loadMarkedLessons,
    required TResult orElse(),
  }) {
    if (markLesson != null) {
      return markLesson(this);
    }
    return orElse();
  }
}

abstract class _MarkLesson implements LessonEvent {
  const factory _MarkLesson(
      {required final int id, required final bool isMarked}) = _$MarkLessonImpl;

  int get id;
  bool get isMarked;
  @JsonKey(ignore: true)
  _$$MarkLessonImplCopyWith<_$MarkLessonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadMarkedLessonsImplCopyWith<$Res> {
  factory _$$LoadMarkedLessonsImplCopyWith(_$LoadMarkedLessonsImpl value,
          $Res Function(_$LoadMarkedLessonsImpl) then) =
      __$$LoadMarkedLessonsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadMarkedLessonsImplCopyWithImpl<$Res>
    extends _$LessonEventCopyWithImpl<$Res, _$LoadMarkedLessonsImpl>
    implements _$$LoadMarkedLessonsImplCopyWith<$Res> {
  __$$LoadMarkedLessonsImplCopyWithImpl(_$LoadMarkedLessonsImpl _value,
      $Res Function(_$LoadMarkedLessonsImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadMarkedLessonsImpl implements _LoadMarkedLessons {
  const _$LoadMarkedLessonsImpl();

  @override
  String toString() {
    return 'LessonEvent.loadMarkedLessons()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadMarkedLessonsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int id, bool isMarked) markLesson,
    required TResult Function() loadMarkedLessons,
  }) {
    return loadMarkedLessons();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int id, bool isMarked)? markLesson,
    TResult? Function()? loadMarkedLessons,
  }) {
    return loadMarkedLessons?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int id, bool isMarked)? markLesson,
    TResult Function()? loadMarkedLessons,
    required TResult orElse(),
  }) {
    if (loadMarkedLessons != null) {
      return loadMarkedLessons();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_MarkLesson value) markLesson,
    required TResult Function(_LoadMarkedLessons value) loadMarkedLessons,
  }) {
    return loadMarkedLessons(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_MarkLesson value)? markLesson,
    TResult? Function(_LoadMarkedLessons value)? loadMarkedLessons,
  }) {
    return loadMarkedLessons?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_MarkLesson value)? markLesson,
    TResult Function(_LoadMarkedLessons value)? loadMarkedLessons,
    required TResult orElse(),
  }) {
    if (loadMarkedLessons != null) {
      return loadMarkedLessons(this);
    }
    return orElse();
  }
}

abstract class _LoadMarkedLessons implements LessonEvent {
  const factory _LoadMarkedLessons() = _$LoadMarkedLessonsImpl;
}

/// @nodoc
mixin _$LessonState {
  Map<int, bool> get markedLessons => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LessonStateCopyWith<LessonState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LessonStateCopyWith<$Res> {
  factory $LessonStateCopyWith(
          LessonState value, $Res Function(LessonState) then) =
      _$LessonStateCopyWithImpl<$Res, LessonState>;
  @useResult
  $Res call({Map<int, bool> markedLessons, String? error, String? message});
}

/// @nodoc
class _$LessonStateCopyWithImpl<$Res, $Val extends LessonState>
    implements $LessonStateCopyWith<$Res> {
  _$LessonStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? markedLessons = null,
    Object? error = freezed,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      markedLessons: null == markedLessons
          ? _value.markedLessons
          : markedLessons // ignore: cast_nullable_to_non_nullable
              as Map<int, bool>,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LessonStateImplCopyWith<$Res>
    implements $LessonStateCopyWith<$Res> {
  factory _$$LessonStateImplCopyWith(
          _$LessonStateImpl value, $Res Function(_$LessonStateImpl) then) =
      __$$LessonStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<int, bool> markedLessons, String? error, String? message});
}

/// @nodoc
class __$$LessonStateImplCopyWithImpl<$Res>
    extends _$LessonStateCopyWithImpl<$Res, _$LessonStateImpl>
    implements _$$LessonStateImplCopyWith<$Res> {
  __$$LessonStateImplCopyWithImpl(
      _$LessonStateImpl _value, $Res Function(_$LessonStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? markedLessons = null,
    Object? error = freezed,
    Object? message = freezed,
  }) {
    return _then(_$LessonStateImpl(
      markedLessons: null == markedLessons
          ? _value._markedLessons
          : markedLessons // ignore: cast_nullable_to_non_nullable
              as Map<int, bool>,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$LessonStateImpl implements _LessonState {
  const _$LessonStateImpl(
      {final Map<int, bool> markedLessons = const {},
      this.error = null,
      this.message = null})
      : _markedLessons = markedLessons;

  final Map<int, bool> _markedLessons;
  @override
  @JsonKey()
  Map<int, bool> get markedLessons {
    if (_markedLessons is EqualUnmodifiableMapView) return _markedLessons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_markedLessons);
  }

  @override
  @JsonKey()
  final String? error;
  @override
  @JsonKey()
  final String? message;

  @override
  String toString() {
    return 'LessonState(markedLessons: $markedLessons, error: $error, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LessonStateImpl &&
            const DeepCollectionEquality()
                .equals(other._markedLessons, _markedLessons) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_markedLessons), error, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LessonStateImplCopyWith<_$LessonStateImpl> get copyWith =>
      __$$LessonStateImplCopyWithImpl<_$LessonStateImpl>(this, _$identity);
}

abstract class _LessonState implements LessonState {
  const factory _LessonState(
      {final Map<int, bool> markedLessons,
      final String? error,
      final String? message}) = _$LessonStateImpl;

  @override
  Map<int, bool> get markedLessons;
  @override
  String? get error;
  @override
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$LessonStateImplCopyWith<_$LessonStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
