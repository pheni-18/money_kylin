import 'package:flutter/material.dart';
import 'package:money_kylin/constants.dart';

class TradeScreen extends StatelessWidget {
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
            ItemNameText('Type'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TradeTypeCard(
                  iconData: Icons.monetization_on_outlined,
                  typeName: '収入',
                  isSelected: true,
                ),
                TradeTypeCard(
                  iconData: Icons.payments_outlined,
                  typeName: '支出',
                  isSelected: false,
                ),
                TradeTypeCard(
                  iconData: Icons.save_outlined,
                  typeName: '貯蓄・投資',
                  isSelected: false,
                ),
              ],
            ),
            SizedBox(height: 20.0),
            ItemNameText('Group'),
            ItemDropdown(
              initValue: '変動費',
              choices: <String>[
                '固定収入',
                '固定費',
                '変動費',
              ],
            ),
            SizedBox(height: 20.0),
            ItemNameText('Category'),
            ItemDropdown(
              initValue: '食料品費',
              choices: <String>[
                '家賃',
                '生活用品費',
                '食料品費',
                '外食費',
                '通信費',
              ],
            ),
            SizedBox(height: 20.0),
            ItemNameText('Amount'),
            TextField(
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
            ),
            SizedBox(height: 50.0),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 150, height: 60),
              child: ElevatedButton(
                onPressed: () {},
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

class ItemDropdown extends StatefulWidget {
  final String initValue;
  final List<String> choices;

  const ItemDropdown({this.initValue, this.choices});

  @override
  _ItemDropdownState createState() => _ItemDropdownState();
}

class _ItemDropdownState extends State<ItemDropdown> {
  String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      isExpanded: true,
      elevation: 12,
      style: TextStyle(
        color: Colors.grey[700],
      ),
      underline: Container(
        height: 2.0,
        color: kPrimaryColor,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: widget.choices.map<DropdownMenuItem<String>>((String value) {
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

  const TradeTypeCard({this.iconData, this.typeName, this.isSelected});

  @override
  Widget build(BuildContext context) {
    Color colour = isSelected ? kPrimaryColor : Colors.grey[400];

    return GestureDetector(
      onTap: () {},
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
