import 'package:flutter/material.dart';
import 'package:money_kylin/constants.dart';

class TradeAppBar extends StatefulWidget with PreferredSizeWidget {
  final String title;

  const TradeAppBar({this.title});

  @override
  _TradeAppBarState createState() => _TradeAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _TradeAppBarState extends State<TradeAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(this.widget.title),
      centerTitle: true,
      backgroundColor: kPrimaryColor,
      elevation: 16,
    );
  }
}
