import 'package:flutter/material.dart';
import 'package:money_kylin/constants.dart';

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
