import 'package:flutter/material.dart';
import 'package:money_kylin/constants.dart';

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
