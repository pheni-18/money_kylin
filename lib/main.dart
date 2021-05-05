import 'package:flutter/material.dart';
import 'package:money_kylin/screens/trade_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:money_kylin/models/trade_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TradeData(),
      child: MaterialApp(
        home: TradeListScreen(),
      ),
    );
  }
}
