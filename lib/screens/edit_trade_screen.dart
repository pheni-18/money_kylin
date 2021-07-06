import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:money_kylin/components/trade_type.dart';
import 'package:money_kylin/components/item_dropdown.dart';
import 'package:money_kylin/components/item_name_text.dart';
import 'package:money_kylin/components/amount_text_field.dart';
import 'package:money_kylin/components/trade_date_picker.dart';
import 'package:money_kylin/components/trade_app_bar.dart';
import 'package:money_kylin/models/trade.dart';
import 'package:money_kylin/constants.dart';
import 'package:money_kylin/models/trade_data_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditTradeScreen extends StatefulWidget {
  final Trade trade;

  const EditTradeScreen({this.trade});

  @override
  _EditTradeScreenState createState() => _EditTradeScreenState();
}

class _EditTradeScreenState extends State<EditTradeScreen> {
  String type;
  String group;
  String category;
  int amount;
  DateTime date;

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
  void initState() {
    super.initState();
    type = this.widget.trade.type;
    group = this.widget.trade.group;
    category = this.widget.trade.category;
    amount = this.widget.trade.amount.abs();
    date = this.widget.trade.date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TradeAppBar(title: 'Edit Trade'),
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
              constraints: BoxConstraints.tightFor(height: 60),
              child: ElevatedButton(
                onPressed: () async {
                  if (type == '支出' || type == '貯蓄') {
                    amount *= -1;
                  }
                  await context.read(tradeDataProvider).updateTrade(
                      this.widget.trade.id,
                      type,
                      group,
                      category,
                      amount,
                      date);
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                    msg: '💫 Trade edited!',
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
            SizedBox(height: 20.0),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(height: 60),
              child: ElevatedButton(
                onPressed: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text(
                        'Delete',
                        style: TextStyle(color: kSecondaryColor),
                      ),
                      content: const Text(
                        'Are you sure you want to delete this trade?',
                        style: TextStyle(
                          color: kTextColor,
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: kLightTextColor,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context, 'Delete');
                            await context
                                .read(tradeDataProvider)
                                .deleteTrade(this.widget.trade.id);
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                              msg: '💥 Trade deleted!',
                              gravity: ToastGravity.CENTER,
                              backgroundColor: kSecondaryColor,
                              timeInSecForIosWeb: 1,
                            );
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                              color: kCautionColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: kCautionColor,
                  elevation: 8.0,
                ),
                child: Text('Delete'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
