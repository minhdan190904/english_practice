// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../sense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Sense _$SenseFromJson(Map<String, dynamic> json) {
  return _Sense.fromJson(json);
}

/// @nodoc
mixin _$Sense {
  @HiveField(0)
  String get definition => throw _privateConstructorUsedError;
  @HiveField(1)
  List<Example> get examples => throw _privateConstructorUsedError;
  @HiveField(2)
  String get definitionVi => throw _privateConstructorUsedError;
  @HiveField(3)
  String get shortMeaningVi => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SenseCopyWith<Sense> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SenseCopyWith<$Res> {
  factory $SenseCopyWith(Sense value, $Res Function(Sense) then) =
      _$SenseCopyWithImpl<$Res, Sense>;
  @useResult
  $Res call(
      {@HiveField(0) String definition,
      @HiveField(1) List<Example> examples,
      @HiveField(2) String definitionVi,
      @HiveField(3) String shortMeaningVi});
}

/// @nodoc
class _$SenseCopyWithImpl<$Res, $Val extends Sense>
    implements $SenseCopyWith<$Res> {
  _$SenseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? definition = null,
    Object? examples = null,
    Object? definitionVi = null,
    Object? shortMeaningVi = null,
  }) {
    return _then(_value.copyWith(
      definition: null == definition
          ? _value.definition
          : definition // ignore: cast_nullable_to_non_nullable
              as String,
      examples: null == examples
          ? _value.examples
          : examples // ignore: cast_nullable_to_non_nullable
              as List<Example>,
      definitionVi: null == definitionVi
          ? _value.definitionVi
          : definitionVi // ignore: cast_nullable_to_non_nullable
              as String,
      shortMeaningVi: null == shortMeaningVi
          ? _value.shortMeaningVi
          : shortMeaningVi // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SenseImplCopyWith<$Res> implements $SenseCopyWith<$Res> {
  factory _$$SenseImplCopyWith(
          _$SenseImpl value, $Res Function(_$SenseImpl) then) =
      __$$SenseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String definition,
      @HiveField(1) List<Example> examples,
      @HiveField(2) String definitionVi,
      @HiveField(3) String shortMeaningVi});
}

/// @nodoc
class __$$SenseImplCopyWithImpl<$Res>
    extends _$SenseCopyWithImpl<$Res, _$SenseImpl>
    implements _$$SenseImplCopyWith<$Res> {
  __$$SenseImplCopyWithImpl(
      _$SenseImpl _value, $Res Function(_$SenseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? definition = null,
    Object? examples = null,
    Object? definitionVi = null,
    Object? shortMeaningVi = null,
  }) {
    return _then(_$SenseImpl(
      definition: null == definition
          ? _value.definition
          : definition // ignore: cast_nullable_to_non_nullable
              as String,
      examples: null == examples
          ? _value._examples
          : examples // ignore: cast_nullable_to_non_nullable
              as List<Example>,
      definitionVi: null == definitionVi
          ? _value.definitionVi
          : definitionVi // ignore: cast_nullable_to_non_nullable
              as String,
      shortMeaningVi: null == shortMeaningVi
          ? _value.shortMeaningVi
          : shortMeaningVi // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SenseImpl implements _Sense {
  const _$SenseImpl(
      {@HiveField(0) this.definition = "",
      @HiveField(1) final List<Example> examples = const [],
      @HiveField(2) this.definitionVi = "",
      @HiveField(3) this.shortMeaningVi = ""})
      : _examples = examples;

  factory _$SenseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SenseImplFromJson(json);

  @override
  @JsonKey()
  @HiveField(0)
  final String definition;
  final List<Example> _examples;
  @override
  @JsonKey()
  @HiveField(1)
  List<Example> get examples {
    if (_examples is EqualUnmodifiableListView) return _examples;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_examples);
  }

  @override
  @JsonKey()
  @HiveField(2)
  final String definitionVi;
  @override
  @JsonKey()
  @HiveField(3)
  final String shortMeaningVi;

  @override
  String toString() {
    return 'Sense(definition: $definition, examples: $examples, definitionVi: $definitionVi, shortMeaningVi: $shortMeaningVi)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SenseImpl &&
            (identical(other.definition, definition) ||
                other.definition == definition) &&
            const DeepCollectionEquality().equals(other._examples, _examples) &&
            (identical(other.definitionVi, definitionVi) ||
                other.definitionVi == definitionVi) &&
            (identical(other.shortMeaningVi, shortMeaningVi) ||
                other.shortMeaningVi == shortMeaningVi));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      definition,
      const DeepCollectionEquality().hash(_examples),
      definitionVi,
      shortMeaningVi);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SenseImplCopyWith<_$SenseImpl> get copyWith =>
      __$$SenseImplCopyWithImpl<_$SenseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SenseImplToJson(
      this,
    );
  }
}

abstract class _Sense implements Sense {
  const factory _Sense(
      {@HiveField(0) final String definition,
      @HiveField(1) final List<Example> examples,
      @HiveField(2) final String definitionVi,
      @HiveField(3) final String shortMeaningVi}) = _$SenseImpl;

  factory _Sense.fromJson(Map<String, dynamic> json) = _$SenseImpl.fromJson;

  @override
  @HiveField(0)
  String get definition;
  @override
  @HiveField(1)
  List<Example> get examples;
  @override
  @HiveField(2)
  String get definitionVi;
  @override
  @HiveField(3)
  String get shortMeaningVi;
  @override
  @JsonKey(ignore: true)
  _$$SenseImplCopyWith<_$SenseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
