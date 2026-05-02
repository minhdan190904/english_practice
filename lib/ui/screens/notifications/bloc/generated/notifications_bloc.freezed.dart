// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../notifications_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NotificationsEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() requestPermissions,
    required TResult Function() handleOpenAppFromNotification,
    required TResult Function() clearWordIdFromNotification,
    required TResult Function() scheduleNextDayReminder,
    required TResult Function(
            List<Word> words, DateTime scheduledTime, Duration interval)
        scheduleWordsReminder,
    required TResult Function(Word word) reminderWordTomorrow,
    required TResult Function() getScheduledNotifications,
    required TResult Function(int id) removeScheduledNotifications,
    required TResult Function(NotificationsState state) emitState,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? requestPermissions,
    TResult? Function()? handleOpenAppFromNotification,
    TResult? Function()? clearWordIdFromNotification,
    TResult? Function()? scheduleNextDayReminder,
    TResult? Function(
            List<Word> words, DateTime scheduledTime, Duration interval)?
        scheduleWordsReminder,
    TResult? Function(Word word)? reminderWordTomorrow,
    TResult? Function()? getScheduledNotifications,
    TResult? Function(int id)? removeScheduledNotifications,
    TResult? Function(NotificationsState state)? emitState,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? requestPermissions,
    TResult Function()? handleOpenAppFromNotification,
    TResult Function()? clearWordIdFromNotification,
    TResult Function()? scheduleNextDayReminder,
    TResult Function(
            List<Word> words, DateTime scheduledTime, Duration interval)?
        scheduleWordsReminder,
    TResult Function(Word word)? reminderWordTomorrow,
    TResult Function()? getScheduledNotifications,
    TResult Function(int id)? removeScheduledNotifications,
    TResult Function(NotificationsState state)? emitState,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_RequestPermissions value) requestPermissions,
    required TResult Function(_HandleOpenAppFromNotification value)
        handleOpenAppFromNotification,
    required TResult Function(_ClearWordIdFromNotification value)
        clearWordIdFromNotification,
    required TResult Function(_ScheduleNextDayReminder value)
        scheduleNextDayReminder,
    required TResult Function(_ScheduleWordReminder value)
        scheduleWordsReminder,
    required TResult Function(_ReminderWordTomorrow value) reminderWordTomorrow,
    required TResult Function(_GetScheduledNotifications value)
        getScheduledNotifications,
    required TResult Function(_RemoveScheduledNotifications value)
        removeScheduledNotifications,
    required TResult Function(_EmitState value) emitState,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_RequestPermissions value)? requestPermissions,
    TResult? Function(_HandleOpenAppFromNotification value)?
        handleOpenAppFromNotification,
    TResult? Function(_ClearWordIdFromNotification value)?
        clearWordIdFromNotification,
    TResult? Function(_ScheduleNextDayReminder value)? scheduleNextDayReminder,
    TResult? Function(_ScheduleWordReminder value)? scheduleWordsReminder,
    TResult? Function(_ReminderWordTomorrow value)? reminderWordTomorrow,
    TResult? Function(_GetScheduledNotifications value)?
        getScheduledNotifications,
    TResult? Function(_RemoveScheduledNotifications value)?
        removeScheduledNotifications,
    TResult? Function(_EmitState value)? emitState,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RequestPermissions value)? requestPermissions,
    TResult Function(_HandleOpenAppFromNotification value)?
        handleOpenAppFromNotification,
    TResult Function(_ClearWordIdFromNotification value)?
        clearWordIdFromNotification,
    TResult Function(_ScheduleNextDayReminder value)? scheduleNextDayReminder,
    TResult Function(_ScheduleWordReminder value)? scheduleWordsReminder,
    TResult Function(_ReminderWordTomorrow value)? reminderWordTomorrow,
    TResult Function(_GetScheduledNotifications value)?
        getScheduledNotifications,
    TResult Function(_RemoveScheduledNotifications value)?
        removeScheduledNotifications,
    TResult Function(_EmitState value)? emitState,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationsEventCopyWith<$Res> {
  factory $NotificationsEventCopyWith(
          NotificationsEvent value, $Res Function(NotificationsEvent) then) =
      _$NotificationsEventCopyWithImpl<$Res, NotificationsEvent>;
}

/// @nodoc
class _$NotificationsEventCopyWithImpl<$Res, $Val extends NotificationsEvent>
    implements $NotificationsEventCopyWith<$Res> {
  _$NotificationsEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$RequestPermissionsImplCopyWith<$Res> {
  factory _$$RequestPermissionsImplCopyWith(_$RequestPermissionsImpl value,
          $Res Function(_$RequestPermissionsImpl) then) =
      __$$RequestPermissionsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RequestPermissionsImplCopyWithImpl<$Res>
    extends _$NotificationsEventCopyWithImpl<$Res, _$RequestPermissionsImpl>
    implements _$$RequestPermissionsImplCopyWith<$Res> {
  __$$RequestPermissionsImplCopyWithImpl(_$RequestPermissionsImpl _value,
      $Res Function(_$RequestPermissionsImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$RequestPermissionsImpl
    with DiagnosticableTreeMixin
    implements _RequestPermissions {
  const _$RequestPermissionsImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NotificationsEvent.requestPermissions()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty('type', 'NotificationsEvent.requestPermissions'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$RequestPermissionsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() requestPermissions,
    required TResult Function() handleOpenAppFromNotification,
    required TResult Function() clearWordIdFromNotification,
    required TResult Function() scheduleNextDayReminder,
    required TResult Function(
            List<Word> words, DateTime scheduledTime, Duration interval)
        scheduleWordsReminder,
    required TResult Function(Word word) reminderWordTomorrow,
    required TResult Function() getScheduledNotifications,
    required TResult Function(int id) removeScheduledNotifications,
    required TResult Function(NotificationsState state) emitState,
  }) {
    return requestPermissions();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? requestPermissions,
    TResult? Function()? handleOpenAppFromNotification,
    TResult? Function()? clearWordIdFromNotification,
    TResult? Function()? scheduleNextDayReminder,
    TResult? Function(
            List<Word> words, DateTime scheduledTime, Duration interval)?
        scheduleWordsReminder,
    TResult? Function(Word word)? reminderWordTomorrow,
    TResult? Function()? getScheduledNotifications,
    TResult? Function(int id)? removeScheduledNotifications,
    TResult? Function(NotificationsState state)? emitState,
  }) {
    return requestPermissions?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? requestPermissions,
    TResult Function()? handleOpenAppFromNotification,
    TResult Function()? clearWordIdFromNotification,
    TResult Function()? scheduleNextDayReminder,
    TResult Function(
            List<Word> words, DateTime scheduledTime, Duration interval)?
        scheduleWordsReminder,
    TResult Function(Word word)? reminderWordTomorrow,
    TResult Function()? getScheduledNotifications,
    TResult Function(int id)? removeScheduledNotifications,
    TResult Function(NotificationsState state)? emitState,
    required TResult orElse(),
  }) {
    if (requestPermissions != null) {
      return requestPermissions();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_RequestPermissions value) requestPermissions,
    required TResult Function(_HandleOpenAppFromNotification value)
        handleOpenAppFromNotification,
    required TResult Function(_ClearWordIdFromNotification value)
        clearWordIdFromNotification,
    required TResult Function(_ScheduleNextDayReminder value)
        scheduleNextDayReminder,
    required TResult Function(_ScheduleWordReminder value)
        scheduleWordsReminder,
    required TResult Function(_ReminderWordTomorrow value) reminderWordTomorrow,
    required TResult Function(_GetScheduledNotifications value)
        getScheduledNotifications,
    required TResult Function(_RemoveScheduledNotifications value)
        removeScheduledNotifications,
    required TResult Function(_EmitState value) emitState,
  }) {
    return requestPermissions(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_RequestPermissions value)? requestPermissions,
    TResult? Function(_HandleOpenAppFromNotification value)?
        handleOpenAppFromNotification,
    TResult? Function(_ClearWordIdFromNotification value)?
        clearWordIdFromNotification,
    TResult? Function(_ScheduleNextDayReminder value)? scheduleNextDayReminder,
    TResult? Function(_ScheduleWordReminder value)? scheduleWordsReminder,
    TResult? Function(_ReminderWordTomorrow value)? reminderWordTomorrow,
    TResult? Function(_GetScheduledNotifications value)?
        getScheduledNotifications,
    TResult? Function(_RemoveScheduledNotifications value)?
        removeScheduledNotifications,
    TResult? Function(_EmitState value)? emitState,
  }) {
    return requestPermissions?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RequestPermissions value)? requestPermissions,
    TResult Function(_HandleOpenAppFromNotification value)?
        handleOpenAppFromNotification,
    TResult Function(_ClearWordIdFromNotification value)?
        clearWordIdFromNotification,
    TResult Function(_ScheduleNextDayReminder value)? scheduleNextDayReminder,
    TResult Function(_ScheduleWordReminder value)? scheduleWordsReminder,
    TResult Function(_ReminderWordTomorrow value)? reminderWordTomorrow,
    TResult Function(_GetScheduledNotifications value)?
        getScheduledNotifications,
    TResult Function(_RemoveScheduledNotifications value)?
        removeScheduledNotifications,
    TResult Function(_EmitState value)? emitState,
    required TResult orElse(),
  }) {
    if (requestPermissions != null) {
      return requestPermissions(this);
    }
    return orElse();
  }
}

abstract class _RequestPermissions implements NotificationsEvent {
  const factory _RequestPermissions() = _$RequestPermissionsImpl;
}

/// @nodoc
abstract class _$$HandleOpenAppFromNotificationImplCopyWith<$Res> {
  factory _$$HandleOpenAppFromNotificationImplCopyWith(
          _$HandleOpenAppFromNotificationImpl value,
          $Res Function(_$HandleOpenAppFromNotificationImpl) then) =
      __$$HandleOpenAppFromNotificationImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$HandleOpenAppFromNotificationImplCopyWithImpl<$Res>
    extends _$NotificationsEventCopyWithImpl<$Res,
        _$HandleOpenAppFromNotificationImpl>
    implements _$$HandleOpenAppFromNotificationImplCopyWith<$Res> {
  __$$HandleOpenAppFromNotificationImplCopyWithImpl(
      _$HandleOpenAppFromNotificationImpl _value,
      $Res Function(_$HandleOpenAppFromNotificationImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$HandleOpenAppFromNotificationImpl
    with DiagnosticableTreeMixin
    implements _HandleOpenAppFromNotification {
  const _$HandleOpenAppFromNotificationImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NotificationsEvent.handleOpenAppFromNotification()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty(
        'type', 'NotificationsEvent.handleOpenAppFromNotification'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HandleOpenAppFromNotificationImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() requestPermissions,
    required TResult Function() handleOpenAppFromNotification,
    required TResult Function() clearWordIdFromNotification,
    required TResult Function() scheduleNextDayReminder,
    required TResult Function(
            List<Word> words, DateTime scheduledTime, Duration interval)
        scheduleWordsReminder,
    required TResult Function(Word word) reminderWordTomorrow,
    required TResult Function() getScheduledNotifications,
    required TResult Function(int id) removeScheduledNotifications,
    required TResult Function(NotificationsState state) emitState,
  }) {
    return handleOpenAppFromNotification();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? requestPermissions,
    TResult? Function()? handleOpenAppFromNotification,
    TResult? Function()? clearWordIdFromNotification,
    TResult? Function()? scheduleNextDayReminder,
    TResult? Function(
            List<Word> words, DateTime scheduledTime, Duration interval)?
        scheduleWordsReminder,
    TResult? Function(Word word)? reminderWordTomorrow,
    TResult? Function()? getScheduledNotifications,
    TResult? Function(int id)? removeScheduledNotifications,
    TResult? Function(NotificationsState state)? emitState,
  }) {
    return handleOpenAppFromNotification?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? requestPermissions,
    TResult Function()? handleOpenAppFromNotification,
    TResult Function()? clearWordIdFromNotification,
    TResult Function()? scheduleNextDayReminder,
    TResult Function(
            List<Word> words, DateTime scheduledTime, Duration interval)?
        scheduleWordsReminder,
    TResult Function(Word word)? reminderWordTomorrow,
    TResult Function()? getScheduledNotifications,
    TResult Function(int id)? removeScheduledNotifications,
    TResult Function(NotificationsState state)? emitState,
    required TResult orElse(),
  }) {
    if (handleOpenAppFromNotification != null) {
      return handleOpenAppFromNotification();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_RequestPermissions value) requestPermissions,
    required TResult Function(_HandleOpenAppFromNotification value)
        handleOpenAppFromNotification,
    required TResult Function(_ClearWordIdFromNotification value)
        clearWordIdFromNotification,
    required TResult Function(_ScheduleNextDayReminder value)
        scheduleNextDayReminder,
    required TResult Function(_ScheduleWordReminder value)
        scheduleWordsReminder,
    required TResult Function(_ReminderWordTomorrow value) reminderWordTomorrow,
    required TResult Function(_GetScheduledNotifications value)
        getScheduledNotifications,
    required TResult Function(_RemoveScheduledNotifications value)
        removeScheduledNotifications,
    required TResult Function(_EmitState value) emitState,
  }) {
    return handleOpenAppFromNotification(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_RequestPermissions value)? requestPermissions,
    TResult? Function(_HandleOpenAppFromNotification value)?
        handleOpenAppFromNotification,
    TResult? Function(_ClearWordIdFromNotification value)?
        clearWordIdFromNotification,
    TResult? Function(_ScheduleNextDayReminder value)? scheduleNextDayReminder,
    TResult? Function(_ScheduleWordReminder value)? scheduleWordsReminder,
    TResult? Function(_ReminderWordTomorrow value)? reminderWordTomorrow,
    TResult? Function(_GetScheduledNotifications value)?
        getScheduledNotifications,
    TResult? Function(_RemoveScheduledNotifications value)?
        removeScheduledNotifications,
    TResult? Function(_EmitState value)? emitState,
  }) {
    return handleOpenAppFromNotification?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RequestPermissions value)? requestPermissions,
    TResult Function(_HandleOpenAppFromNotification value)?
        handleOpenAppFromNotification,
    TResult Function(_ClearWordIdFromNotification value)?
        clearWordIdFromNotification,
    TResult Function(_ScheduleNextDayReminder value)? scheduleNextDayReminder,
    TResult Function(_ScheduleWordReminder value)? scheduleWordsReminder,
    TResult Function(_ReminderWordTomorrow value)? reminderWordTomorrow,
    TResult Function(_GetScheduledNotifications value)?
        getScheduledNotifications,
    TResult Function(_RemoveScheduledNotifications value)?
        removeScheduledNotifications,
    TResult Function(_EmitState value)? emitState,
    required TResult orElse(),
  }) {
    if (handleOpenAppFromNotification != null) {
      return handleOpenAppFromNotification(this);
    }
    return orElse();
  }
}

abstract class _HandleOpenAppFromNotification implements NotificationsEvent {
  const factory _HandleOpenAppFromNotification() =
      _$HandleOpenAppFromNotificationImpl;
}

/// @nodoc
abstract class _$$ClearWordIdFromNotificationImplCopyWith<$Res> {
  factory _$$ClearWordIdFromNotificationImplCopyWith(
          _$ClearWordIdFromNotificationImpl value,
          $Res Function(_$ClearWordIdFromNotificationImpl) then) =
      __$$ClearWordIdFromNotificationImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ClearWordIdFromNotificationImplCopyWithImpl<$Res>
    extends _$NotificationsEventCopyWithImpl<$Res,
        _$ClearWordIdFromNotificationImpl>
    implements _$$ClearWordIdFromNotificationImplCopyWith<$Res> {
  __$$ClearWordIdFromNotificationImplCopyWithImpl(
      _$ClearWordIdFromNotificationImpl _value,
      $Res Function(_$ClearWordIdFromNotificationImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ClearWordIdFromNotificationImpl
    with DiagnosticableTreeMixin
    implements _ClearWordIdFromNotification {
  const _$ClearWordIdFromNotificationImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NotificationsEvent.clearWordIdFromNotification()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty(
        'type', 'NotificationsEvent.clearWordIdFromNotification'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClearWordIdFromNotificationImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() requestPermissions,
    required TResult Function() handleOpenAppFromNotification,
    required TResult Function() clearWordIdFromNotification,
    required TResult Function() scheduleNextDayReminder,
    required TResult Function(
            List<Word> words, DateTime scheduledTime, Duration interval)
        scheduleWordsReminder,
    required TResult Function(Word word) reminderWordTomorrow,
    required TResult Function() getScheduledNotifications,
    required TResult Function(int id) removeScheduledNotifications,
    required TResult Function(NotificationsState state) emitState,
  }) {
    return clearWordIdFromNotification();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? requestPermissions,
    TResult? Function()? handleOpenAppFromNotification,
    TResult? Function()? clearWordIdFromNotification,
    TResult? Function()? scheduleNextDayReminder,
    TResult? Function(
            List<Word> words, DateTime scheduledTime, Duration interval)?
        scheduleWordsReminder,
    TResult? Function(Word word)? reminderWordTomorrow,
    TResult? Function()? getScheduledNotifications,
    TResult? Function(int id)? removeScheduledNotifications,
    TResult? Function(NotificationsState state)? emitState,
  }) {
    return clearWordIdFromNotification?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? requestPermissions,
    TResult Function()? handleOpenAppFromNotification,
    TResult Function()? clearWordIdFromNotification,
    TResult Function()? scheduleNextDayReminder,
    TResult Function(
            List<Word> words, DateTime scheduledTime, Duration interval)?
        scheduleWordsReminder,
    TResult Function(Word word)? reminderWordTomorrow,
    TResult Function()? getScheduledNotifications,
    TResult Function(int id)? removeScheduledNotifications,
    TResult Function(NotificationsState state)? emitState,
    required TResult orElse(),
  }) {
    if (clearWordIdFromNotification != null) {
      return clearWordIdFromNotification();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_RequestPermissions value) requestPermissions,
    required TResult Function(_HandleOpenAppFromNotification value)
        handleOpenAppFromNotification,
    required TResult Function(_ClearWordIdFromNotification value)
        clearWordIdFromNotification,
    required TResult Function(_ScheduleNextDayReminder value)
        scheduleNextDayReminder,
    required TResult Function(_ScheduleWordReminder value)
        scheduleWordsReminder,
    required TResult Function(_ReminderWordTomorrow value) reminderWordTomorrow,
    required TResult Function(_GetScheduledNotifications value)
        getScheduledNotifications,
    required TResult Function(_RemoveScheduledNotifications value)
        removeScheduledNotifications,
    required TResult Function(_EmitState value) emitState,
  }) {
    return clearWordIdFromNotification(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_RequestPermissions value)? requestPermissions,
    TResult? Function(_HandleOpenAppFromNotification value)?
        handleOpenAppFromNotification,
    TResult? Function(_ClearWordIdFromNotification value)?
        clearWordIdFromNotification,
    TResult? Function(_ScheduleNextDayReminder value)? scheduleNextDayReminder,
    TResult? Function(_ScheduleWordReminder value)? scheduleWordsReminder,
    TResult? Function(_ReminderWordTomorrow value)? reminderWordTomorrow,
    TResult? Function(_GetScheduledNotifications value)?
        getScheduledNotifications,
    TResult? Function(_RemoveScheduledNotifications value)?
        removeScheduledNotifications,
    TResult? Function(_EmitState value)? emitState,
  }) {
    return clearWordIdFromNotification?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RequestPermissions value)? requestPermissions,
    TResult Function(_HandleOpenAppFromNotification value)?
        handleOpenAppFromNotification,
    TResult Function(_ClearWordIdFromNotification value)?
        clearWordIdFromNotification,
    TResult Function(_ScheduleNextDayReminder value)? scheduleNextDayReminder,
    TResult Function(_ScheduleWordReminder value)? scheduleWordsReminder,
    TResult Function(_ReminderWordTomorrow value)? reminderWordTomorrow,
    TResult Function(_GetScheduledNotifications value)?
        getScheduledNotifications,
    TResult Function(_RemoveScheduledNotifications value)?
        removeScheduledNotifications,
    TResult Function(_EmitState value)? emitState,
    required TResult orElse(),
  }) {
    if (clearWordIdFromNotification != null) {
      return clearWordIdFromNotification(this);
    }
    return orElse();
  }
}

abstract class _ClearWordIdFromNotification implements NotificationsEvent {
  const factory _ClearWordIdFromNotification() =
      _$ClearWordIdFromNotificationImpl;
}

/// @nodoc
abstract class _$$ScheduleNextDayReminderImplCopyWith<$Res> {
  factory _$$ScheduleNextDayReminderImplCopyWith(
          _$ScheduleNextDayReminderImpl value,
          $Res Function(_$ScheduleNextDayReminderImpl) then) =
      __$$ScheduleNextDayReminderImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ScheduleNextDayReminderImplCopyWithImpl<$Res>
    extends _$NotificationsEventCopyWithImpl<$Res,
        _$ScheduleNextDayReminderImpl>
    implements _$$ScheduleNextDayReminderImplCopyWith<$Res> {
  __$$ScheduleNextDayReminderImplCopyWithImpl(
      _$ScheduleNextDayReminderImpl _value,
      $Res Function(_$ScheduleNextDayReminderImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ScheduleNextDayReminderImpl
    with DiagnosticableTreeMixin
    implements _ScheduleNextDayReminder {
  const _$ScheduleNextDayReminderImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NotificationsEvent.scheduleNextDayReminder()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty(
        'type', 'NotificationsEvent.scheduleNextDayReminder'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleNextDayReminderImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() requestPermissions,
    required TResult Function() handleOpenAppFromNotification,
    required TResult Function() clearWordIdFromNotification,
    required TResult Function() scheduleNextDayReminder,
    required TResult Function(
            List<Word> words, DateTime scheduledTime, Duration interval)
        scheduleWordsReminder,
    required TResult Function(Word word) reminderWordTomorrow,
    required TResult Function() getScheduledNotifications,
    required TResult Function(int id) removeScheduledNotifications,
    required TResult Function(NotificationsState state) emitState,
  }) {
    return scheduleNextDayReminder();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? requestPermissions,
    TResult? Function()? handleOpenAppFromNotification,
    TResult? Function()? clearWordIdFromNotification,
    TResult? Function()? scheduleNextDayReminder,
    TResult? Function(
            List<Word> words, DateTime scheduledTime, Duration interval)?
        scheduleWordsReminder,
    TResult? Function(Word word)? reminderWordTomorrow,
    TResult? Function()? getScheduledNotifications,
    TResult? Function(int id)? removeScheduledNotifications,
    TResult? Function(NotificationsState state)? emitState,
  }) {
    return scheduleNextDayReminder?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? requestPermissions,
    TResult Function()? handleOpenAppFromNotification,
    TResult Function()? clearWordIdFromNotification,
    TResult Function()? scheduleNextDayReminder,
    TResult Function(
            List<Word> words, DateTime scheduledTime, Duration interval)?
        scheduleWordsReminder,
    TResult Function(Word word)? reminderWordTomorrow,
    TResult Function()? getScheduledNotifications,
    TResult Function(int id)? removeScheduledNotifications,
    TResult Function(NotificationsState state)? emitState,
    required TResult orElse(),
  }) {
    if (scheduleNextDayReminder != null) {
      return scheduleNextDayReminder();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_RequestPermissions value) requestPermissions,
    required TResult Function(_HandleOpenAppFromNotification value)
        handleOpenAppFromNotification,
    required TResult Function(_ClearWordIdFromNotification value)
        clearWordIdFromNotification,
    required TResult Function(_ScheduleNextDayReminder value)
        scheduleNextDayReminder,
    required TResult Function(_ScheduleWordReminder value)
        scheduleWordsReminder,
    required TResult Function(_ReminderWordTomorrow value) reminderWordTomorrow,
    required TResult Function(_GetScheduledNotifications value)
        getScheduledNotifications,
    required TResult Function(_RemoveScheduledNotifications value)
        removeScheduledNotifications,
    required TResult Function(_EmitState value) emitState,
  }) {
    return scheduleNextDayReminder(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_RequestPermissions value)? requestPermissions,
    TResult? Function(_HandleOpenAppFromNotification value)?
        handleOpenAppFromNotification,
    TResult? Function(_ClearWordIdFromNotification value)?
        clearWordIdFromNotification,
    TResult? Function(_ScheduleNextDayReminder value)? scheduleNextDayReminder,
    TResult? Function(_ScheduleWordReminder value)? scheduleWordsReminder,
    TResult? Function(_ReminderWordTomorrow value)? reminderWordTomorrow,
    TResult? Function(_GetScheduledNotifications value)?
        getScheduledNotifications,
    TResult? Function(_RemoveScheduledNotifications value)?
        removeScheduledNotifications,
    TResult? Function(_EmitState value)? emitState,
  }) {
    return scheduleNextDayReminder?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RequestPermissions value)? requestPermissions,
    TResult Function(_HandleOpenAppFromNotification value)?
        handleOpenAppFromNotification,
    TResult Function(_ClearWordIdFromNotification value)?
        clearWordIdFromNotification,
    TResult Function(_ScheduleNextDayReminder value)? scheduleNextDayReminder,
    TResult Function(_ScheduleWordReminder value)? scheduleWordsReminder,
    TResult Function(_ReminderWordTomorrow value)? reminderWordTomorrow,
    TResult Function(_GetScheduledNotifications value)?
        getScheduledNotifications,
    TResult Function(_RemoveScheduledNotifications value)?
        removeScheduledNotifications,
    TResult Function(_EmitState value)? emitState,
    required TResult orElse(),
  }) {
    if (scheduleNextDayReminder != null) {
      return scheduleNextDayReminder(this);
    }
    return orElse();
  }
}

abstract class _ScheduleNextDayReminder implements NotificationsEvent {
  const factory _ScheduleNextDayReminder() = _$ScheduleNextDayReminderImpl;
}

/// @nodoc
abstract class _$$ScheduleWordReminderImplCopyWith<$Res> {
  factory _$$ScheduleWordReminderImplCopyWith(_$ScheduleWordReminderImpl value,
          $Res Function(_$ScheduleWordReminderImpl) then) =
      __$$ScheduleWordReminderImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Word> words, DateTime scheduledTime, Duration interval});
}

/// @nodoc
class __$$ScheduleWordReminderImplCopyWithImpl<$Res>
    extends _$NotificationsEventCopyWithImpl<$Res, _$ScheduleWordReminderImpl>
    implements _$$ScheduleWordReminderImplCopyWith<$Res> {
  __$$ScheduleWordReminderImplCopyWithImpl(_$ScheduleWordReminderImpl _value,
      $Res Function(_$ScheduleWordReminderImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? words = null,
    Object? scheduledTime = null,
    Object? interval = null,
  }) {
    return _then(_$ScheduleWordReminderImpl(
      words: null == words
          ? _value._words
          : words // ignore: cast_nullable_to_non_nullable
              as List<Word>,
      scheduledTime: null == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      interval: null == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as Duration,
    ));
  }
}

/// @nodoc

class _$ScheduleWordReminderImpl
    with DiagnosticableTreeMixin
    implements _ScheduleWordReminder {
  const _$ScheduleWordReminderImpl(
      {required final List<Word> words,
      required this.scheduledTime,
      required this.interval})
      : _words = words;

  final List<Word> _words;
  @override
  List<Word> get words {
    if (_words is EqualUnmodifiableListView) return _words;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_words);
  }

  @override
  final DateTime scheduledTime;
  @override
  final Duration interval;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NotificationsEvent.scheduleWordsReminder(words: $words, scheduledTime: $scheduledTime, interval: $interval)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty(
          'type', 'NotificationsEvent.scheduleWordsReminder'))
      ..add(DiagnosticsProperty('words', words))
      ..add(DiagnosticsProperty('scheduledTime', scheduledTime))
      ..add(DiagnosticsProperty('interval', interval));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleWordReminderImpl &&
            const DeepCollectionEquality().equals(other._words, _words) &&
            (identical(other.scheduledTime, scheduledTime) ||
                other.scheduledTime == scheduledTime) &&
            (identical(other.interval, interval) ||
                other.interval == interval));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_words), scheduledTime, interval);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleWordReminderImplCopyWith<_$ScheduleWordReminderImpl>
      get copyWith =>
          __$$ScheduleWordReminderImplCopyWithImpl<_$ScheduleWordReminderImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() requestPermissions,
    required TResult Function() handleOpenAppFromNotification,
    required TResult Function() clearWordIdFromNotification,
    required TResult Function() scheduleNextDayReminder,
    required TResult Function(
            List<Word> words, DateTime scheduledTime, Duration interval)
        scheduleWordsReminder,
    required TResult Function(Word word) reminderWordTomorrow,
    required TResult Function() getScheduledNotifications,
    required TResult Function(int id) removeScheduledNotifications,
    required TResult Function(NotificationsState state) emitState,
  }) {
    return scheduleWordsReminder(words, scheduledTime, interval);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? requestPermissions,
    TResult? Function()? handleOpenAppFromNotification,
    TResult? Function()? clearWordIdFromNotification,
    TResult? Function()? scheduleNextDayReminder,
    TResult? Function(
            List<Word> words, DateTime scheduledTime, Duration interval)?
        scheduleWordsReminder,
    TResult? Function(Word word)? reminderWordTomorrow,
    TResult? Function()? getScheduledNotifications,
    TResult? Function(int id)? removeScheduledNotifications,
    TResult? Function(NotificationsState state)? emitState,
  }) {
    return scheduleWordsReminder?.call(words, scheduledTime, interval);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? requestPermissions,
    TResult Function()? handleOpenAppFromNotification,
    TResult Function()? clearWordIdFromNotification,
    TResult Function()? scheduleNextDayReminder,
    TResult Function(
            List<Word> words, DateTime scheduledTime, Duration interval)?
        scheduleWordsReminder,
    TResult Function(Word word)? reminderWordTomorrow,
    TResult Function()? getScheduledNotifications,
    TResult Function(int id)? removeScheduledNotifications,
    TResult Function(NotificationsState state)? emitState,
    required TResult orElse(),
  }) {
    if (scheduleWordsReminder != null) {
      return scheduleWordsReminder(words, scheduledTime, interval);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_RequestPermissions value) requestPermissions,
    required TResult Function(_HandleOpenAppFromNotification value)
        handleOpenAppFromNotification,
    required TResult Function(_ClearWordIdFromNotification value)
        clearWordIdFromNotification,
    required TResult Function(_ScheduleNextDayReminder value)
        scheduleNextDayReminder,
    required TResult Function(_ScheduleWordReminder value)
        scheduleWordsReminder,
    required TResult Function(_ReminderWordTomorrow value) reminderWordTomorrow,
    required TResult Function(_GetScheduledNotifications value)
        getScheduledNotifications,
    required TResult Function(_RemoveScheduledNotifications value)
        removeScheduledNotifications,
    required TResult Function(_EmitState value) emitState,
  }) {
    return scheduleWordsReminder(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_RequestPermissions value)? requestPermissions,
    TResult? Function(_HandleOpenAppFromNotification value)?
        handleOpenAppFromNotification,
    TResult? Function(_ClearWordIdFromNotification value)?
        clearWordIdFromNotification,
    TResult? Function(_ScheduleNextDayReminder value)? scheduleNextDayReminder,
    TResult? Function(_ScheduleWordReminder value)? scheduleWordsReminder,
    TResult? Function(_ReminderWordTomorrow value)? reminderWordTomorrow,
    TResult? Function(_GetScheduledNotifications value)?
        getScheduledNotifications,
    TResult? Function(_RemoveScheduledNotifications value)?
        removeScheduledNotifications,
    TResult? Function(_EmitState value)? emitState,
  }) {
    return scheduleWordsReminder?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RequestPermissions value)? requestPermissions,
    TResult Function(_HandleOpenAppFromNotification value)?
        handleOpenAppFromNotification,
    TResult Function(_ClearWordIdFromNotification value)?
        clearWordIdFromNotification,
    TResult Function(_ScheduleNextDayReminder value)? scheduleNextDayReminder,
    TResult Function(_ScheduleWordReminder value)? scheduleWordsReminder,
    TResult Function(_ReminderWordTomorrow value)? reminderWordTomorrow,
    TResult Function(_GetScheduledNotifications value)?
        getScheduledNotifications,
    TResult Function(_RemoveScheduledNotifications value)?
        removeScheduledNotifications,
    TResult Function(_EmitState value)? emitState,
    required TResult orElse(),
  }) {
    if (scheduleWordsReminder != null) {
      return scheduleWordsReminder(this);
    }
    return orElse();
  }
}

abstract class _ScheduleWordReminder implements NotificationsEvent {
  const factory _ScheduleWordReminder(
      {required final List<Word> words,
      required final DateTime scheduledTime,
      required final Duration interval}) = _$ScheduleWordReminderImpl;

  List<Word> get words;
  DateTime get scheduledTime;
  Duration get interval;
  @JsonKey(ignore: true)
  _$$ScheduleWordReminderImplCopyWith<_$ScheduleWordReminderImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ReminderWordTomorrowImplCopyWith<$Res> {
  factory _$$ReminderWordTomorrowImplCopyWith(_$ReminderWordTomorrowImpl value,
          $Res Function(_$ReminderWordTomorrowImpl) then) =
      __$$ReminderWordTomorrowImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Word word});

  $WordCopyWith<$Res> get word;
}

/// @nodoc
class __$$ReminderWordTomorrowImplCopyWithImpl<$Res>
    extends _$NotificationsEventCopyWithImpl<$Res, _$ReminderWordTomorrowImpl>
    implements _$$ReminderWordTomorrowImplCopyWith<$Res> {
  __$$ReminderWordTomorrowImplCopyWithImpl(_$ReminderWordTomorrowImpl _value,
      $Res Function(_$ReminderWordTomorrowImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? word = null,
  }) {
    return _then(_$ReminderWordTomorrowImpl(
      word: null == word
          ? _value.word
          : word // ignore: cast_nullable_to_non_nullable
              as Word,
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

class _$ReminderWordTomorrowImpl
    with DiagnosticableTreeMixin
    implements _ReminderWordTomorrow {
  const _$ReminderWordTomorrowImpl({required this.word});

  @override
  final Word word;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NotificationsEvent.reminderWordTomorrow(word: $word)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty(
          'type', 'NotificationsEvent.reminderWordTomorrow'))
      ..add(DiagnosticsProperty('word', word));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReminderWordTomorrowImpl &&
            (identical(other.word, word) || other.word == word));
  }

  @override
  int get hashCode => Object.hash(runtimeType, word);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReminderWordTomorrowImplCopyWith<_$ReminderWordTomorrowImpl>
      get copyWith =>
          __$$ReminderWordTomorrowImplCopyWithImpl<_$ReminderWordTomorrowImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() requestPermissions,
    required TResult Function() handleOpenAppFromNotification,
    required TResult Function() clearWordIdFromNotification,
    required TResult Function() scheduleNextDayReminder,
    required TResult Function(
            List<Word> words, DateTime scheduledTime, Duration interval)
        scheduleWordsReminder,
    required TResult Function(Word word) reminderWordTomorrow,
    required TResult Function() getScheduledNotifications,
    required TResult Function(int id) removeScheduledNotifications,
    required TResult Function(NotificationsState state) emitState,
  }) {
    return reminderWordTomorrow(word);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? requestPermissions,
    TResult? Function()? handleOpenAppFromNotification,
    TResult? Function()? clearWordIdFromNotification,
    TResult? Function()? scheduleNextDayReminder,
    TResult? Function(
            List<Word> words, DateTime scheduledTime, Duration interval)?
        scheduleWordsReminder,
    TResult? Function(Word word)? reminderWordTomorrow,
    TResult? Function()? getScheduledNotifications,
    TResult? Function(int id)? removeScheduledNotifications,
    TResult? Function(NotificationsState state)? emitState,
  }) {
    return reminderWordTomorrow?.call(word);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? requestPermissions,
    TResult Function()? handleOpenAppFromNotification,
    TResult Function()? clearWordIdFromNotification,
    TResult Function()? scheduleNextDayReminder,
    TResult Function(
            List<Word> words, DateTime scheduledTime, Duration interval)?
        scheduleWordsReminder,
    TResult Function(Word word)? reminderWordTomorrow,
    TResult Function()? getScheduledNotifications,
    TResult Function(int id)? removeScheduledNotifications,
    TResult Function(NotificationsState state)? emitState,
    required TResult orElse(),
  }) {
    if (reminderWordTomorrow != null) {
      return reminderWordTomorrow(word);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_RequestPermissions value) requestPermissions,
    required TResult Function(_HandleOpenAppFromNotification value)
        handleOpenAppFromNotification,
    required TResult Function(_ClearWordIdFromNotification value)
        clearWordIdFromNotification,
    required TResult Function(_ScheduleNextDayReminder value)
        scheduleNextDayReminder,
    required TResult Function(_ScheduleWordReminder value)
        scheduleWordsReminder,
    required TResult Function(_ReminderWordTomorrow value) reminderWordTomorrow,
    required TResult Function(_GetScheduledNotifications value)
        getScheduledNotifications,
    required TResult Function(_RemoveScheduledNotifications value)
        removeScheduledNotifications,
    required TResult Function(_EmitState value) emitState,
  }) {
    return reminderWordTomorrow(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_RequestPermissions value)? requestPermissions,
    TResult? Function(_HandleOpenAppFromNotification value)?
        handleOpenAppFromNotification,
    TResult? Function(_ClearWordIdFromNotification value)?
        clearWordIdFromNotification,
    TResult? Function(_ScheduleNextDayReminder value)? scheduleNextDayReminder,
    TResult? Function(_ScheduleWordReminder value)? scheduleWordsReminder,
    TResult? Function(_ReminderWordTomorrow value)? reminderWordTomorrow,
    TResult? Function(_GetScheduledNotifications value)?
        getScheduledNotifications,
    TResult? Function(_RemoveScheduledNotifications value)?
        removeScheduledNotifications,
    TResult? Function(_EmitState value)? emitState,
  }) {
    return reminderWordTomorrow?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RequestPermissions value)? requestPermissions,
    TResult Function(_HandleOpenAppFromNotification value)?
        handleOpenAppFromNotification,
    TResult Function(_ClearWordIdFromNotification value)?
        clearWordIdFromNotification,
    TResult Function(_ScheduleNextDayReminder value)? scheduleNextDayReminder,
    TResult Function(_ScheduleWordReminder value)? scheduleWordsReminder,
    TResult Function(_ReminderWordTomorrow value)? reminderWordTomorrow,
    TResult Function(_GetScheduledNotifications value)?
        getScheduledNotifications,
    TResult Function(_RemoveScheduledNotifications value)?
        removeScheduledNotifications,
    TResult Function(_EmitState value)? emitState,
    required TResult orElse(),
  }) {
    if (reminderWordTomorrow != null) {
      return reminderWordTomorrow(this);
    }
    return orElse();
  }
}

abstract class _ReminderWordTomorrow implements NotificationsEvent {
  const factory _ReminderWordTomorrow({required final Word word}) =
      _$ReminderWordTomorrowImpl;

  Word get word;
  @JsonKey(ignore: true)
  _$$ReminderWordTomorrowImplCopyWith<_$ReminderWordTomorrowImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GetScheduledNotificationsImplCopyWith<$Res> {
  factory _$$GetScheduledNotificationsImplCopyWith(
          _$GetScheduledNotificationsImpl value,
          $Res Function(_$GetScheduledNotificationsImpl) then) =
      __$$GetScheduledNotificationsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GetScheduledNotificationsImplCopyWithImpl<$Res>
    extends _$NotificationsEventCopyWithImpl<$Res,
        _$GetScheduledNotificationsImpl>
    implements _$$GetScheduledNotificationsImplCopyWith<$Res> {
  __$$GetScheduledNotificationsImplCopyWithImpl(
      _$GetScheduledNotificationsImpl _value,
      $Res Function(_$GetScheduledNotificationsImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$GetScheduledNotificationsImpl
    with DiagnosticableTreeMixin
    implements _GetScheduledNotifications {
  const _$GetScheduledNotificationsImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NotificationsEvent.getScheduledNotifications()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty(
        'type', 'NotificationsEvent.getScheduledNotifications'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetScheduledNotificationsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() requestPermissions,
    required TResult Function() handleOpenAppFromNotification,
    required TResult Function() clearWordIdFromNotification,
    required TResult Function() scheduleNextDayReminder,
    required TResult Function(
            List<Word> words, DateTime scheduledTime, Duration interval)
        scheduleWordsReminder,
    required TResult Function(Word word) reminderWordTomorrow,
    required TResult Function() getScheduledNotifications,
    required TResult Function(int id) removeScheduledNotifications,
    required TResult Function(NotificationsState state) emitState,
  }) {
    return getScheduledNotifications();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? requestPermissions,
    TResult? Function()? handleOpenAppFromNotification,
    TResult? Function()? clearWordIdFromNotification,
    TResult? Function()? scheduleNextDayReminder,
    TResult? Function(
            List<Word> words, DateTime scheduledTime, Duration interval)?
        scheduleWordsReminder,
    TResult? Function(Word word)? reminderWordTomorrow,
    TResult? Function()? getScheduledNotifications,
    TResult? Function(int id)? removeScheduledNotifications,
    TResult? Function(NotificationsState state)? emitState,
  }) {
    return getScheduledNotifications?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? requestPermissions,
    TResult Function()? handleOpenAppFromNotification,
    TResult Function()? clearWordIdFromNotification,
    TResult Function()? scheduleNextDayReminder,
    TResult Function(
            List<Word> words, DateTime scheduledTime, Duration interval)?
        scheduleWordsReminder,
    TResult Function(Word word)? reminderWordTomorrow,
    TResult Function()? getScheduledNotifications,
    TResult Function(int id)? removeScheduledNotifications,
    TResult Function(NotificationsState state)? emitState,
    required TResult orElse(),
  }) {
    if (getScheduledNotifications != null) {
      return getScheduledNotifications();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_RequestPermissions value) requestPermissions,
    required TResult Function(_HandleOpenAppFromNotification value)
        handleOpenAppFromNotification,
    required TResult Function(_ClearWordIdFromNotification value)
        clearWordIdFromNotification,
    required TResult Function(_ScheduleNextDayReminder value)
        scheduleNextDayReminder,
    required TResult Function(_ScheduleWordReminder value)
        scheduleWordsReminder,
    required TResult Function(_ReminderWordTomorrow value) reminderWordTomorrow,
    required TResult Function(_GetScheduledNotifications value)
        getScheduledNotifications,
    required TResult Function(_RemoveScheduledNotifications value)
        removeScheduledNotifications,
    required TResult Function(_EmitState value) emitState,
  }) {
    return getScheduledNotifications(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_RequestPermissions value)? requestPermissions,
    TResult? Function(_HandleOpenAppFromNotification value)?
        handleOpenAppFromNotification,
    TResult? Function(_ClearWordIdFromNotification value)?
        clearWordIdFromNotification,
    TResult? Function(_ScheduleNextDayReminder value)? scheduleNextDayReminder,
    TResult? Function(_ScheduleWordReminder value)? scheduleWordsReminder,
    TResult? Function(_ReminderWordTomorrow value)? reminderWordTomorrow,
    TResult? Function(_GetScheduledNotifications value)?
        getScheduledNotifications,
    TResult? Function(_RemoveScheduledNotifications value)?
        removeScheduledNotifications,
    TResult? Function(_EmitState value)? emitState,
  }) {
    return getScheduledNotifications?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RequestPermissions value)? requestPermissions,
    TResult Function(_HandleOpenAppFromNotification value)?
        handleOpenAppFromNotification,
    TResult Function(_ClearWordIdFromNotification value)?
        clearWordIdFromNotification,
    TResult Function(_ScheduleNextDayReminder value)? scheduleNextDayReminder,
    TResult Function(_ScheduleWordReminder value)? scheduleWordsReminder,
    TResult Function(_ReminderWordTomorrow value)? reminderWordTomorrow,
    TResult Function(_GetScheduledNotifications value)?
        getScheduledNotifications,
    TResult Function(_RemoveScheduledNotifications value)?
        removeScheduledNotifications,
    TResult Function(_EmitState value)? emitState,
    required TResult orElse(),
  }) {
    if (getScheduledNotifications != null) {
      return getScheduledNotifications(this);
    }
    return orElse();
  }
}

abstract class _GetScheduledNotifications implements NotificationsEvent {
  const factory _GetScheduledNotifications() = _$GetScheduledNotificationsImpl;
}

/// @nodoc
abstract class _$$RemoveScheduledNotificationsImplCopyWith<$Res> {
  factory _$$RemoveScheduledNotificationsImplCopyWith(
          _$RemoveScheduledNotificationsImpl value,
          $Res Function(_$RemoveScheduledNotificationsImpl) then) =
      __$$RemoveScheduledNotificationsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int id});
}

/// @nodoc
class __$$RemoveScheduledNotificationsImplCopyWithImpl<$Res>
    extends _$NotificationsEventCopyWithImpl<$Res,
        _$RemoveScheduledNotificationsImpl>
    implements _$$RemoveScheduledNotificationsImplCopyWith<$Res> {
  __$$RemoveScheduledNotificationsImplCopyWithImpl(
      _$RemoveScheduledNotificationsImpl _value,
      $Res Function(_$RemoveScheduledNotificationsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
  }) {
    return _then(_$RemoveScheduledNotificationsImpl(
      null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$RemoveScheduledNotificationsImpl
    with DiagnosticableTreeMixin
    implements _RemoveScheduledNotifications {
  const _$RemoveScheduledNotificationsImpl(this.id);

  @override
  final int id;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NotificationsEvent.removeScheduledNotifications(id: $id)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty(
          'type', 'NotificationsEvent.removeScheduledNotifications'))
      ..add(DiagnosticsProperty('id', id));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RemoveScheduledNotificationsImpl &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RemoveScheduledNotificationsImplCopyWith<
          _$RemoveScheduledNotificationsImpl>
      get copyWith => __$$RemoveScheduledNotificationsImplCopyWithImpl<
          _$RemoveScheduledNotificationsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() requestPermissions,
    required TResult Function() handleOpenAppFromNotification,
    required TResult Function() clearWordIdFromNotification,
    required TResult Function() scheduleNextDayReminder,
    required TResult Function(
            List<Word> words, DateTime scheduledTime, Duration interval)
        scheduleWordsReminder,
    required TResult Function(Word word) reminderWordTomorrow,
    required TResult Function() getScheduledNotifications,
    required TResult Function(int id) removeScheduledNotifications,
    required TResult Function(NotificationsState state) emitState,
  }) {
    return removeScheduledNotifications(id);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? requestPermissions,
    TResult? Function()? handleOpenAppFromNotification,
    TResult? Function()? clearWordIdFromNotification,
    TResult? Function()? scheduleNextDayReminder,
    TResult? Function(
            List<Word> words, DateTime scheduledTime, Duration interval)?
        scheduleWordsReminder,
    TResult? Function(Word word)? reminderWordTomorrow,
    TResult? Function()? getScheduledNotifications,
    TResult? Function(int id)? removeScheduledNotifications,
    TResult? Function(NotificationsState state)? emitState,
  }) {
    return removeScheduledNotifications?.call(id);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? requestPermissions,
    TResult Function()? handleOpenAppFromNotification,
    TResult Function()? clearWordIdFromNotification,
    TResult Function()? scheduleNextDayReminder,
    TResult Function(
            List<Word> words, DateTime scheduledTime, Duration interval)?
        scheduleWordsReminder,
    TResult Function(Word word)? reminderWordTomorrow,
    TResult Function()? getScheduledNotifications,
    TResult Function(int id)? removeScheduledNotifications,
    TResult Function(NotificationsState state)? emitState,
    required TResult orElse(),
  }) {
    if (removeScheduledNotifications != null) {
      return removeScheduledNotifications(id);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_RequestPermissions value) requestPermissions,
    required TResult Function(_HandleOpenAppFromNotification value)
        handleOpenAppFromNotification,
    required TResult Function(_ClearWordIdFromNotification value)
        clearWordIdFromNotification,
    required TResult Function(_ScheduleNextDayReminder value)
        scheduleNextDayReminder,
    required TResult Function(_ScheduleWordReminder value)
        scheduleWordsReminder,
    required TResult Function(_ReminderWordTomorrow value) reminderWordTomorrow,
    required TResult Function(_GetScheduledNotifications value)
        getScheduledNotifications,
    required TResult Function(_RemoveScheduledNotifications value)
        removeScheduledNotifications,
    required TResult Function(_EmitState value) emitState,
  }) {
    return removeScheduledNotifications(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_RequestPermissions value)? requestPermissions,
    TResult? Function(_HandleOpenAppFromNotification value)?
        handleOpenAppFromNotification,
    TResult? Function(_ClearWordIdFromNotification value)?
        clearWordIdFromNotification,
    TResult? Function(_ScheduleNextDayReminder value)? scheduleNextDayReminder,
    TResult? Function(_ScheduleWordReminder value)? scheduleWordsReminder,
    TResult? Function(_ReminderWordTomorrow value)? reminderWordTomorrow,
    TResult? Function(_GetScheduledNotifications value)?
        getScheduledNotifications,
    TResult? Function(_RemoveScheduledNotifications value)?
        removeScheduledNotifications,
    TResult? Function(_EmitState value)? emitState,
  }) {
    return removeScheduledNotifications?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RequestPermissions value)? requestPermissions,
    TResult Function(_HandleOpenAppFromNotification value)?
        handleOpenAppFromNotification,
    TResult Function(_ClearWordIdFromNotification value)?
        clearWordIdFromNotification,
    TResult Function(_ScheduleNextDayReminder value)? scheduleNextDayReminder,
    TResult Function(_ScheduleWordReminder value)? scheduleWordsReminder,
    TResult Function(_ReminderWordTomorrow value)? reminderWordTomorrow,
    TResult Function(_GetScheduledNotifications value)?
        getScheduledNotifications,
    TResult Function(_RemoveScheduledNotifications value)?
        removeScheduledNotifications,
    TResult Function(_EmitState value)? emitState,
    required TResult orElse(),
  }) {
    if (removeScheduledNotifications != null) {
      return removeScheduledNotifications(this);
    }
    return orElse();
  }
}

abstract class _RemoveScheduledNotifications implements NotificationsEvent {
  const factory _RemoveScheduledNotifications(final int id) =
      _$RemoveScheduledNotificationsImpl;

  int get id;
  @JsonKey(ignore: true)
  _$$RemoveScheduledNotificationsImplCopyWith<
          _$RemoveScheduledNotificationsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EmitStateImplCopyWith<$Res> {
  factory _$$EmitStateImplCopyWith(
          _$EmitStateImpl value, $Res Function(_$EmitStateImpl) then) =
      __$$EmitStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({NotificationsState state});

  $NotificationsStateCopyWith<$Res> get state;
}

/// @nodoc
class __$$EmitStateImplCopyWithImpl<$Res>
    extends _$NotificationsEventCopyWithImpl<$Res, _$EmitStateImpl>
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
              as NotificationsState,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $NotificationsStateCopyWith<$Res> get state {
    return $NotificationsStateCopyWith<$Res>(_value.state, (value) {
      return _then(_value.copyWith(state: value));
    });
  }
}

/// @nodoc

class _$EmitStateImpl with DiagnosticableTreeMixin implements _EmitState {
  const _$EmitStateImpl(this.state);

  @override
  final NotificationsState state;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NotificationsEvent.emitState(state: $state)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'NotificationsEvent.emitState'))
      ..add(DiagnosticsProperty('state', state));
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
    required TResult Function() requestPermissions,
    required TResult Function() handleOpenAppFromNotification,
    required TResult Function() clearWordIdFromNotification,
    required TResult Function() scheduleNextDayReminder,
    required TResult Function(
            List<Word> words, DateTime scheduledTime, Duration interval)
        scheduleWordsReminder,
    required TResult Function(Word word) reminderWordTomorrow,
    required TResult Function() getScheduledNotifications,
    required TResult Function(int id) removeScheduledNotifications,
    required TResult Function(NotificationsState state) emitState,
  }) {
    return emitState(state);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? requestPermissions,
    TResult? Function()? handleOpenAppFromNotification,
    TResult? Function()? clearWordIdFromNotification,
    TResult? Function()? scheduleNextDayReminder,
    TResult? Function(
            List<Word> words, DateTime scheduledTime, Duration interval)?
        scheduleWordsReminder,
    TResult? Function(Word word)? reminderWordTomorrow,
    TResult? Function()? getScheduledNotifications,
    TResult? Function(int id)? removeScheduledNotifications,
    TResult? Function(NotificationsState state)? emitState,
  }) {
    return emitState?.call(state);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? requestPermissions,
    TResult Function()? handleOpenAppFromNotification,
    TResult Function()? clearWordIdFromNotification,
    TResult Function()? scheduleNextDayReminder,
    TResult Function(
            List<Word> words, DateTime scheduledTime, Duration interval)?
        scheduleWordsReminder,
    TResult Function(Word word)? reminderWordTomorrow,
    TResult Function()? getScheduledNotifications,
    TResult Function(int id)? removeScheduledNotifications,
    TResult Function(NotificationsState state)? emitState,
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
    required TResult Function(_RequestPermissions value) requestPermissions,
    required TResult Function(_HandleOpenAppFromNotification value)
        handleOpenAppFromNotification,
    required TResult Function(_ClearWordIdFromNotification value)
        clearWordIdFromNotification,
    required TResult Function(_ScheduleNextDayReminder value)
        scheduleNextDayReminder,
    required TResult Function(_ScheduleWordReminder value)
        scheduleWordsReminder,
    required TResult Function(_ReminderWordTomorrow value) reminderWordTomorrow,
    required TResult Function(_GetScheduledNotifications value)
        getScheduledNotifications,
    required TResult Function(_RemoveScheduledNotifications value)
        removeScheduledNotifications,
    required TResult Function(_EmitState value) emitState,
  }) {
    return emitState(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_RequestPermissions value)? requestPermissions,
    TResult? Function(_HandleOpenAppFromNotification value)?
        handleOpenAppFromNotification,
    TResult? Function(_ClearWordIdFromNotification value)?
        clearWordIdFromNotification,
    TResult? Function(_ScheduleNextDayReminder value)? scheduleNextDayReminder,
    TResult? Function(_ScheduleWordReminder value)? scheduleWordsReminder,
    TResult? Function(_ReminderWordTomorrow value)? reminderWordTomorrow,
    TResult? Function(_GetScheduledNotifications value)?
        getScheduledNotifications,
    TResult? Function(_RemoveScheduledNotifications value)?
        removeScheduledNotifications,
    TResult? Function(_EmitState value)? emitState,
  }) {
    return emitState?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RequestPermissions value)? requestPermissions,
    TResult Function(_HandleOpenAppFromNotification value)?
        handleOpenAppFromNotification,
    TResult Function(_ClearWordIdFromNotification value)?
        clearWordIdFromNotification,
    TResult Function(_ScheduleNextDayReminder value)? scheduleNextDayReminder,
    TResult Function(_ScheduleWordReminder value)? scheduleWordsReminder,
    TResult Function(_ReminderWordTomorrow value)? reminderWordTomorrow,
    TResult Function(_GetScheduledNotifications value)?
        getScheduledNotifications,
    TResult Function(_RemoveScheduledNotifications value)?
        removeScheduledNotifications,
    TResult Function(_EmitState value)? emitState,
    required TResult orElse(),
  }) {
    if (emitState != null) {
      return emitState(this);
    }
    return orElse();
  }
}

abstract class _EmitState implements NotificationsEvent {
  const factory _EmitState(final NotificationsState state) = _$EmitStateImpl;

  NotificationsState get state;
  @JsonKey(ignore: true)
  _$$EmitStateImplCopyWith<_$EmitStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$NotificationsState {
  Failure? get failure => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  bool get isNotificationsGranted => throw _privateConstructorUsedError;
  int? get wordIdFromNotification => throw _privateConstructorUsedError;
  List<ScheduledNotification> get scheduledNotifications =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NotificationsStateCopyWith<NotificationsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationsStateCopyWith<$Res> {
  factory $NotificationsStateCopyWith(
          NotificationsState value, $Res Function(NotificationsState) then) =
      _$NotificationsStateCopyWithImpl<$Res, NotificationsState>;
  @useResult
  $Res call(
      {Failure? failure,
      String? message,
      bool isNotificationsGranted,
      int? wordIdFromNotification,
      List<ScheduledNotification> scheduledNotifications});
}

/// @nodoc
class _$NotificationsStateCopyWithImpl<$Res, $Val extends NotificationsState>
    implements $NotificationsStateCopyWith<$Res> {
  _$NotificationsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failure = freezed,
    Object? message = freezed,
    Object? isNotificationsGranted = null,
    Object? wordIdFromNotification = freezed,
    Object? scheduledNotifications = null,
  }) {
    return _then(_value.copyWith(
      failure: freezed == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      isNotificationsGranted: null == isNotificationsGranted
          ? _value.isNotificationsGranted
          : isNotificationsGranted // ignore: cast_nullable_to_non_nullable
              as bool,
      wordIdFromNotification: freezed == wordIdFromNotification
          ? _value.wordIdFromNotification
          : wordIdFromNotification // ignore: cast_nullable_to_non_nullable
              as int?,
      scheduledNotifications: null == scheduledNotifications
          ? _value.scheduledNotifications
          : scheduledNotifications // ignore: cast_nullable_to_non_nullable
              as List<ScheduledNotification>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationsStateImplCopyWith<$Res>
    implements $NotificationsStateCopyWith<$Res> {
  factory _$$NotificationsStateImplCopyWith(_$NotificationsStateImpl value,
          $Res Function(_$NotificationsStateImpl) then) =
      __$$NotificationsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Failure? failure,
      String? message,
      bool isNotificationsGranted,
      int? wordIdFromNotification,
      List<ScheduledNotification> scheduledNotifications});
}

/// @nodoc
class __$$NotificationsStateImplCopyWithImpl<$Res>
    extends _$NotificationsStateCopyWithImpl<$Res, _$NotificationsStateImpl>
    implements _$$NotificationsStateImplCopyWith<$Res> {
  __$$NotificationsStateImplCopyWithImpl(_$NotificationsStateImpl _value,
      $Res Function(_$NotificationsStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failure = freezed,
    Object? message = freezed,
    Object? isNotificationsGranted = null,
    Object? wordIdFromNotification = freezed,
    Object? scheduledNotifications = null,
  }) {
    return _then(_$NotificationsStateImpl(
      failure: freezed == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      isNotificationsGranted: null == isNotificationsGranted
          ? _value.isNotificationsGranted
          : isNotificationsGranted // ignore: cast_nullable_to_non_nullable
              as bool,
      wordIdFromNotification: freezed == wordIdFromNotification
          ? _value.wordIdFromNotification
          : wordIdFromNotification // ignore: cast_nullable_to_non_nullable
              as int?,
      scheduledNotifications: null == scheduledNotifications
          ? _value._scheduledNotifications
          : scheduledNotifications // ignore: cast_nullable_to_non_nullable
              as List<ScheduledNotification>,
    ));
  }
}

/// @nodoc

class _$NotificationsStateImpl
    with DiagnosticableTreeMixin
    implements _NotificationsState {
  const _$NotificationsStateImpl(
      {this.failure = null,
      this.message = null,
      this.isNotificationsGranted = false,
      this.wordIdFromNotification = null,
      final List<ScheduledNotification> scheduledNotifications = const []})
      : _scheduledNotifications = scheduledNotifications;

  @override
  @JsonKey()
  final Failure? failure;
  @override
  @JsonKey()
  final String? message;
  @override
  @JsonKey()
  final bool isNotificationsGranted;
  @override
  @JsonKey()
  final int? wordIdFromNotification;
  final List<ScheduledNotification> _scheduledNotifications;
  @override
  @JsonKey()
  List<ScheduledNotification> get scheduledNotifications {
    if (_scheduledNotifications is EqualUnmodifiableListView)
      return _scheduledNotifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scheduledNotifications);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NotificationsState(failure: $failure, message: $message, isNotificationsGranted: $isNotificationsGranted, wordIdFromNotification: $wordIdFromNotification, scheduledNotifications: $scheduledNotifications)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'NotificationsState'))
      ..add(DiagnosticsProperty('failure', failure))
      ..add(DiagnosticsProperty('message', message))
      ..add(
          DiagnosticsProperty('isNotificationsGranted', isNotificationsGranted))
      ..add(
          DiagnosticsProperty('wordIdFromNotification', wordIdFromNotification))
      ..add(DiagnosticsProperty(
          'scheduledNotifications', scheduledNotifications));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationsStateImpl &&
            (identical(other.failure, failure) || other.failure == failure) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.isNotificationsGranted, isNotificationsGranted) ||
                other.isNotificationsGranted == isNotificationsGranted) &&
            (identical(other.wordIdFromNotification, wordIdFromNotification) ||
                other.wordIdFromNotification == wordIdFromNotification) &&
            const DeepCollectionEquality().equals(
                other._scheduledNotifications, _scheduledNotifications));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      failure,
      message,
      isNotificationsGranted,
      wordIdFromNotification,
      const DeepCollectionEquality().hash(_scheduledNotifications));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationsStateImplCopyWith<_$NotificationsStateImpl> get copyWith =>
      __$$NotificationsStateImplCopyWithImpl<_$NotificationsStateImpl>(
          this, _$identity);
}

abstract class _NotificationsState implements NotificationsState {
  const factory _NotificationsState(
          {final Failure? failure,
          final String? message,
          final bool isNotificationsGranted,
          final int? wordIdFromNotification,
          final List<ScheduledNotification> scheduledNotifications}) =
      _$NotificationsStateImpl;

  @override
  Failure? get failure;
  @override
  String? get message;
  @override
  bool get isNotificationsGranted;
  @override
  int? get wordIdFromNotification;
  @override
  List<ScheduledNotification> get scheduledNotifications;
  @override
  @JsonKey(ignore: true)
  _$$NotificationsStateImplCopyWith<_$NotificationsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
