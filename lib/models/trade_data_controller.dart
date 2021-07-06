import 'package:money_kylin/repositories/trade.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'trade_data_state.dart';
import 'trade.dart';

final tradeDataProvider = StateNotifierProvider<TradeDataController>(
  (ref) => TradeDataController(ref.read),
);

class TradeDataController extends StateNotifier<TradeDataState> {
  TradeDataController(this._read) : super(TradeDataState()) {
    () async {
      List<Trade> trades = await repository.findAll();
      Map<DateTime, List<Trade>> _trades = {};
      for (Trade trade in trades) {
        if (_trades[trade.date] == null) {
          _trades[trade.date] = [trade];
        } else {
          _trades[trade.date].add(trade);
        }
      }
      state = state.copyWith(
        trades: _trades,
      );
    }();
  }

  final Reader _read;

  TradeRepository get repository => _read(tradeRepositoryProvider);

  Future<void> addTrade(String type, String group, String category, int amount,
      DateTime date) async {
    final int id = await repository.insert(type, group, category, amount, date);
    final trade = Trade(id, type, group, category, amount, date);
    Map<DateTime, List<Trade>> _trades = {...state.trades};
    if (_trades[date] == null) {
      _trades[date] = [trade];
    } else {
      _trades[date].add(trade);
    }

    state = state.copyWith(
      trades: _trades,
    );
  }

  Future<void> updateTrade(int id, String type, String group, String category,
      int amount, DateTime date) async {
    await repository.update(id, type, group, category, amount, date);

    Trade trade;
    bool isDateChanged = false;
    DateTime oldDate;

    Map<DateTime, List<Trade>> _trades = {...state.trades};
    for (List<Trade> v in _trades.values) {
      trade = v.firstWhere((x) => x.id == id, orElse: () => null);
      if (trade != null) {
        if (trade.type != type) {
          trade.type = type;
        }
        if (trade.group != group) {
          trade.group = group;
        }
        if (trade.category != category) {
          trade.category = category;
        }
        if (trade.amount != amount) {
          trade.amount = amount;
        }
        if (trade.date != date) {
          oldDate = trade.date;
          trade.date = date;
          isDateChanged = true;
        }
        break;
      }
    }

    if (isDateChanged) {
      _trades[oldDate].removeWhere((x) => x.id == id);

      if (_trades[date] == null) {
        _trades[date] = [trade];
      } else {
        _trades[date].add(trade);
      }
    }

    state = state.copyWith(
      trades: _trades,
    );
  }

  Future<void> deleteTrade(int id) async {
    await repository.delete(id);

    Map<DateTime, List<Trade>> _trades = {...state.trades};
    for (List<Trade> v in _trades.values) {
      v.removeWhere((x) => x.id == id);
    }

    state = state.copyWith(
      trades: _trades,
    );
  }
}
