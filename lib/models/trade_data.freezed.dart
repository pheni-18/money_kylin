// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'trade_data_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$TradeDataStateTearOff {
  const _$TradeDataStateTearOff();

// ignore: unused_element
  _TradeDataState call({Map<DateTime, List<Trade>> trades = const {}}) {
    return _TradeDataState(
      trades: trades,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $TradeDataState = _$TradeDataStateTearOff();

/// @nodoc
mixin _$TradeDataState {
  Map<DateTime, List<Trade>> get trades;

  @JsonKey(ignore: true)
  $TradeDataStateCopyWith<TradeDataState> get copyWith;
}

/// @nodoc
abstract class $TradeDataStateCopyWith<$Res> {
  factory $TradeDataStateCopyWith(
          TradeDataState value, $Res Function(TradeDataState) then) =
      _$TradeDataStateCopyWithImpl<$Res>;
  $Res call({Map<DateTime, List<Trade>> trades});
}

/// @nodoc
class _$TradeDataStateCopyWithImpl<$Res>
    implements $TradeDataStateCopyWith<$Res> {
  _$TradeDataStateCopyWithImpl(this._value, this._then);

  final TradeDataState _value;
  // ignore: unused_field
  final $Res Function(TradeDataState) _then;

  @override
  $Res call({
    Object trades = freezed,
  }) {
    return _then(_value.copyWith(
      trades: trades == freezed
          ? _value.trades
          : trades as Map<DateTime, List<Trade>>,
    ));
  }
}

/// @nodoc
abstract class _$TradeDataStateCopyWith<$Res>
    implements $TradeDataStateCopyWith<$Res> {
  factory _$TradeDataStateCopyWith(
          _TradeDataState value, $Res Function(_TradeDataState) then) =
      __$TradeDataStateCopyWithImpl<$Res>;
  @override
  $Res call({Map<DateTime, List<Trade>> trades});
}

/// @nodoc
class __$TradeDataStateCopyWithImpl<$Res>
    extends _$TradeDataStateCopyWithImpl<$Res>
    implements _$TradeDataStateCopyWith<$Res> {
  __$TradeDataStateCopyWithImpl(
      _TradeDataState _value, $Res Function(_TradeDataState) _then)
      : super(_value, (v) => _then(v as _TradeDataState));

  @override
  _TradeDataState get _value => super._value as _TradeDataState;

  @override
  $Res call({
    Object trades = freezed,
  }) {
    return _then(_TradeDataState(
      trades: trades == freezed
          ? _value.trades
          : trades as Map<DateTime, List<Trade>>,
    ));
  }
}

/// @nodoc
class _$_TradeDataState
    with DiagnosticableTreeMixin
    implements _TradeDataState {
  const _$_TradeDataState({this.trades = const {}}) : assert(trades != null);

  @JsonKey(defaultValue: const {})
  @override
  final Map<DateTime, List<Trade>> trades;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'TradeDataState(trades: $trades)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'TradeDataState'))
      ..add(DiagnosticsProperty('trades', trades));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _TradeDataState &&
            (identical(other.trades, trades) ||
                const DeepCollectionEquality().equals(other.trades, trades)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(trades);

  @JsonKey(ignore: true)
  @override
  _$TradeDataStateCopyWith<_TradeDataState> get copyWith =>
      __$TradeDataStateCopyWithImpl<_TradeDataState>(this, _$identity);
}

abstract class _TradeDataState implements TradeDataState {
  const factory _TradeDataState({Map<DateTime, List<Trade>> trades}) =
      _$_TradeDataState;

  @override
  Map<DateTime, List<Trade>> get trades;
  @override
  @JsonKey(ignore: true)
  _$TradeDataStateCopyWith<_TradeDataState> get copyWith;
}
