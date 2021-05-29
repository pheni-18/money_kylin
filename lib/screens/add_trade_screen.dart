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
  String group = '変動費';
  String category = '食料品費';
  int amount = 0;
  DateTime date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

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
                });
              },
              onTapExpense: () {
                setState(() {
                  type = '支出';
                });
              },
              onTapSaving: () {
                setState(() {
                  type = '貯蓄';
                });
              },
            ),
            SizedBox(height: 20.0),
            ItemNameText('Group'),
            ItemDropdown(
              dropdownValue: group,
              choices: <String>[
                '固定収入',
                '固定費',
                '変動費',
              ],
              onChanged: (String newGroup) {
                setState(() {
                  group = newGroup;
                });
              },
            ),
            SizedBox(height: 20.0),
            ItemNameText('Category'),
            ItemDropdown(
              dropdownValue: category,
              choices: <String>[
                '家賃',
                '生活用品費',
                '食料品費',
                '外食費',
                '通信費',
              ],
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
                    backgroundColor: Colors.blueGrey,
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
