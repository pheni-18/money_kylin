import 'package:money_kylin/database_helper.dart';
import 'package:money_kylin/models/trade.dart';
import 'package:intl/intl.dart';

class TradeRepository {
  final dbHelper = DatabaseHelper.instance;
  final dateFormat = 'y-M-d';

  Trade _toTrade(Map<String, dynamic> row) {
    DateTime date =
        DateFormat(dateFormat).parseStrict(row[DatabaseHelper.columnDate]);

    return Trade(
      row[DatabaseHelper.columnId],
      row[DatabaseHelper.columnType],
      row[DatabaseHelper.columnGroup],
      row[DatabaseHelper.columnCategory],
      row[DatabaseHelper.columnAmount],
      date,
    );
  }

  Map<String, dynamic> _toRow(Trade trade) {
    String formattedDate = DateFormat(dateFormat).format(trade.date);

    return {
      DatabaseHelper.columnId: trade.id,
      DatabaseHelper.columnType: trade.type,
      DatabaseHelper.columnGroup: trade.group,
      DatabaseHelper.columnCategory: trade.category,
      DatabaseHelper.columnAmount: trade.amount,
      DatabaseHelper.columnDate: formattedDate,
    };
  }

  Future<int> insert(String type, String group, String category, int amount,
      DateTime date) async {
    String formattedDate = DateFormat(dateFormat).format(date);

    Map<String, dynamic> row = {
      DatabaseHelper.columnType: type,
      DatabaseHelper.columnGroup: group,
      DatabaseHelper.columnCategory: category,
      DatabaseHelper.columnAmount: amount,
      DatabaseHelper.columnDate: formattedDate,
    };
    final int id = await dbHelper.insert(row);
    return id;
  }

  Future<List<Trade>> findAll() async {
    final List<Map<String, dynamic>> allRows = await dbHelper.findAll();
    List<Trade> trades = [];
    for (Map<String, dynamic> row in allRows) {
      trades.add(_toTrade(row));
    }

    return trades;
  }

  Future<Trade> find(int id) async {
    Map<String, dynamic> row = await dbHelper.find(id);
    return _toTrade(row);
  }

  void update(int id, String type, String group, String category, int amount,
      DateTime date) async {
    Trade oldTrade = await find(id);
    Map<String, dynamic> row = _toRow(oldTrade);
    if (type != oldTrade.type) {
      row[DatabaseHelper.columnType] = type;
    }
    if (group != oldTrade.group) {
      row[DatabaseHelper.columnGroup] = group;
    }
    if (category != oldTrade.category) {
      row[DatabaseHelper.columnCategory] = category;
    }
    if (amount != oldTrade.amount) {
      row[DatabaseHelper.columnAmount] = amount;
    }
    if (date != oldTrade.date) {
      String formattedDate = DateFormat(dateFormat).format(date);
      row[DatabaseHelper.columnDate] = formattedDate;
    }

    await dbHelper.update(row);
  }

  void delete(int id) async {
    await dbHelper.delete(id);
  }
}
