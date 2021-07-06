import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:money_kylin/repositories/trade.dart';
import 'trade_data_controller_test.mocks.dart';
import 'package:money_kylin/models/trade_data_controller.dart';
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

  TradeDataController target;
  setUp(() async {
    final container = ProviderContainer(
      overrides: [
        tradeRepositoryProvider.overrideWithProvider(
          Provider((ref) => repository),
        ),
      ],
    );
    target = container.read(tradeDataProvider);
    await expectLater(
      target.stream.map((s) => s.trades).first,
      completion(isNotEmpty),
    );
  });

  group('addTrade', () {
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

      var dailyTrades = target.debugState.trades[date];
      expect(dailyTrades.length, 1);

      await target.addTrade(type, group, category, amount, date);
      dailyTrades = target.debugState.trades[date];
      expect(dailyTrades.length, 2);
    });

    test('no trade exist for the day', () async {
      final DateTime date = DateTime(2021, 1, 4);
      when(repository.insert(type, group, category, amount, date))
          .thenAnswer((_) async {
        return 4;
      });

      var dailyTrades = target.debugState.trades[date];
      expect(dailyTrades, isNull);

      await target.addTrade(type, group, category, amount, date);
      dailyTrades = target.debugState.trades[date];
      expect(dailyTrades.length, 1);
    });
  });

  group('updateTrade', () {
    final int id = 1;
    final String type = 'type12';
    final String group = 'group12';
    final String category = 'category12';
    final int amount = 1200;
    test('same date', () async {
      final DateTime date = DateTime(2021, 1, 1);
      when(repository.update(id, type, group, category, amount, date))
          .thenAnswer((_) async {});

      await target.updateTrade(id, type, group, category, amount, date);
      var dailyTrades = target.debugState.trades[date];
      expect(dailyTrades.length, 1);

      Trade trade = dailyTrades[0];
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
      await target.updateTrade(id, type, group, category, amount, date);
      var dailyTrades = target.debugState.trades[date];
      expect(dailyTrades.length, 1);

      Trade trade = dailyTrades[0];
      expect(trade.id, id);
      expect(trade.type, type);
      expect(trade.group, group);
      expect(trade.category, category);
      expect(trade.amount, amount);
      expect(trade.date, date);

      final DateTime oldDate = DateTime(2021, 1, 1);
      dailyTrades = target.debugState.trades[oldDate];
      expect(dailyTrades, isEmpty);
    });
  });

  group('deleteTrade', () {
    when(repository.delete(1)).thenAnswer((_) async {});
    test('trades exist', () async {
      await target.deleteTrade(1);
      final DateTime date = DateTime(2021, 1, 1);
      var dailyTrades = target.debugState.trades[date];
      expect(dailyTrades, isEmpty);
    });
  });
}
