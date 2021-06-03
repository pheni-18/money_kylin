import 'package:flutter/material.dart';
import 'package:money_kylin/constants.dart';

class ItemNameText extends StatelessWidget {
  final String name;

  const ItemNameText(this.name);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: Text(
        this.name,
        style: TextStyle(
          color: kSecondaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
