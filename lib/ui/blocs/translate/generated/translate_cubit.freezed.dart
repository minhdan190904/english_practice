// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../translate_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TranslateState {
  TranslateSnapshot? get translateSnapshot =>
      throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TranslateStateCopyWith<TranslateState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TranslateStateCopyWith<$Res> {
  factory $TranslateStateCopyWith(
          TranslateState value, $Res Function(TranslateState) then) =
      _$TranslateStateCopyWithImpl<$Res, TranslateState>;
  @useResult
  $Res call(
      {TranslateSnapshot? translateSnapshot,
      String? errorMessage,
      bool isLoading});

  $TranslateSnapshotCopyWith<$Res>? get translateSnapshot;
}

/// @nodoc
class _$TranslateStateCopyWithImpl<$Res, $Val extends TranslateState>
    implements $TranslateStateCopyWith<$Res> {
  _$TranslateStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? translateSnapshot = freezed,
    Object? errorMessage = freezed,
    Object? isLoading = null,
  }) {
    return _then(_value.copyWith(
      translateSnapshot: freezed == translateSnapshot
          ? _value.translateSnapshot
          : translateSnapshot // ignore: cast_nullable_to_non_nullable
              as TranslateSnapshot?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TranslateSnapshotCopyWith<$Res>? get translateSnapshot {
    if (_value.translateSnapshot == null) {
      return null;
    }

    return $TranslateSnapshotCopyWith<$Res>(_value.translateSnapshot!, (value) {
      return _then(_value.copyWith(translateSnapshot: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TranslateStateImplCopyWith<$Res>
    implements $TranslateStateCopyWith<$Res> {
  factory _$$TranslateStateImplCopyWith(_$TranslateStateImpl value,
          $Res Function(_$TranslateStateImpl) then) =
      __$$TranslateStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {TranslateSnapshot? translateSnapshot,
      String? errorMessage,
      bool isLoading});

  @override
  $TranslateSnapshotCopyWith<$Res>? get translateSnapshot;
}

/// @nodoc
class __$$TranslateStateImplCopyWithImpl<$Res>
    extends _$TranslateStateCopyWithImpl<$Res, _$TranslateStateImpl>
    implements _$$TranslateStateImplCopyWith<$Res> {
  __$$TranslateStateImplCopyWithImpl(
      _$TranslateStateImpl _value, $Res Function(_$TranslateStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? translateSnapshot = freezed,
    Object? errorMessage = freezed,
    Object? isLoading = null,
  }) {
    return _then(_$TranslateStateImpl(
      translateSnapshot: freezed == translateSnapshot
          ? _value.translateSnapshot
          : translateSnapshot // ignore: cast_nullable_to_non_nullable
              as TranslateSnapshot?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$TranslateStateImpl implements _TranslateState {
  const _$TranslateStateImpl(
      {this.translateSnapshot, this.errorMessage, this.isLoading = false});

  @override
  final TranslateSnapshot? translateSnapshot;
  @override
  final String? errorMessage;
  @override
  @JsonKey()
  final bool isLoading;

  @override
  String toString() {
    return 'TranslateState(translateSnapshot: $translateSnapshot, errorMessage: $errorMessage, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TranslateStateImpl &&
            (identical(other.translateSnapshot, translateSnapshot) ||
                other.translateSnapshot == translateSnapshot) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, translateSnapshot, errorMessage, isLoading);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TranslateStateImplCopyWith<_$TranslateStateImpl> get copyWith =>
      __$$TranslateStateImplCopyWithImpl<_$TranslateStateImpl>(
          this, _$identity);
}

abstract class _TranslateState implements TranslateState {
  const factory _TranslateState(
      {final TranslateSnapshot? translateSnapshot,
      final String? errorMessage,
      final bool isLoading}) = _$TranslateStateImpl;

  @override
  TranslateSnapshot? get translateSnapshot;
  @override
  String? get errorMessage;
  @override
  bool get isLoading;
  @override
  @JsonKey(ignore: true)
  _$$TranslateStateImplCopyWith<_$TranslateStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
