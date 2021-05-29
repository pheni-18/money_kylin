import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:money_kylin/models/trade.dart';

class TradeData extends ChangeNotifier {
  int latestID = 0;

  Map<DateTime, List<Trade>> _trades = {};

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

  void addTrade(
      String type, String group, String category, int amount, DateTime date) {
    latestID += 1;
    final trade = Trade(latestID, type, group, category, amount, date);
    if (_trades[date] == null) {
      _trades[date] = [trade];
    } else {
      _trades[date].add(trade);
    }

    notifyListeners();
  }

  void updateTrade(int id, String type, String group, String category,
      int amount, DateTime date) {
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
    for (List<Trade> v in _trades.values) {
      v.removeWhere((x) => x.id == id);
    }

    notifyListeners();
  }
}
