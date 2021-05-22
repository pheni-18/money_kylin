import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_kylin/constants.dart';
import 'package:provider/provider.dart';
import 'package:money_kylin/models/trade_data.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TradeScreen extends StatefulWidget {
  @override
  _TradeScreenState createState() => _TradeScreenState();
}

class _TradeScreenState extends State<TradeScreen> {
  String type = '収入';
  String group = '変動費';
  String category = '食料品費';
  int amount = 0;
  DateTime date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Trade'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        elevation: 16,
      ),
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
                    msg: '🚀 A new task created!',
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

class AmountTextField extends StatelessWidget {
  final Function onChanged;

  const AmountTextField({this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(
        color: Colors.grey[700],
      ),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 2.0,
            color: kPrimaryColor,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 2.0,
            color: kPrimaryColor,
          ),
        ),
      ),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      onChanged: this.onChanged,
    );
  }
}

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

class TradeDatePicker extends StatelessWidget {
  final DateTime selectedDate;
  final Function onSelected;

  TradeDatePicker({this.selectedDate, this.onSelected});

  Future<void> _selectDate(BuildContext context) async {
    DateTime selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: kPrimaryColor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    if (selected != null) {
      this.onSelected(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: kPrimaryColor,
            width: 2.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            DateFormat.yMMMMd().format(selectedDate),
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
            ),
          ),
          IconButton(
            icon: Icon(Icons.date_range, color: Colors.grey[700]),
            onPressed: () => _selectDate(context),
          )
        ],
      ),
    );
  }
}

class ItemDropdown extends StatelessWidget {
  final String dropdownValue;
  final List<String> choices;
  final Function onChanged;

  const ItemDropdown({this.dropdownValue, this.choices, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: this.dropdownValue,
      isExpanded: true,
      elevation: 12,
      style: TextStyle(
        color: Colors.grey[700],
      ),
      underline: Container(
        height: 2.0,
        color: kPrimaryColor,
      ),
      onChanged: this.onChanged,
      items: this.choices.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

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
          color: Colors.blueGrey[500],
          fontWeight: FontWeight.bold,
        ),
      ),
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
