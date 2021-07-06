import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_kylin/models/trade.dart';

part 'trade_data.freezed.dart';

@freezed
abstract class TradeDataState with _$TradeDataState {
  const factory TradeDataState({
    @Default({}) Map<DateTime, List<Trade>> trades,
  }) = _TradeDataState;
}
