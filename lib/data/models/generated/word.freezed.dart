// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../word.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Word _$WordFromJson(Map<String, dynamic> json) {
  return _Word.fromJson(json);
}

/// @nodoc
mixin _$Word {
  @HiveField(0)
  String get word => throw _privateConstructorUsedError;
  @HiveField(1)
  String get pos => throw _privateConstructorUsedError;
  @HiveField(2)
  String get phonetic => throw _privateConstructorUsedError;
  @HiveField(3)
  String get phoneticText => throw _privateConstructorUsedError;
  @HiveField(4)
  String get phoneticAm => throw _privateConstructorUsedError;
  @HiveField(5)
  String get phoneticAmText => throw _privateConstructorUsedError;
  @HiveField(6)
  List<Sense> get senses => throw _privateConstructorUsedError;
  @HiveField(7)
  WordStatus get status => throw _privateConstructorUsedError;
  @HiveField(8)
  int get index => throw _privateConstructorUsedError;
  @HiveField(9)
  String? get userDefinition => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WordCopyWith<Word> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WordCopyWith<$Res> {
  factory $WordCopyWith(Word value, $Res Function(Word) then) =
      _$WordCopyWithImpl<$Res, Word>;
  @useResult
  $Res call(
      {@HiveField(0) String word,
      @HiveField(1) String pos,
      @HiveField(2) String phonetic,
      @HiveField(3) String phoneticText,
      @HiveField(4) String phoneticAm,
      @HiveField(5) String phoneticAmText,
      @HiveField(6) List<Sense> senses,
      @HiveField(7) WordStatus status,
      @HiveField(8) int index,
      @HiveField(9) String? userDefinition});
}

/// @nodoc
class _$WordCopyWithImpl<$Res, $Val extends Word>
    implements $WordCopyWith<$Res> {
  _$WordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? word = null,
    Object? pos = null,
    Object? phonetic = null,
    Object? phoneticText = null,
    Object? phoneticAm = null,
    Object? phoneticAmText = null,
    Object? senses = null,
    Object? status = null,
    Object? index = null,
    Object? userDefinition = freezed,
  }) {
    return _then(_value.copyWith(
      word: null == word
          ? _value.word
          : word // ignore: cast_nullable_to_non_nullable
              as String,
      pos: null == pos
          ? _value.pos
          : pos // ignore: cast_nullable_to_non_nullable
              as String,
      phonetic: null == phonetic
          ? _value.phonetic
          : phonetic // ignore: cast_nullable_to_non_nullable
              as String,
      phoneticText: null == phoneticText
          ? _value.phoneticText
          : phoneticText // ignore: cast_nullable_to_non_nullable
              as String,
      phoneticAm: null == phoneticAm
          ? _value.phoneticAm
          : phoneticAm // ignore: cast_nullable_to_non_nullable
              as String,
      phoneticAmText: null == phoneticAmText
          ? _value.phoneticAmText
          : phoneticAmText // ignore: cast_nullable_to_non_nullable
              as String,
      senses: null == senses
          ? _value.senses
          : senses // ignore: cast_nullable_to_non_nullable
              as List<Sense>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as WordStatus,
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      userDefinition: freezed == userDefinition
          ? _value.userDefinition
          : userDefinition // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WordImplCopyWith<$Res> implements $WordCopyWith<$Res> {
  factory _$$WordImplCopyWith(
          _$WordImpl value, $Res Function(_$WordImpl) then) =
      __$$WordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String word,
      @HiveField(1) String pos,
      @HiveField(2) String phonetic,
      @HiveField(3) String phoneticText,
      @HiveField(4) String phoneticAm,
      @HiveField(5) String phoneticAmText,
      @HiveField(6) List<Sense> senses,
      @HiveField(7) WordStatus status,
      @HiveField(8) int index,
      @HiveField(9) String? userDefinition});
}

/// @nodoc
class __$$WordImplCopyWithImpl<$Res>
    extends _$WordCopyWithImpl<$Res, _$WordImpl>
    implements _$$WordImplCopyWith<$Res> {
  __$$WordImplCopyWithImpl(_$WordImpl _value, $Res Function(_$WordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? word = null,
    Object? pos = null,
    Object? phonetic = null,
    Object? phoneticText = null,
    Object? phoneticAm = null,
    Object? phoneticAmText = null,
    Object? senses = null,
    Object? status = null,
    Object? index = null,
    Object? userDefinition = freezed,
  }) {
    return _then(_$WordImpl(
      word: null == word
          ? _value.word
          : word // ignore: cast_nullable_to_non_nullable
              as String,
      pos: null == pos
          ? _value.pos
          : pos // ignore: cast_nullable_to_non_nullable
              as String,
      phonetic: null == phonetic
          ? _value.phonetic
          : phonetic // ignore: cast_nullable_to_non_nullable
              as String,
      phoneticText: null == phoneticText
          ? _value.phoneticText
          : phoneticText // ignore: cast_nullable_to_non_nullable
              as String,
      phoneticAm: null == phoneticAm
          ? _value.phoneticAm
          : phoneticAm // ignore: cast_nullable_to_non_nullable
              as String,
      phoneticAmText: null == phoneticAmText
          ? _value.phoneticAmText
          : phoneticAmText // ignore: cast_nullable_to_non_nullable
              as String,
      senses: null == senses
          ? _value._senses
          : senses // ignore: cast_nullable_to_non_nullable
              as List<Sense>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as WordStatus,
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      userDefinition: freezed == userDefinition
          ? _value.userDefinition
          : userDefinition // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WordImpl implements _Word {
  const _$WordImpl(
      {@HiveField(0) this.word = "",
      @HiveField(1) this.pos = "",
      @HiveField(2) this.phonetic = "",
      @HiveField(3) this.phoneticText = "",
      @HiveField(4) this.phoneticAm = "",
      @HiveField(5) this.phoneticAmText = "",
      @HiveField(6) final List<Sense> senses = const [],
      @HiveField(7) this.status = WordStatus.unknown,
      @HiveField(8) this.index = 0,
      @HiveField(9) this.userDefinition = null})
      : _senses = senses;

  factory _$WordImpl.fromJson(Map<String, dynamic> json) =>
      _$$WordImplFromJson(json);

  @override
  @JsonKey()
  @HiveField(0)
  final String word;
  @override
  @JsonKey()
  @HiveField(1)
  final String pos;
  @override
  @JsonKey()
  @HiveField(2)
  final String phonetic;
  @override
  @JsonKey()
  @HiveField(3)
  final String phoneticText;
  @override
  @JsonKey()
  @HiveField(4)
  final String phoneticAm;
  @override
  @JsonKey()
  @HiveField(5)
  final String phoneticAmText;
  final List<Sense> _senses;
  @override
  @JsonKey()
  @HiveField(6)
  List<Sense> get senses {
    if (_senses is EqualUnmodifiableListView) return _senses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_senses);
  }

  @override
  @JsonKey()
  @HiveField(7)
  final WordStatus status;
  @override
  @JsonKey()
  @HiveField(8)
  final int index;
  @override
  @JsonKey()
  @HiveField(9)
  final String? userDefinition;

  @override
  String toString() {
    return 'Word(word: $word, pos: $pos, phonetic: $phonetic, phoneticText: $phoneticText, phoneticAm: $phoneticAm, phoneticAmText: $phoneticAmText, senses: $senses, status: $status, index: $index, userDefinition: $userDefinition)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WordImpl &&
            (identical(other.word, word) || other.word == word) &&
            (identical(other.pos, pos) || other.pos == pos) &&
            (identical(other.phonetic, phonetic) ||
                other.phonetic == phonetic) &&
            (identical(other.phoneticText, phoneticText) ||
                other.phoneticText == phoneticText) &&
            (identical(other.phoneticAm, phoneticAm) ||
                other.phoneticAm == phoneticAm) &&
            (identical(other.phoneticAmText, phoneticAmText) ||
                other.phoneticAmText == phoneticAmText) &&
            const DeepCollectionEquality().equals(other._senses, _senses) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.userDefinition, userDefinition) ||
                other.userDefinition == userDefinition));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      word,
      pos,
      phonetic,
      phoneticText,
      phoneticAm,
      phoneticAmText,
      const DeepCollectionEquality().hash(_senses),
      status,
      index,
      userDefinition);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WordImplCopyWith<_$WordImpl> get copyWith =>
      __$$WordImplCopyWithImpl<_$WordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WordImplToJson(
      this,
    );
  }
}

abstract class _Word implements Word {
  const factory _Word(
      {@HiveField(0) final String word,
      @HiveField(1) final String pos,
      @HiveField(2) final String phonetic,
      @HiveField(3) final String phoneticText,
      @HiveField(4) final String phoneticAm,
      @HiveField(5) final String phoneticAmText,
      @HiveField(6) final List<Sense> senses,
      @HiveField(7) final WordStatus status,
      @HiveField(8) final int index,
      @HiveField(9) final String? userDefinition}) = _$WordImpl;

  factory _Word.fromJson(Map<String, dynamic> json) = _$WordImpl.fromJson;

  @override
  @HiveField(0)
  String get word;
  @override
  @HiveField(1)
  String get pos;
  @override
  @HiveField(2)
  String get phonetic;
  @override
  @HiveField(3)
  String get phoneticText;
  @override
  @HiveField(4)
  String get phoneticAm;
  @override
  @HiveField(5)
  String get phoneticAmText;
  @override
  @HiveField(6)
  List<Sense> get senses;
  @override
  @HiveField(7)
  WordStatus get status;
  @override
  @HiveField(8)
  int get index;
  @override
  @HiveField(9)
  String? get userDefinition;
  @override
  @JsonKey(ignore: true)
  _$$WordImplCopyWith<_$WordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
