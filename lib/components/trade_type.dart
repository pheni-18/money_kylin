import 'package:flutter/material.dart';
import 'package:money_kylin/constants.dart';

class TradeTypeRow extends StatelessWidget {
  final String selectedType;
  final Function onTapIncome;
  final Function onTapExpense;
  final Function onTapSaving;

  TradeTypeRow(
      {this.selectedType,
      this.onTapIncome,
      this.onTapExpense,
      this.onTapSaving});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        TradeTypeCard(
          iconData: Icons.monetization_on_outlined,
          typeName: '収入',
          isSelected: selectedType == '収入',
          onTap: onTapIncome,
        ),
        TradeTypeCard(
          iconData: Icons.payments_outlined,
          typeName: '支出',
          isSelected: selectedType == '支出',
          onTap: onTapExpense,
        ),
        TradeTypeCard(
          iconData: Icons.save_outlined,
          typeName: '貯蓄',
          isSelected: selectedType == '貯蓄',
          onTap: onTapSaving,
        ),
      ],
    );
  }
}

class TradeTypeCard extends StatelessWidget {
  final IconData iconData;
  final String typeName;
  final bool isSelected;
  final Function onTap;

  const TradeTypeCard(
      {this.iconData, this.typeName, this.isSelected, this.onTap});

  @override
  Widget build(BuildContext context) {
    Color colour = isSelected ? kPrimaryColor : Colors.grey[400];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100.0,
        width: 100.0,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2.0,
            color: colour,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              this.iconData,
              size: 60.0,
              color: colour,
            ),
            Text(
              this.typeName,
              style: TextStyle(
                color: colour,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
