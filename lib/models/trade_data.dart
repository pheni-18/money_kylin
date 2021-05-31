import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:money_kylin/models/trade.dart';
import 'package:money_kylin/repositories/trade.dart';

class TradeData extends ChangeNotifier {
  final TradeRepository repository = TradeRepository();

  Map<DateTime, List<Trade>> _trades = {};

  TradeData() {
    Future(() async {
      List<Trade> trades = await repository.findAll();
      for (Trade trade in trades) {
        if (_trades[trade.date] == null) {
          _trades[trade.date] = [trade];
        } else {
          _trades[trade.date].add(trade);
        }
      }

      notifyListeners();
    });
  }

  UnmodifiableListView<Trade> getTradesByDate(DateTime date) {
    List<Trade> trades = _trades[date];
    if (trades == null) {
      List<Trade> emptyList = [];
      return UnmodifiableListView(emptyList);
    }
    return UnmodifiableListView(trades);
  }

  int monthlyAmount(int year, int month) {
    int total = 0;
    for (DateTime k in _trades.keys) {
      if (k.year != year || k.month != month) {
        continue;
      }

      List<Trade> dailyTrades = _trades[k];
      for (Trade trade in dailyTrades) {
        total += trade.amount;
      }
    }
    return total;
  }

  void addTrade(String type, String group, String category, int amount,
      DateTime date) async {
    int id = await repository.insert(type, group, category, amount, date);
    final trade = Trade(id, type, group, category, amount, date);
    if (_trades[date] == null) {
      _trades[date] = [trade];
    } else {
      _trades[date].add(trade);
    }

    notifyListeners();
  }

  void updateTrade(int id, String type, String group, String category,
      int amount, DateTime date) {
    repository.update(id, type, group, category, amount, date);

    Trade trade;
    bool isDateChanged = false;
    DateTime oldDate;

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

    notifyListeners();
  }

  void deleteTrade(int id) {
    repository.delete(id);

    for (List<Trade> v in _trades.values) {
      v.removeWhere((x) => x.id == id);
    }

    notifyListeners();
  }
}
