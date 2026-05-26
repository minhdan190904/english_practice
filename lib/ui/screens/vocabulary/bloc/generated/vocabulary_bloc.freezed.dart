// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../vocabulary_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$VocabularyEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() getAllOxfordWords,
    required TResult Function(Word word, WordStatus status) changeStatus,
    required TResult Function(Word word, String? newDefinition) editDefinition,
    required TResult Function() addWordRandomly,
    required TResult Function(int wordIndex, bool correct) recordSrsReview,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? getAllOxfordWords,
    TResult? Function(Word word, WordStatus status)? changeStatus,
    TResult? Function(Word word, String? newDefinition)? editDefinition,
    TResult? Function()? addWordRandomly,
    TResult? Function(int wordIndex, bool correct)? recordSrsReview,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? getAllOxfordWords,
    TResult Function(Word word, WordStatus status)? changeStatus,
    TResult Function(Word word, String? newDefinition)? editDefinition,
    TResult Function()? addWordRandomly,
    TResult Function(int wordIndex, bool correct)? recordSrsReview,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GetAllOxfordWords value) getAllOxfordWords,
    required TResult Function(_ChangeStatus value) changeStatus,
    required TResult Function(_EditDefinition value) editDefinition,
    required TResult Function(_AddWordRandomly value) addWordRandomly,
    required TResult Function(_RecordSrsReview value) recordSrsReview,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GetAllOxfordWords value)? getAllOxfordWords,
    TResult? Function(_ChangeStatus value)? changeStatus,
    TResult? Function(_EditDefinition value)? editDefinition,
    TResult? Function(_AddWordRandomly value)? addWordRandomly,
    TResult? Function(_RecordSrsReview value)? recordSrsReview,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GetAllOxfordWords value)? getAllOxfordWords,
    TResult Function(_ChangeStatus value)? changeStatus,
    TResult Function(_EditDefinition value)? editDefinition,
    TResult Function(_AddWordRandomly value)? addWordRandomly,
    TResult Function(_RecordSrsReview value)? recordSrsReview,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VocabularyEventCopyWith<$Res> {
  factory $VocabularyEventCopyWith(
          VocabularyEvent value, $Res Function(VocabularyEvent) then) =
      _$VocabularyEventCopyWithImpl<$Res, VocabularyEvent>;
}

/// @nodoc
class _$VocabularyEventCopyWithImpl<$Res, $Val extends VocabularyEvent>
    implements $VocabularyEventCopyWith<$Res> {
  _$VocabularyEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$GetAllOxfordWordsImplCopyWith<$Res> {
  factory _$$GetAllOxfordWordsImplCopyWith(_$GetAllOxfordWordsImpl value,
          $Res Function(_$GetAllOxfordWordsImpl) then) =
      __$$GetAllOxfordWordsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GetAllOxfordWordsImplCopyWithImpl<$Res>
    extends _$VocabularyEventCopyWithImpl<$Res, _$GetAllOxfordWordsImpl>
    implements _$$GetAllOxfordWordsImplCopyWith<$Res> {
  __$$GetAllOxfordWordsImplCopyWithImpl(_$GetAllOxfordWordsImpl _value,
      $Res Function(_$GetAllOxfordWordsImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$GetAllOxfordWordsImpl implements _GetAllOxfordWords {
  const _$GetAllOxfordWordsImpl();

  @override
  String toString() {
    return 'VocabularyEvent.getAllOxfordWords()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$GetAllOxfordWordsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() getAllOxfordWords,
    required TResult Function(Word word, WordStatus status) changeStatus,
    required TResult Function(Word word, String? newDefinition) editDefinition,
    required TResult Function() addWordRandomly,
    required TResult Function(int wordIndex, bool correct) recordSrsReview,
  }) {
    return getAllOxfordWords();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? getAllOxfordWords,
    TResult? Function(Word word, WordStatus status)? changeStatus,
    TResult? Function(Word word, String? newDefinition)? editDefinition,
    TResult? Function()? addWordRandomly,
    TResult? Function(int wordIndex, bool correct)? recordSrsReview,
  }) {
    return getAllOxfordWords?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? getAllOxfordWords,
    TResult Function(Word word, WordStatus status)? changeStatus,
    TResult Function(Word word, String? newDefinition)? editDefinition,
    TResult Function()? addWordRandomly,
    TResult Function(int wordIndex, bool correct)? recordSrsReview,
    required TResult orElse(),
  }) {
    if (getAllOxfordWords != null) {
      return getAllOxfordWords();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GetAllOxfordWords value) getAllOxfordWords,
    required TResult Function(_ChangeStatus value) changeStatus,
    required TResult Function(_EditDefinition value) editDefinition,
    required TResult Function(_AddWordRandomly value) addWordRandomly,
    required TResult Function(_RecordSrsReview value) recordSrsReview,
  }) {
    return getAllOxfordWords(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GetAllOxfordWords value)? getAllOxfordWords,
    TResult? Function(_ChangeStatus value)? changeStatus,
    TResult? Function(_EditDefinition value)? editDefinition,
    TResult? Function(_AddWordRandomly value)? addWordRandomly,
    TResult? Function(_RecordSrsReview value)? recordSrsReview,
  }) {
    return getAllOxfordWords?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GetAllOxfordWords value)? getAllOxfordWords,
    TResult Function(_ChangeStatus value)? changeStatus,
    TResult Function(_EditDefinition value)? editDefinition,
    TResult Function(_AddWordRandomly value)? addWordRandomly,
    TResult Function(_RecordSrsReview value)? recordSrsReview,
    required TResult orElse(),
  }) {
    if (getAllOxfordWords != null) {
      return getAllOxfordWords(this);
    }
    return orElse();
  }
}

abstract class _GetAllOxfordWords implements VocabularyEvent {
  const factory _GetAllOxfordWords() = _$GetAllOxfordWordsImpl;
}

/// @nodoc
abstract class _$$ChangeStatusImplCopyWith<$Res> {
  factory _$$ChangeStatusImplCopyWith(
          _$ChangeStatusImpl value, $Res Function(_$ChangeStatusImpl) then) =
      __$$ChangeStatusImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Word word, WordStatus status});

  $WordCopyWith<$Res> get word;
}

/// @nodoc
class __$$ChangeStatusImplCopyWithImpl<$Res>
    extends _$VocabularyEventCopyWithImpl<$Res, _$ChangeStatusImpl>
    implements _$$ChangeStatusImplCopyWith<$Res> {
  __$$ChangeStatusImplCopyWithImpl(
      _$ChangeStatusImpl _value, $Res Function(_$ChangeStatusImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? word = null,
    Object? status = null,
  }) {
    return _then(_$ChangeStatusImpl(
      null == word
          ? _value.word
          : word // ignore: cast_nullable_to_non_nullable
              as Word,
      null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as WordStatus,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $WordCopyWith<$Res> get word {
    return $WordCopyWith<$Res>(_value.word, (value) {
      return _then(_value.copyWith(word: value));
    });
  }
}

/// @nodoc

class _$ChangeStatusImpl implements _ChangeStatus {
  const _$ChangeStatusImpl(this.word, this.status);

  @override
  final Word word;
  @override
  final WordStatus status;

  @override
  String toString() {
    return 'VocabularyEvent.changeStatus(word: $word, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangeStatusImpl &&
            (identical(other.word, word) || other.word == word) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, word, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangeStatusImplCopyWith<_$ChangeStatusImpl> get copyWith =>
      __$$ChangeStatusImplCopyWithImpl<_$ChangeStatusImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() getAllOxfordWords,
    required TResult Function(Word word, WordStatus status) changeStatus,
    required TResult Function(Word word, String? newDefinition) editDefinition,
    required TResult Function() addWordRandomly,
    required TResult Function(int wordIndex, bool correct) recordSrsReview,
  }) {
    return changeStatus(word, status);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? getAllOxfordWords,
    TResult? Function(Word word, WordStatus status)? changeStatus,
    TResult? Function(Word word, String? newDefinition)? editDefinition,
    TResult? Function()? addWordRandomly,
    TResult? Function(int wordIndex, bool correct)? recordSrsReview,
  }) {
    return changeStatus?.call(word, status);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? getAllOxfordWords,
    TResult Function(Word word, WordStatus status)? changeStatus,
    TResult Function(Word word, String? newDefinition)? editDefinition,
    TResult Function()? addWordRandomly,
    TResult Function(int wordIndex, bool correct)? recordSrsReview,
    required TResult orElse(),
  }) {
    if (changeStatus != null) {
      return changeStatus(word, status);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GetAllOxfordWords value) getAllOxfordWords,
    required TResult Function(_ChangeStatus value) changeStatus,
    required TResult Function(_EditDefinition value) editDefinition,
    required TResult Function(_AddWordRandomly value) addWordRandomly,
    required TResult Function(_RecordSrsReview value) recordSrsReview,
  }) {
    return changeStatus(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GetAllOxfordWords value)? getAllOxfordWords,
    TResult? Function(_ChangeStatus value)? changeStatus,
    TResult? Function(_EditDefinition value)? editDefinition,
    TResult? Function(_AddWordRandomly value)? addWordRandomly,
    TResult? Function(_RecordSrsReview value)? recordSrsReview,
  }) {
    return changeStatus?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GetAllOxfordWords value)? getAllOxfordWords,
    TResult Function(_ChangeStatus value)? changeStatus,
    TResult Function(_EditDefinition value)? editDefinition,
    TResult Function(_AddWordRandomly value)? addWordRandomly,
    TResult Function(_RecordSrsReview value)? recordSrsReview,
    required TResult orElse(),
  }) {
    if (changeStatus != null) {
      return changeStatus(this);
    }
    return orElse();
  }
}

abstract class _ChangeStatus implements VocabularyEvent {
  const factory _ChangeStatus(final Word word, final WordStatus status) =
      _$ChangeStatusImpl;

  Word get word;
  WordStatus get status;
  @JsonKey(ignore: true)
  _$$ChangeStatusImplCopyWith<_$ChangeStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EditDefinitionImplCopyWith<$Res> {
  factory _$$EditDefinitionImplCopyWith(_$EditDefinitionImpl value,
          $Res Function(_$EditDefinitionImpl) then) =
      __$$EditDefinitionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Word word, String? newDefinition});

  $WordCopyWith<$Res> get word;
}

/// @nodoc
class __$$EditDefinitionImplCopyWithImpl<$Res>
    extends _$VocabularyEventCopyWithImpl<$Res, _$EditDefinitionImpl>
    implements _$$EditDefinitionImplCopyWith<$Res> {
  __$$EditDefinitionImplCopyWithImpl(
      _$EditDefinitionImpl _value, $Res Function(_$EditDefinitionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? word = null,
    Object? newDefinition = freezed,
  }) {
    return _then(_$EditDefinitionImpl(
      null == word
          ? _value.word
          : word // ignore: cast_nullable_to_non_nullable
              as Word,
      freezed == newDefinition
          ? _value.newDefinition
          : newDefinition // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $WordCopyWith<$Res> get word {
    return $WordCopyWith<$Res>(_value.word, (value) {
      return _then(_value.copyWith(word: value));
    });
  }
}

/// @nodoc

class _$EditDefinitionImpl implements _EditDefinition {
  const _$EditDefinitionImpl(this.word, this.newDefinition);

  @override
  final Word word;
  @override
  final String? newDefinition;

  @override
  String toString() {
    return 'VocabularyEvent.editDefinition(word: $word, newDefinition: $newDefinition)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EditDefinitionImpl &&
            (identical(other.word, word) || other.word == word) &&
            (identical(other.newDefinition, newDefinition) ||
                other.newDefinition == newDefinition));
  }

  @override
  int get hashCode => Object.hash(runtimeType, word, newDefinition);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EditDefinitionImplCopyWith<_$EditDefinitionImpl> get copyWith =>
      __$$EditDefinitionImplCopyWithImpl<_$EditDefinitionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() getAllOxfordWords,
    required TResult Function(Word word, WordStatus status) changeStatus,
    required TResult Function(Word word, String? newDefinition) editDefinition,
    required TResult Function() addWordRandomly,
    required TResult Function(int wordIndex, bool correct) recordSrsReview,
  }) {
    return editDefinition(word, newDefinition);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? getAllOxfordWords,
    TResult? Function(Word word, WordStatus status)? changeStatus,
    TResult? Function(Word word, String? newDefinition)? editDefinition,
    TResult? Function()? addWordRandomly,
    TResult? Function(int wordIndex, bool correct)? recordSrsReview,
  }) {
    return editDefinition?.call(word, newDefinition);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? getAllOxfordWords,
    TResult Function(Word word, WordStatus status)? changeStatus,
    TResult Function(Word word, String? newDefinition)? editDefinition,
    TResult Function()? addWordRandomly,
    TResult Function(int wordIndex, bool correct)? recordSrsReview,
    required TResult orElse(),
  }) {
    if (editDefinition != null) {
      return editDefinition(word, newDefinition);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GetAllOxfordWords value) getAllOxfordWords,
    required TResult Function(_ChangeStatus value) changeStatus,
    required TResult Function(_EditDefinition value) editDefinition,
    required TResult Function(_AddWordRandomly value) addWordRandomly,
    required TResult Function(_RecordSrsReview value) recordSrsReview,
  }) {
    return editDefinition(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GetAllOxfordWords value)? getAllOxfordWords,
    TResult? Function(_ChangeStatus value)? changeStatus,
    TResult? Function(_EditDefinition value)? editDefinition,
    TResult? Function(_AddWordRandomly value)? addWordRandomly,
    TResult? Function(_RecordSrsReview value)? recordSrsReview,
  }) {
    return editDefinition?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GetAllOxfordWords value)? getAllOxfordWords,
    TResult Function(_ChangeStatus value)? changeStatus,
    TResult Function(_EditDefinition value)? editDefinition,
    TResult Function(_AddWordRandomly value)? addWordRandomly,
    TResult Function(_RecordSrsReview value)? recordSrsReview,
    required TResult orElse(),
  }) {
    if (editDefinition != null) {
      return editDefinition(this);
    }
    return orElse();
  }
}

abstract class _EditDefinition implements VocabularyEvent {
  const factory _EditDefinition(final Word word, final String? newDefinition) =
      _$EditDefinitionImpl;

  Word get word;
  String? get newDefinition;
  @JsonKey(ignore: true)
  _$$EditDefinitionImplCopyWith<_$EditDefinitionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AddWordRandomlyImplCopyWith<$Res> {
  factory _$$AddWordRandomlyImplCopyWith(_$AddWordRandomlyImpl value,
          $Res Function(_$AddWordRandomlyImpl) then) =
      __$$AddWordRandomlyImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AddWordRandomlyImplCopyWithImpl<$Res>
    extends _$VocabularyEventCopyWithImpl<$Res, _$AddWordRandomlyImpl>
    implements _$$AddWordRandomlyImplCopyWith<$Res> {
  __$$AddWordRandomlyImplCopyWithImpl(
      _$AddWordRandomlyImpl _value, $Res Function(_$AddWordRandomlyImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$AddWordRandomlyImpl implements _AddWordRandomly {
  const _$AddWordRandomlyImpl();

  @override
  String toString() {
    return 'VocabularyEvent.addWordRandomly()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AddWordRandomlyImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() getAllOxfordWords,
    required TResult Function(Word word, WordStatus status) changeStatus,
    required TResult Function(Word word, String? newDefinition) editDefinition,
    required TResult Function() addWordRandomly,
    required TResult Function(int wordIndex, bool correct) recordSrsReview,
  }) {
    return addWordRandomly();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? getAllOxfordWords,
    TResult? Function(Word word, WordStatus status)? changeStatus,
    TResult? Function(Word word, String? newDefinition)? editDefinition,
    TResult? Function()? addWordRandomly,
    TResult? Function(int wordIndex, bool correct)? recordSrsReview,
  }) {
    return addWordRandomly?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? getAllOxfordWords,
    TResult Function(Word word, WordStatus status)? changeStatus,
    TResult Function(Word word, String? newDefinition)? editDefinition,
    TResult Function()? addWordRandomly,
    TResult Function(int wordIndex, bool correct)? recordSrsReview,
    required TResult orElse(),
  }) {
    if (addWordRandomly != null) {
      return addWordRandomly();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GetAllOxfordWords value) getAllOxfordWords,
    required TResult Function(_ChangeStatus value) changeStatus,
    required TResult Function(_EditDefinition value) editDefinition,
    required TResult Function(_AddWordRandomly value) addWordRandomly,
    required TResult Function(_RecordSrsReview value) recordSrsReview,
  }) {
    return addWordRandomly(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GetAllOxfordWords value)? getAllOxfordWords,
    TResult? Function(_ChangeStatus value)? changeStatus,
    TResult? Function(_EditDefinition value)? editDefinition,
    TResult? Function(_AddWordRandomly value)? addWordRandomly,
    TResult? Function(_RecordSrsReview value)? recordSrsReview,
  }) {
    return addWordRandomly?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GetAllOxfordWords value)? getAllOxfordWords,
    TResult Function(_ChangeStatus value)? changeStatus,
    TResult Function(_EditDefinition value)? editDefinition,
    TResult Function(_AddWordRandomly value)? addWordRandomly,
    TResult Function(_RecordSrsReview value)? recordSrsReview,
    required TResult orElse(),
  }) {
    if (addWordRandomly != null) {
      return addWordRandomly(this);
    }
    return orElse();
  }
}

abstract class _AddWordRandomly implements VocabularyEvent {
  const factory _AddWordRandomly() = _$AddWordRandomlyImpl;
}

/// @nodoc
abstract class _$$RecordSrsReviewImplCopyWith<$Res> {
  factory _$$RecordSrsReviewImplCopyWith(_$RecordSrsReviewImpl value,
          $Res Function(_$RecordSrsReviewImpl) then) =
      __$$RecordSrsReviewImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int wordIndex, bool correct});
}

/// @nodoc
class __$$RecordSrsReviewImplCopyWithImpl<$Res>
    extends _$VocabularyEventCopyWithImpl<$Res, _$RecordSrsReviewImpl>
    implements _$$RecordSrsReviewImplCopyWith<$Res> {
  __$$RecordSrsReviewImplCopyWithImpl(
      _$RecordSrsReviewImpl _value, $Res Function(_$RecordSrsReviewImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wordIndex = null,
    Object? correct = null,
  }) {
    return _then(_$RecordSrsReviewImpl(
      wordIndex: null == wordIndex
          ? _value.wordIndex
          : wordIndex // ignore: cast_nullable_to_non_nullable
              as int,
      correct: null == correct
          ? _value.correct
          : correct // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$RecordSrsReviewImpl implements _RecordSrsReview {
  const _$RecordSrsReviewImpl(
      {required this.wordIndex, required this.correct});

  @override
  final int wordIndex;
  @override
  final bool correct;

  @override
  String toString() {
    return 'VocabularyEvent.recordSrsReview(wordIndex: $wordIndex, correct: $correct)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordSrsReviewImpl &&
            (identical(other.wordIndex, wordIndex) ||
                other.wordIndex == wordIndex) &&
            (identical(other.correct, correct) || other.correct == correct));
  }

  @override
  int get hashCode => Object.hash(runtimeType, wordIndex, correct);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordSrsReviewImplCopyWith<_$RecordSrsReviewImpl> get copyWith =>
      __$$RecordSrsReviewImplCopyWithImpl<_$RecordSrsReviewImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() getAllOxfordWords,
    required TResult Function(Word word, WordStatus status) changeStatus,
    required TResult Function(Word word, String? newDefinition) editDefinition,
    required TResult Function() addWordRandomly,
    required TResult Function(int wordIndex, bool correct) recordSrsReview,
  }) {
    return recordSrsReview(wordIndex, correct);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? getAllOxfordWords,
    TResult? Function(Word word, WordStatus status)? changeStatus,
    TResult? Function(Word word, String? newDefinition)? editDefinition,
    TResult? Function()? addWordRandomly,
    TResult? Function(int wordIndex, bool correct)? recordSrsReview,
  }) {
    return recordSrsReview?.call(wordIndex, correct);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? getAllOxfordWords,
    TResult Function(Word word, WordStatus status)? changeStatus,
    TResult Function(Word word, String? newDefinition)? editDefinition,
    TResult Function()? addWordRandomly,
    TResult Function(int wordIndex, bool correct)? recordSrsReview,
    required TResult orElse(),
  }) {
    if (recordSrsReview != null) {
      return recordSrsReview(wordIndex, correct);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GetAllOxfordWords value) getAllOxfordWords,
    required TResult Function(_ChangeStatus value) changeStatus,
    required TResult Function(_EditDefinition value) editDefinition,
    required TResult Function(_AddWordRandomly value) addWordRandomly,
    required TResult Function(_RecordSrsReview value) recordSrsReview,
  }) {
    return recordSrsReview(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GetAllOxfordWords value)? getAllOxfordWords,
    TResult? Function(_ChangeStatus value)? changeStatus,
    TResult? Function(_EditDefinition value)? editDefinition,
    TResult? Function(_AddWordRandomly value)? addWordRandomly,
    TResult? Function(_RecordSrsReview value)? recordSrsReview,
  }) {
    return recordSrsReview?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GetAllOxfordWords value)? getAllOxfordWords,
    TResult Function(_ChangeStatus value)? changeStatus,
    TResult Function(_EditDefinition value)? editDefinition,
    TResult Function(_AddWordRandomly value)? addWordRandomly,
    TResult Function(_RecordSrsReview value)? recordSrsReview,
    required TResult orElse(),
  }) {
    if (recordSrsReview != null) {
      return recordSrsReview(this);
    }
    return orElse();
  }
}

abstract class _RecordSrsReview implements VocabularyEvent {
  const factory _RecordSrsReview(
      {required final int wordIndex,
      required final bool correct}) = _$RecordSrsReviewImpl;

  int get wordIndex;
  bool get correct;
  @JsonKey(ignore: true)
  _$$RecordSrsReviewImplCopyWith<_$RecordSrsReviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$VocabularyState {
  List<Word> get words => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $VocabularyStateCopyWith<VocabularyState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VocabularyStateCopyWith<$Res> {
  factory $VocabularyStateCopyWith(
          VocabularyState value, $Res Function(VocabularyState) then) =
      _$VocabularyStateCopyWithImpl<$Res, VocabularyState>;
  @useResult
  $Res call({List<Word> words});
}

/// @nodoc
class _$VocabularyStateCopyWithImpl<$Res, $Val extends VocabularyState>
    implements $VocabularyStateCopyWith<$Res> {
  _$VocabularyStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? words = null,
  }) {
    return _then(_value.copyWith(
      words: null == words
          ? _value.words
          : words // ignore: cast_nullable_to_non_nullable
              as List<Word>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VocabularyStateImplCopyWith<$Res>
    implements $VocabularyStateCopyWith<$Res> {
  factory _$$VocabularyStateImplCopyWith(_$VocabularyStateImpl value,
          $Res Function(_$VocabularyStateImpl) then) =
      __$$VocabularyStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Word> words});
}

/// @nodoc
class __$$VocabularyStateImplCopyWithImpl<$Res>
    extends _$VocabularyStateCopyWithImpl<$Res, _$VocabularyStateImpl>
    implements _$$VocabularyStateImplCopyWith<$Res> {
  __$$VocabularyStateImplCopyWithImpl(
      _$VocabularyStateImpl _value, $Res Function(_$VocabularyStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? words = null,
  }) {
    return _then(_$VocabularyStateImpl(
      words: null == words
          ? _value._words
          : words // ignore: cast_nullable_to_non_nullable
              as List<Word>,
    ));
  }
}

/// @nodoc

class _$VocabularyStateImpl implements _VocabularyState {
  const _$VocabularyStateImpl({final List<Word> words = const []})
      : _words = words;

  final List<Word> _words;
  @override
  @JsonKey()
  List<Word> get words {
    if (_words is EqualUnmodifiableListView) return _words;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_words);
  }

  @override
  String toString() {
    return 'VocabularyState(words: $words)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VocabularyStateImpl &&
            const DeepCollectionEquality().equals(other._words, _words));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_words));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VocabularyStateImplCopyWith<_$VocabularyStateImpl> get copyWith =>
      __$$VocabularyStateImplCopyWithImpl<_$VocabularyStateImpl>(
          this, _$identity);
}

abstract class _VocabularyState implements VocabularyState {
  const factory _VocabularyState({final List<Word> words}) =
      _$VocabularyStateImpl;

  @override
  List<Word> get words;
  @override
  @JsonKey(ignore: true)
  _$$VocabularyStateImplCopyWith<_$VocabularyStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
