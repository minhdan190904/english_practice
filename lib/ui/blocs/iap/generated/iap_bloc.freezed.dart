// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../iap_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$IapEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() listenForPurchases,
    required TResult Function() restorePurchases,
    required TResult Function(String id, bool isFree) purchaseProduct,
    required TResult Function(IapState state) emitState,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? listenForPurchases,
    TResult? Function()? restorePurchases,
    TResult? Function(String id, bool isFree)? purchaseProduct,
    TResult? Function(IapState state)? emitState,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? listenForPurchases,
    TResult Function()? restorePurchases,
    TResult Function(String id, bool isFree)? purchaseProduct,
    TResult Function(IapState state)? emitState,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ListenForPurchases value) listenForPurchases,
    required TResult Function(_RestorePurchases value) restorePurchases,
    required TResult Function(_PurchaseProduct value) purchaseProduct,
    required TResult Function(_EmitState value) emitState,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ListenForPurchases value)? listenForPurchases,
    TResult? Function(_RestorePurchases value)? restorePurchases,
    TResult? Function(_PurchaseProduct value)? purchaseProduct,
    TResult? Function(_EmitState value)? emitState,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ListenForPurchases value)? listenForPurchases,
    TResult Function(_RestorePurchases value)? restorePurchases,
    TResult Function(_PurchaseProduct value)? purchaseProduct,
    TResult Function(_EmitState value)? emitState,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IapEventCopyWith<$Res> {
  factory $IapEventCopyWith(IapEvent value, $Res Function(IapEvent) then) =
      _$IapEventCopyWithImpl<$Res, IapEvent>;
}

/// @nodoc
class _$IapEventCopyWithImpl<$Res, $Val extends IapEvent>
    implements $IapEventCopyWith<$Res> {
  _$IapEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ListenForPurchasesImplCopyWith<$Res> {
  factory _$$ListenForPurchasesImplCopyWith(_$ListenForPurchasesImpl value,
          $Res Function(_$ListenForPurchasesImpl) then) =
      __$$ListenForPurchasesImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ListenForPurchasesImplCopyWithImpl<$Res>
    extends _$IapEventCopyWithImpl<$Res, _$ListenForPurchasesImpl>
    implements _$$ListenForPurchasesImplCopyWith<$Res> {
  __$$ListenForPurchasesImplCopyWithImpl(_$ListenForPurchasesImpl _value,
      $Res Function(_$ListenForPurchasesImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ListenForPurchasesImpl
    with DiagnosticableTreeMixin
    implements _ListenForPurchases {
  const _$ListenForPurchasesImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'IapEvent.listenForPurchases()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'IapEvent.listenForPurchases'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ListenForPurchasesImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() listenForPurchases,
    required TResult Function() restorePurchases,
    required TResult Function(String id, bool isFree) purchaseProduct,
    required TResult Function(IapState state) emitState,
  }) {
    return listenForPurchases();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? listenForPurchases,
    TResult? Function()? restorePurchases,
    TResult? Function(String id, bool isFree)? purchaseProduct,
    TResult? Function(IapState state)? emitState,
  }) {
    return listenForPurchases?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? listenForPurchases,
    TResult Function()? restorePurchases,
    TResult Function(String id, bool isFree)? purchaseProduct,
    TResult Function(IapState state)? emitState,
    required TResult orElse(),
  }) {
    if (listenForPurchases != null) {
      return listenForPurchases();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ListenForPurchases value) listenForPurchases,
    required TResult Function(_RestorePurchases value) restorePurchases,
    required TResult Function(_PurchaseProduct value) purchaseProduct,
    required TResult Function(_EmitState value) emitState,
  }) {
    return listenForPurchases(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ListenForPurchases value)? listenForPurchases,
    TResult? Function(_RestorePurchases value)? restorePurchases,
    TResult? Function(_PurchaseProduct value)? purchaseProduct,
    TResult? Function(_EmitState value)? emitState,
  }) {
    return listenForPurchases?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ListenForPurchases value)? listenForPurchases,
    TResult Function(_RestorePurchases value)? restorePurchases,
    TResult Function(_PurchaseProduct value)? purchaseProduct,
    TResult Function(_EmitState value)? emitState,
    required TResult orElse(),
  }) {
    if (listenForPurchases != null) {
      return listenForPurchases(this);
    }
    return orElse();
  }
}

abstract class _ListenForPurchases implements IapEvent {
  const factory _ListenForPurchases() = _$ListenForPurchasesImpl;
}

/// @nodoc
abstract class _$$RestorePurchasesImplCopyWith<$Res> {
  factory _$$RestorePurchasesImplCopyWith(_$RestorePurchasesImpl value,
          $Res Function(_$RestorePurchasesImpl) then) =
      __$$RestorePurchasesImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RestorePurchasesImplCopyWithImpl<$Res>
    extends _$IapEventCopyWithImpl<$Res, _$RestorePurchasesImpl>
    implements _$$RestorePurchasesImplCopyWith<$Res> {
  __$$RestorePurchasesImplCopyWithImpl(_$RestorePurchasesImpl _value,
      $Res Function(_$RestorePurchasesImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$RestorePurchasesImpl
    with DiagnosticableTreeMixin
    implements _RestorePurchases {
  const _$RestorePurchasesImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'IapEvent.restorePurchases()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'IapEvent.restorePurchases'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$RestorePurchasesImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() listenForPurchases,
    required TResult Function() restorePurchases,
    required TResult Function(String id, bool isFree) purchaseProduct,
    required TResult Function(IapState state) emitState,
  }) {
    return restorePurchases();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? listenForPurchases,
    TResult? Function()? restorePurchases,
    TResult? Function(String id, bool isFree)? purchaseProduct,
    TResult? Function(IapState state)? emitState,
  }) {
    return restorePurchases?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? listenForPurchases,
    TResult Function()? restorePurchases,
    TResult Function(String id, bool isFree)? purchaseProduct,
    TResult Function(IapState state)? emitState,
    required TResult orElse(),
  }) {
    if (restorePurchases != null) {
      return restorePurchases();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ListenForPurchases value) listenForPurchases,
    required TResult Function(_RestorePurchases value) restorePurchases,
    required TResult Function(_PurchaseProduct value) purchaseProduct,
    required TResult Function(_EmitState value) emitState,
  }) {
    return restorePurchases(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ListenForPurchases value)? listenForPurchases,
    TResult? Function(_RestorePurchases value)? restorePurchases,
    TResult? Function(_PurchaseProduct value)? purchaseProduct,
    TResult? Function(_EmitState value)? emitState,
  }) {
    return restorePurchases?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ListenForPurchases value)? listenForPurchases,
    TResult Function(_RestorePurchases value)? restorePurchases,
    TResult Function(_PurchaseProduct value)? purchaseProduct,
    TResult Function(_EmitState value)? emitState,
    required TResult orElse(),
  }) {
    if (restorePurchases != null) {
      return restorePurchases(this);
    }
    return orElse();
  }
}

abstract class _RestorePurchases implements IapEvent {
  const factory _RestorePurchases() = _$RestorePurchasesImpl;
}

/// @nodoc
abstract class _$$PurchaseProductImplCopyWith<$Res> {
  factory _$$PurchaseProductImplCopyWith(_$PurchaseProductImpl value,
          $Res Function(_$PurchaseProductImpl) then) =
      __$$PurchaseProductImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String id, bool isFree});
}

/// @nodoc
class __$$PurchaseProductImplCopyWithImpl<$Res>
    extends _$IapEventCopyWithImpl<$Res, _$PurchaseProductImpl>
    implements _$$PurchaseProductImplCopyWith<$Res> {
  __$$PurchaseProductImplCopyWithImpl(
      _$PurchaseProductImpl _value, $Res Function(_$PurchaseProductImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? isFree = null,
  }) {
    return _then(_$PurchaseProductImpl(
      null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      isFree: null == isFree
          ? _value.isFree
          : isFree // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$PurchaseProductImpl
    with DiagnosticableTreeMixin
    implements _PurchaseProduct {
  const _$PurchaseProductImpl(this.id, {this.isFree = false});

  @override
  final String id;
  @override
  @JsonKey()
  final bool isFree;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'IapEvent.purchaseProduct(id: $id, isFree: $isFree)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'IapEvent.purchaseProduct'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('isFree', isFree));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseProductImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.isFree, isFree) || other.isFree == isFree));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, isFree);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseProductImplCopyWith<_$PurchaseProductImpl> get copyWith =>
      __$$PurchaseProductImplCopyWithImpl<_$PurchaseProductImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() listenForPurchases,
    required TResult Function() restorePurchases,
    required TResult Function(String id, bool isFree) purchaseProduct,
    required TResult Function(IapState state) emitState,
  }) {
    return purchaseProduct(id, isFree);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? listenForPurchases,
    TResult? Function()? restorePurchases,
    TResult? Function(String id, bool isFree)? purchaseProduct,
    TResult? Function(IapState state)? emitState,
  }) {
    return purchaseProduct?.call(id, isFree);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? listenForPurchases,
    TResult Function()? restorePurchases,
    TResult Function(String id, bool isFree)? purchaseProduct,
    TResult Function(IapState state)? emitState,
    required TResult orElse(),
  }) {
    if (purchaseProduct != null) {
      return purchaseProduct(id, isFree);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ListenForPurchases value) listenForPurchases,
    required TResult Function(_RestorePurchases value) restorePurchases,
    required TResult Function(_PurchaseProduct value) purchaseProduct,
    required TResult Function(_EmitState value) emitState,
  }) {
    return purchaseProduct(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ListenForPurchases value)? listenForPurchases,
    TResult? Function(_RestorePurchases value)? restorePurchases,
    TResult? Function(_PurchaseProduct value)? purchaseProduct,
    TResult? Function(_EmitState value)? emitState,
  }) {
    return purchaseProduct?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ListenForPurchases value)? listenForPurchases,
    TResult Function(_RestorePurchases value)? restorePurchases,
    TResult Function(_PurchaseProduct value)? purchaseProduct,
    TResult Function(_EmitState value)? emitState,
    required TResult orElse(),
  }) {
    if (purchaseProduct != null) {
      return purchaseProduct(this);
    }
    return orElse();
  }
}

abstract class _PurchaseProduct implements IapEvent {
  const factory _PurchaseProduct(final String id, {final bool isFree}) =
      _$PurchaseProductImpl;

  String get id;
  bool get isFree;
  @JsonKey(ignore: true)
  _$$PurchaseProductImplCopyWith<_$PurchaseProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EmitStateImplCopyWith<$Res> {
  factory _$$EmitStateImplCopyWith(
          _$EmitStateImpl value, $Res Function(_$EmitStateImpl) then) =
      __$$EmitStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({IapState state});

  $IapStateCopyWith<$Res> get state;
}

/// @nodoc
class __$$EmitStateImplCopyWithImpl<$Res>
    extends _$IapEventCopyWithImpl<$Res, _$EmitStateImpl>
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
              as IapState,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $IapStateCopyWith<$Res> get state {
    return $IapStateCopyWith<$Res>(_value.state, (value) {
      return _then(_value.copyWith(state: value));
    });
  }
}

/// @nodoc

class _$EmitStateImpl with DiagnosticableTreeMixin implements _EmitState {
  const _$EmitStateImpl(this.state);

  @override
  final IapState state;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'IapEvent.emitState(state: $state)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'IapEvent.emitState'))
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
    required TResult Function() listenForPurchases,
    required TResult Function() restorePurchases,
    required TResult Function(String id, bool isFree) purchaseProduct,
    required TResult Function(IapState state) emitState,
  }) {
    return emitState(state);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? listenForPurchases,
    TResult? Function()? restorePurchases,
    TResult? Function(String id, bool isFree)? purchaseProduct,
    TResult? Function(IapState state)? emitState,
  }) {
    return emitState?.call(state);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? listenForPurchases,
    TResult Function()? restorePurchases,
    TResult Function(String id, bool isFree)? purchaseProduct,
    TResult Function(IapState state)? emitState,
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
    required TResult Function(_ListenForPurchases value) listenForPurchases,
    required TResult Function(_RestorePurchases value) restorePurchases,
    required TResult Function(_PurchaseProduct value) purchaseProduct,
    required TResult Function(_EmitState value) emitState,
  }) {
    return emitState(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ListenForPurchases value)? listenForPurchases,
    TResult? Function(_RestorePurchases value)? restorePurchases,
    TResult? Function(_PurchaseProduct value)? purchaseProduct,
    TResult? Function(_EmitState value)? emitState,
  }) {
    return emitState?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ListenForPurchases value)? listenForPurchases,
    TResult Function(_RestorePurchases value)? restorePurchases,
    TResult Function(_PurchaseProduct value)? purchaseProduct,
    TResult Function(_EmitState value)? emitState,
    required TResult orElse(),
  }) {
    if (emitState != null) {
      return emitState(this);
    }
    return orElse();
  }
}

abstract class _EmitState implements IapEvent {
  const factory _EmitState(final IapState state) = _$EmitStateImpl;

  IapState get state;
  @JsonKey(ignore: true)
  _$$EmitStateImplCopyWith<_$EmitStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$IapState {
  Failure? get failure => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  List<ProductDetails> get products => throw _privateConstructorUsedError;
  List<PurchaseDetails> get purchases => throw _privateConstructorUsedError;
  int? get boughtNoAdsTime => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $IapStateCopyWith<IapState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IapStateCopyWith<$Res> {
  factory $IapStateCopyWith(IapState value, $Res Function(IapState) then) =
      _$IapStateCopyWithImpl<$Res, IapState>;
  @useResult
  $Res call(
      {Failure? failure,
      bool isLoading,
      List<ProductDetails> products,
      List<PurchaseDetails> purchases,
      int? boughtNoAdsTime});
}

/// @nodoc
class _$IapStateCopyWithImpl<$Res, $Val extends IapState>
    implements $IapStateCopyWith<$Res> {
  _$IapStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failure = freezed,
    Object? isLoading = null,
    Object? products = null,
    Object? purchases = null,
    Object? boughtNoAdsTime = freezed,
  }) {
    return _then(_value.copyWith(
      failure: freezed == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      products: null == products
          ? _value.products
          : products // ignore: cast_nullable_to_non_nullable
              as List<ProductDetails>,
      purchases: null == purchases
          ? _value.purchases
          : purchases // ignore: cast_nullable_to_non_nullable
              as List<PurchaseDetails>,
      boughtNoAdsTime: freezed == boughtNoAdsTime
          ? _value.boughtNoAdsTime
          : boughtNoAdsTime // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IapStateImplCopyWith<$Res>
    implements $IapStateCopyWith<$Res> {
  factory _$$IapStateImplCopyWith(
          _$IapStateImpl value, $Res Function(_$IapStateImpl) then) =
      __$$IapStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Failure? failure,
      bool isLoading,
      List<ProductDetails> products,
      List<PurchaseDetails> purchases,
      int? boughtNoAdsTime});
}

/// @nodoc
class __$$IapStateImplCopyWithImpl<$Res>
    extends _$IapStateCopyWithImpl<$Res, _$IapStateImpl>
    implements _$$IapStateImplCopyWith<$Res> {
  __$$IapStateImplCopyWithImpl(
      _$IapStateImpl _value, $Res Function(_$IapStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failure = freezed,
    Object? isLoading = null,
    Object? products = null,
    Object? purchases = null,
    Object? boughtNoAdsTime = freezed,
  }) {
    return _then(_$IapStateImpl(
      failure: freezed == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      products: null == products
          ? _value._products
          : products // ignore: cast_nullable_to_non_nullable
              as List<ProductDetails>,
      purchases: null == purchases
          ? _value._purchases
          : purchases // ignore: cast_nullable_to_non_nullable
              as List<PurchaseDetails>,
      boughtNoAdsTime: freezed == boughtNoAdsTime
          ? _value.boughtNoAdsTime
          : boughtNoAdsTime // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$IapStateImpl with DiagnosticableTreeMixin implements _IapState {
  const _$IapStateImpl(
      {this.failure = null,
      this.isLoading = false,
      final List<ProductDetails> products = const [],
      final List<PurchaseDetails> purchases = const [],
      this.boughtNoAdsTime = null})
      : _products = products,
        _purchases = purchases;

  @override
  @JsonKey()
  final Failure? failure;
  @override
  @JsonKey()
  final bool isLoading;
  final List<ProductDetails> _products;
  @override
  @JsonKey()
  List<ProductDetails> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  final List<PurchaseDetails> _purchases;
  @override
  @JsonKey()
  List<PurchaseDetails> get purchases {
    if (_purchases is EqualUnmodifiableListView) return _purchases;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_purchases);
  }

  @override
  @JsonKey()
  final int? boughtNoAdsTime;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'IapState(failure: $failure, isLoading: $isLoading, products: $products, purchases: $purchases, boughtNoAdsTime: $boughtNoAdsTime)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'IapState'))
      ..add(DiagnosticsProperty('failure', failure))
      ..add(DiagnosticsProperty('isLoading', isLoading))
      ..add(DiagnosticsProperty('products', products))
      ..add(DiagnosticsProperty('purchases', purchases))
      ..add(DiagnosticsProperty('boughtNoAdsTime', boughtNoAdsTime));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IapStateImpl &&
            (identical(other.failure, failure) || other.failure == failure) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            const DeepCollectionEquality()
                .equals(other._purchases, _purchases) &&
            (identical(other.boughtNoAdsTime, boughtNoAdsTime) ||
                other.boughtNoAdsTime == boughtNoAdsTime));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      failure,
      isLoading,
      const DeepCollectionEquality().hash(_products),
      const DeepCollectionEquality().hash(_purchases),
      boughtNoAdsTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$IapStateImplCopyWith<_$IapStateImpl> get copyWith =>
      __$$IapStateImplCopyWithImpl<_$IapStateImpl>(this, _$identity);
}

abstract class _IapState implements IapState {
  const factory _IapState(
      {final Failure? failure,
      final bool isLoading,
      final List<ProductDetails> products,
      final List<PurchaseDetails> purchases,
      final int? boughtNoAdsTime}) = _$IapStateImpl;

  @override
  Failure? get failure;
  @override
  bool get isLoading;
  @override
  List<ProductDetails> get products;
  @override
  List<PurchaseDetails> get purchases;
  @override
  int? get boughtNoAdsTime;
  @override
  @JsonKey(ignore: true)
  _$$IapStateImplCopyWith<_$IapStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
