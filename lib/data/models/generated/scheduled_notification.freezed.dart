// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../scheduled_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ScheduledNotification _$ScheduledNotificationFromJson(
    Map<String, dynamic> json) {
  return _ScheduledNotification.fromJson(json);
}

/// @nodoc
mixin _$ScheduledNotification {
  @HiveField(0)
  int get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get title => throw _privateConstructorUsedError;
  @HiveField(2)
  String get body => throw _privateConstructorUsedError;
  @HiveField(3)
  String get scheduledDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ScheduledNotificationCopyWith<ScheduledNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduledNotificationCopyWith<$Res> {
  factory $ScheduledNotificationCopyWith(ScheduledNotification value,
          $Res Function(ScheduledNotification) then) =
      _$ScheduledNotificationCopyWithImpl<$Res, ScheduledNotification>;
  @useResult
  $Res call(
      {@HiveField(0) int id,
      @HiveField(1) String title,
      @HiveField(2) String body,
      @HiveField(3) String scheduledDate});
}

/// @nodoc
class _$ScheduledNotificationCopyWithImpl<$Res,
        $Val extends ScheduledNotification>
    implements $ScheduledNotificationCopyWith<$Res> {
  _$ScheduledNotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? scheduledDate = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledDate: null == scheduledDate
          ? _value.scheduledDate
          : scheduledDate // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScheduledNotificationImplCopyWith<$Res>
    implements $ScheduledNotificationCopyWith<$Res> {
  factory _$$ScheduledNotificationImplCopyWith(
          _$ScheduledNotificationImpl value,
          $Res Function(_$ScheduledNotificationImpl) then) =
      __$$ScheduledNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) int id,
      @HiveField(1) String title,
      @HiveField(2) String body,
      @HiveField(3) String scheduledDate});
}

/// @nodoc
class __$$ScheduledNotificationImplCopyWithImpl<$Res>
    extends _$ScheduledNotificationCopyWithImpl<$Res,
        _$ScheduledNotificationImpl>
    implements _$$ScheduledNotificationImplCopyWith<$Res> {
  __$$ScheduledNotificationImplCopyWithImpl(_$ScheduledNotificationImpl _value,
      $Res Function(_$ScheduledNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? scheduledDate = null,
  }) {
    return _then(_$ScheduledNotificationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledDate: null == scheduledDate
          ? _value.scheduledDate
          : scheduledDate // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScheduledNotificationImpl implements _ScheduledNotification {
  const _$ScheduledNotificationImpl(
      {@HiveField(0) this.id = 0,
      @HiveField(1) this.title = "",
      @HiveField(2) this.body = "",
      @HiveField(3) this.scheduledDate = ""});

  factory _$ScheduledNotificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScheduledNotificationImplFromJson(json);

  @override
  @JsonKey()
  @HiveField(0)
  final int id;
  @override
  @JsonKey()
  @HiveField(1)
  final String title;
  @override
  @JsonKey()
  @HiveField(2)
  final String body;
  @override
  @JsonKey()
  @HiveField(3)
  final String scheduledDate;

  @override
  String toString() {
    return 'ScheduledNotification(id: $id, title: $title, body: $body, scheduledDate: $scheduledDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduledNotificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.scheduledDate, scheduledDate) ||
                other.scheduledDate == scheduledDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, body, scheduledDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduledNotificationImplCopyWith<_$ScheduledNotificationImpl>
      get copyWith => __$$ScheduledNotificationImplCopyWithImpl<
          _$ScheduledNotificationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScheduledNotificationImplToJson(
      this,
    );
  }
}

abstract class _ScheduledNotification implements ScheduledNotification {
  const factory _ScheduledNotification(
      {@HiveField(0) final int id,
      @HiveField(1) final String title,
      @HiveField(2) final String body,
      @HiveField(3) final String scheduledDate}) = _$ScheduledNotificationImpl;

  factory _ScheduledNotification.fromJson(Map<String, dynamic> json) =
      _$ScheduledNotificationImpl.fromJson;

  @override
  @HiveField(0)
  int get id;
  @override
  @HiveField(1)
  String get title;
  @override
  @HiveField(2)
  String get body;
  @override
  @HiveField(3)
  String get scheduledDate;
  @override
  @JsonKey(ignore: true)
  _$$ScheduledNotificationImplCopyWith<_$ScheduledNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}
