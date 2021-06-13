import 'package:flutter/material.dart';
import 'package:money_kylin/screens/trade_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:money_kylin/models/trade_data.dart';
import 'package:money_kylin/repositories/trade.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final TradeRepository repository = TradeRepository();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TradeData(repository: repository),
      child: MaterialApp(
        home: TradeListScreen(),
      ),
    );
  }
}
