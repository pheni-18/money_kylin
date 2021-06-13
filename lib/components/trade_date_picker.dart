import 'package:flutter/material.dart';
import 'package:money_kylin/constants.dart';
import 'package:intl/intl.dart';

class TradeDatePicker extends StatelessWidget {
  final DateTime selectedDate;
  final Function onSelected;

  const TradeDatePicker({this.selectedDate, this.onSelected});

  Future<void> _selectDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
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
              color: kTextColor,
              fontSize: 16,
            ),
          ),
          IconButton(
            icon: Icon(Icons.date_range, color: kTextColor),
            onPressed: () => _selectDate(context),
          )
        ],
      ),
    );
  }
}
