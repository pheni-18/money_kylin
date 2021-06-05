import 'package:flutter/material.dart';
import 'package:money_kylin/components/trade_type.dart';
import 'package:money_kylin/components/item_dropdown.dart';
import 'package:money_kylin/components/item_name_text.dart';
import 'package:money_kylin/components/amount_text_field.dart';
import 'package:money_kylin/components/trade_date_picker.dart';
import 'package:money_kylin/components/trade_app_bar.dart';
import 'package:money_kylin/constants.dart';
import 'package:provider/provider.dart';
import 'package:money_kylin/models/trade_data.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTradeScreen extends StatefulWidget {
  @override
  _AddTradeScreenState createState() => _AddTradeScreenState();
}

class _AddTradeScreenState extends State<AddTradeScreen> {
  String type = '収入';
  String group = '固定収入';
  String category = '給料';
  int amount = 0;
  DateTime date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  final Map<String, List<String>> groupChoices = {
    '収入': [
      '固定収入',
    ],
    '支出': ['固定費', '変動費'],
    '貯蓄': [
      '定期貯金',
    ]
  };

  final Map<String, List<String>> categoryChoices = {
    '固定収入': [
      '給料',
    ],
    '固定費': [
      '家賃',
      '水道光熱費',
      '通信費',
    ],
    '変動費': [
      '食費',
      '外食費',
      '交通費',
      '生活用品',
      '雑費',
    ],
    '定期貯金': [
      '現金貯金',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TradeAppBar(title: 'Add Trade'),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ItemNameText('Date'),
            TradeDatePicker(
              selectedDate: date,
              onSelected: (DateTime newDate) {
                setState(() {
                  date = newDate;
                });
              },
            ),
            SizedBox(height: 20.0),
            ItemNameText('Type'),
            TradeTypeRow(
              selectedType: type,
              onTapIncome: () {
                setState(() {
                  type = '収入';
                  group = groupChoices[type][0];
                  category = categoryChoices[group][0];
                });
              },
              onTapExpense: () {
                setState(() {
                  type = '支出';
                  group = groupChoices[type][0];
                  category = categoryChoices[group][0];
                });
              },
              onTapSaving: () {
                setState(() {
                  type = '貯蓄';
                  group = groupChoices[type][0];
                  category = categoryChoices[group][0];
                });
              },
            ),
            SizedBox(height: 20.0),
            ItemNameText('Group'),
            ItemDropdown(
              dropdownValue: group,
              choices: groupChoices[type],
              onChanged: (String newGroup) {
                setState(() {
                  group = newGroup;
                  category = categoryChoices[group][0];
                });
              },
            ),
            SizedBox(height: 20.0),
            ItemNameText('Category'),
            ItemDropdown(
              dropdownValue: category,
              choices: categoryChoices[group],
              onChanged: (String newCategory) {
                setState(() {
                  category = newCategory;
                });
              },
            ),
            SizedBox(height: 20.0),
            ItemNameText('Amount'),
            AmountTextField(
              initAmount: amount,
              onChanged: (String newAmount) {
                setState(() {
                  amount = int.parse(newAmount);
                });
              },
            ),
            SizedBox(height: 50.0),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 150, height: 60),
              child: ElevatedButton(
                onPressed: () {
                  if (type == '支出' || type == '貯蓄') {
                    amount *= -1;
                  }
                  Provider.of<TradeData>(context)
                      .addTrade(type, group, category, amount, date);
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                    msg: '🚀 A new trade created!',
                    gravity: ToastGravity.CENTER,
                    backgroundColor: kSecondaryColor,
                    timeInSecForIosWeb: 1,
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: kPrimaryColor,
                  elevation: 8.0,
                ),
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
