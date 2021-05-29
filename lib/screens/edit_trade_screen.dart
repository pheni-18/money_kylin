import 'package:flutter/material.dart';
import 'package:money_kylin/components/trade_type.dart';
import 'package:money_kylin/components/item_dropdown.dart';
import 'package:money_kylin/components/item_name_text.dart';
import 'package:money_kylin/components/amount_text_field.dart';
import 'package:money_kylin/components/trade_date_picker.dart';
import 'package:money_kylin/components/trade_app_bar.dart';
import 'package:money_kylin/models/trade.dart';
import 'package:money_kylin/constants.dart';
import 'package:provider/provider.dart';
import 'package:money_kylin/models/trade_data.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditTradeScreen extends StatefulWidget {
  final Trade trade;

  EditTradeScreen({this.trade});

  @override
  _EditTradeScreenState createState() => _EditTradeScreenState();
}

class _EditTradeScreenState extends State<EditTradeScreen> {
  String type;
  String group;
  String category;
  int amount;
  DateTime date;

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
              constraints: BoxConstraints.tightFor(height: 60),
              child: ElevatedButton(
                onPressed: () {
                  if (type == '支出' || type == '貯蓄') {
                    amount *= -1;
                  }
                  Provider.of<TradeData>(context).updateTrade(
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
            SizedBox(height: 20.0),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(height: 60),
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<TradeData>(context)
                      .deleteTrade(this.widget.trade.id);
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                    msg: '💥 Trade deleted!',
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.blueGrey,
                    timeInSecForIosWeb: 1,
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red[300],
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
