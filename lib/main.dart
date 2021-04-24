import 'package:flutter/material.dart';
import 'package:money_kylin/screens/trade_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TradeListScreen(),
    );
  }
}
