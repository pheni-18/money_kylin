import 'dart:collection';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:money_kylin/repositories/trade.dart';
import './trade_data_test.mocks.dart';
import 'package:money_kylin/models/trade_data.dart';
import 'package:money_kylin/models/trade.dart';

@GenerateMocks([TradeRepository])
void main() {
  final TradeRepository repository = MockTradeRepository();
  when(repository.findAll()).thenAnswer((_) async {
    return [
      Trade(1, 'type1', 'group1', 'category1', 1000, DateTime(2021, 1, 1)),
      Trade(2, 'type2', 'group2', 'category2', 2000, DateTime(2021, 1, 2)),
      Trade(3, 'type3', 'group3', 'category3', 3000, DateTime(2021, 1, 3)),
    ];
  });

  group('getTradesByDate', () {
    final TradeData tradeData = TradeData(repository: repository);
    test('trades exist', () {
      final DateTime date = DateTime(2021, 1, 1);
      var result = tradeData.getTradesByDate(date);
      expect(result, isA<UnmodifiableListView<Trade>>());
      expect(result, isNotEmpty);
    });

    test('no trade exist', () {
      final TradeData tradeData = TradeData(repository: repository);
      final DateTime date = DateTime(2021, 1, 4);
      var result = tradeData.getTradesByDate(date);
      expect(result, isA<UnmodifiableListView<Trade>>());
      expect(result, isEmpty);
    });
  });

  group('monthlyAmount', () {
    final TradeData tradeData = TradeData(repository: repository);
    test('trades exist', () {
      var result = tradeData.monthlyAmount(2021, 1);
      expect(result, 6000);
    });

    test('no trade exist', () {
      var result = tradeData.monthlyAmount(2021, 2);
      expect(result, 0);
    });
  });

  group('addTrade', () {
    final TradeData tradeData = TradeData(repository: repository);
    final String type = 'type4';
    final String group = 'group4';
    final String category = 'category4';
    final int amount = 4000;

    test('already trades exist for the day', () async {
      final DateTime date = DateTime(2021, 1, 1);
      when(repository.insert(type, group, category, amount, date))
          .thenAnswer((_) async {
        return 4;
      });
      await tradeData.addTrade(type, group, category, amount, date);
      var result = tradeData.getTradesByDate(date);
      expect(result.length, 2);
    });

    test('no trade exist for the day', () async {
      final DateTime date = DateTime(2021, 1, 4);
      when(repository.insert(type, group, category, amount, date))
          .thenAnswer((_) async {
        return 4;
      });
      await tradeData.addTrade(type, group, category, amount, date);
      var result = tradeData.getTradesByDate(date);
      expect(result.length, 1);
    });
  });

  group('updateTrade', () {
    TradeData tradeData = TradeData(repository: repository);
    final int id = 1;
    final String type = 'type12';
    final String group = 'group12';
    final String category = 'category12';
    final int amount = 1200;
    test('same date', () async {
      final DateTime date = DateTime(2021, 1, 1);
      when(repository.update(id, type, group, category, amount, date))
          .thenAnswer((_) async {});
      await tradeData.updateTrade(id, type, group, category, amount, date);
      var result = tradeData.getTradesByDate(date);
      expect(result.length, 1);

      Trade trade = result[0];
      expect(trade.id, id);
      expect(trade.type, type);
      expect(trade.group, group);
      expect(trade.category, category);
      expect(trade.amount, amount);
      expect(trade.date, date);
    });

    test('other date', () async {
      final DateTime date = DateTime(2021, 1, 4);
      when(repository.update(id, type, group, category, amount, date))
          .thenAnswer((_) async {});
      await tradeData.updateTrade(id, type, group, category, amount, date);
      var result = tradeData.getTradesByDate(date);
      expect(result.length, 1);

      Trade trade = result[0];
      expect(trade.id, id);
      expect(trade.type, type);
      expect(trade.group, group);
      expect(trade.category, category);
      expect(trade.amount, amount);
      expect(trade.date, date);

      final DateTime oldDate = DateTime(2021, 1, 1);
      result = tradeData.getTradesByDate(oldDate);
      expect(result, isEmpty);
    });
  });

  group('deleteTrade', () {
    when(repository.delete(1)).thenAnswer((_) async {});
    final TradeData tradeData = TradeData(repository: repository);
    test('trades exist', () async {
      await tradeData.deleteTrade(1);
      final DateTime date = DateTime(2021, 1, 1);
      var result = tradeData.getTradesByDate(date);
      expect(result, isEmpty);
    });
  });
}
