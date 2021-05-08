import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:money_kylin/models/trade.dart';

class TradeData extends ChangeNotifier {
  Map<DateTime, List<Trade>> _trades = {
    DateTime(2021, 4, 1): [
      Trade(
        1,
        '収入',
        '固定収入',
        '給料',
        500000,
        DateTime(2021, 4, 1),
      ),
      Trade(
        2,
        '支出',
        '固定費',
        '家賃',
        -100000,
        DateTime(2021, 4, 1),
      ),
      Trade(
        3,
        '支出',
        '変動費',
        '外食費',
        -10000,
        DateTime(2021, 4, 1),
      ),
    ],
    DateTime(2021, 4, 2): [
      Trade(
        4,
        '支出',
        '固定費',
        '携帯代',
        -5000,
        DateTime(2021, 4, 2),
      ),
    ],
    DateTime(2021, 4, 3): [
      Trade(
        5,
        '貯蓄',
        '定期貯金',
        '貯金',
        -100000,
        DateTime(2021, 4, 3),
      ),
      Trade(
        6,
        '支出',
        '変動費',
        '交通費',
        -3000,
        DateTime(2021, 4, 3),
      ),
    ]
  };

  UnmodifiableListView<Trade> getTradesByDate(DateTime date) {
    List<Trade> trades = _trades[date];
    if (trades == null) {
      List<Trade> emptyList = [];
      return UnmodifiableListView(emptyList);
    }
    return UnmodifiableListView(trades);
  }

  void addTrade(int id, String type, String group, String category, int amount,
      DateTime date) {
    final trade = Trade(id, type, group, category, amount, date);
    _trades[date].add(trade);
    notifyListeners();
  }
}