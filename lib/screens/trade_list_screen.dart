import 'package:flutter/material.dart';
import 'package:money_kylin/constants.dart';
import 'package:intl/intl.dart';

class TradeListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('MONEY KYLIN'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Material(
              elevation: 12,
              child: Container(
                height: size.height * 0.18,
                width: size.width,
                color: kPrimaryColor,
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: <Widget>[
                        Text(
                          'April',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 60.0,
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          '2021',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      '¥123,456',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 1,
                mainAxisSpacing: 10,
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                childAspectRatio: 5,
                children: <Widget>[
                  DayLabel(
                    day: 1,
                    week: 'Thu.',
                  ),
                  TradeCard(
                    type: '収入',
                    group: '固定収入',
                    name: '給料',
                    amount: 500000,
                  ),
                  TradeCard(
                    type: '支出',
                    group: '固定費',
                    name: '家賃',
                    amount: -100000,
                  ),
                  TradeCard(
                    type: '支出',
                    group: '変動費',
                    name: '外食費',
                    amount: -10000,
                  ),
                  DayLabel(
                    day: 2,
                    week: 'Fri.',
                  ),
                  TradeCard(
                    type: '支出',
                    group: '固定費',
                    name: '携帯代',
                    amount: -5000,
                  ),
                  DayLabel(
                    day: 3,
                    week: 'Sat.',
                  ),
                  TradeCard(
                    type: '貯蓄',
                    group: '定期貯金',
                    name: '貯金',
                    amount: -100000,
                  ),
                  TradeCard(
                    type: '支出',
                    group: '変動費',
                    name: '交通費',
                    amount: -3000,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 80.0,
        width: 80.0,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: kPrimaryColor,
            onPressed: () {},
            child: Icon(Icons.add),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _TradeListBottomAppBar(),
    );
  }
}

class DayLabel extends StatelessWidget {
  final int day;
  final String week;

  const DayLabel({this.day, this.week});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        '$day ($week)',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class TradeCard extends StatelessWidget {
  final String type;
  final String group;
  final String name;
  final int amount;

  TradeCard({this.type, this.group, this.name, this.amount});

  @override
  Widget build(BuildContext context) {
    Color amountColor;
    Color borderColor;
    if (this.type == '収入') {
      amountColor = Colors.blue[500];
      borderColor = Colors.blue[400];
    } else if (this.type == '支出') {
      amountColor = Colors.red[500];
      borderColor = Colors.red[400];
    } else if (this.type == '貯蓄') {
      amountColor = Colors.teal[500];
      borderColor = Colors.teal[400];
    } else {
      print('Value Error');
    }

    return Card(
      elevation: 2,
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: borderColor, width: 15.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                this.type,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(this.group,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  )),
              Text(this.name,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  )),
              Text(
                  NumberFormat.simpleCurrency(locale: 'ja').format(this.amount),
                  style: TextStyle(
                    color: amountColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _TradeListBottomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      color: Color(0xFFcfd8dc),
      child: IconTheme(
        data: IconThemeData(color: Colors.blueGrey[700]),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(
                  Icons.bar_chart,
                  size: 35.0,
                ),
                onPressed: () {},
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(
                  Icons.home,
                  size: 35.0,
                ),
                onPressed: () {},
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(
                  Icons.settings,
                  size: 35.0,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
