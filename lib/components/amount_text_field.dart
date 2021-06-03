import 'package:flutter/material.dart';
import 'package:money_kylin/constants.dart';

class AmountTextField extends StatefulWidget {
  final int initAmount;
  final Function onChanged;

  const AmountTextField({this.initAmount, this.onChanged});

  @override
  _AmountTextFieldState createState() => _AmountTextFieldState();
}

class _AmountTextFieldState extends State<AmountTextField> {
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController =
        TextEditingController(text: widget.initAmount.toString());
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textEditingController,
      style: TextStyle(
        color: kTextColor,
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
      onChanged: this.widget.onChanged,
    );
  }
}
