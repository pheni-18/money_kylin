import 'package:flutter/material.dart';
import 'package:money_kylin/constants.dart';
import 'package:intl/intl.dart';
import 'package:money_kylin/models/trade.dart';
import 'package:money_kylin/screens/add_trade_screen.dart';
import 'package:money_kylin/screens/edit_trade_screen.dart';
import 'package:provider/provider.dart';
import 'package:money_kylin/models/trade_data.dart';

class TradeListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MONEY KYLIN'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      body: MonthlyPage(),
      floatingActionButton: Container(
        height: 80.0,
        width: 80.0,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: kPrimaryColor,
            onPressed: () {
              Navigator.of(context).push(_createAddRoute());
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _TradeListBottomAppBar(),
    );
  }
}

class MonthlyPage extends StatefulWidget {
  @override
  _MonthlyPageState createState() => _MonthlyPageState();
}

class _MonthlyPageState extends State<MonthlyPage> {
  int year;
  int month;

  double delta = 0.0;

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    year = now.year;
    month = now.month;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        delta += details.delta.dx;
      },
      onHorizontalDragEnd: (details) {
        if (delta > 100.0) {
          setState(() {
            month -= 1;
            if (month == 0) {
              month = 12;
              year -= 1;
            }
          });
        } else if (delta < -100.0) {
          int m = month + 1;
          int y = year;
          if (m == 13) {
            m = 1;
            y += 1;
          }
          final DateTime now = DateTime.now();
          if (DateTime(y, m).isAfter(now)) {
            delta = 0.0;
            return;
          }
          setState(() {
            month = m;
            year = y;
          });
        }
        delta = 0.0;
      },
      child: Container(
        child: Column(
          children: <Widget>[
            MonthlyHeader(year: year, month: month),
            SizedBox(height: 10.0),
            Expanded(
              child: MonthlyTradesView(year: year, month: month),
            ),
          ],
        ),
      ),
    );
  }
}

class MonthlyHeader extends StatelessWidget {
  final int year;
  final int month;

  const MonthlyHeader({this.year, this.month});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final DateTime date = DateTime(this.year, this.month);

    return Material(
      elevation: 16,
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
                  DateFormat.MMM().format(date),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 60.0,
                  ),
                ),
                SizedBox(width: 10.0),
                Text(
                  DateFormat.y().format(date),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Consumer<TradeData>(
              builder: (context, tradeData, child) {
                final int monthlyAmount =
                    tradeData.monthlyAmount(this.year, this.month);
                return Text(
                  NumberFormat.simpleCurrency(locale: 'ja')
                      .format(monthlyAmount),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MonthlyTradesView extends StatelessWidget {
  final int year;
  final int month;

  const MonthlyTradesView({this.year, this.month});

  List<Widget> createMonthlyWidgets() {
    List<Widget> _monthlyWidgets = [];
    final DateTime _beginningDate = DateTime(this.year, this.month, 1);
    final DateTime _now = DateTime.now();
    final DateTime _today = DateTime(_now.year, _now.month, _now.day);
    for (int i = 30; i >= 0; i--) {
      DateTime _date = DateTime(
          _beginningDate.year, _beginningDate.month, _beginningDate.day + i);
      if (_date.month != this.month || _date.isAfter(_today)) {
        continue;
      }

      _monthlyWidgets.add(DayLabel(_date));
      _monthlyWidgets.add(DailyTradesList(_date));
    }
    return _monthlyWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
      child: Column(
        children: createMonthlyWidgets(),
      ),
    );
  }
}

class DailyTradesList extends StatelessWidget {
  final DateTime _date;

  const DailyTradesList(this._date);

  @override
  Widget build(BuildContext context) {
    return Consumer<TradeData>(
      builder: (context, tradeData, child) {
        List<Trade> trades = tradeData.getTradesByDate(_date);
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final trade = trades[index];
            return TradeCard(trade: trade);
          },
          itemCount: trades.length,
        );
      },
    );
  }
}

// TODO: commonalize create route method
Route _createAddRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => AddTradeScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final Offset begin = Offset(0.0, 1.0);
      final Offset end = Offset.zero;
      final Curve curve = Curves.ease;

      final Animatable<Offset> tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route _createEditRoute(Trade trade) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        EditTradeScreen(trade: trade),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class DayLabel extends StatelessWidget {
  final DateTime date;

  const DayLabel(this.date);

  @override
  Widget build(BuildContext context) {
    final String week = DateFormat('EEEE').format(this.date);
    return Container(
      margin: EdgeInsets.only(top: 30.0, bottom: 10.0),
      alignment: Alignment.centerLeft,
      child: Text(
        '${date.day} ($week)',
        style: TextStyle(
          color: kSecondaryColor,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class TradeCard extends StatelessWidget {
  final Trade trade;

  const TradeCard({this.trade});

  @override
  Widget build(BuildContext context) {
    Color amountColor;
    if (this.trade.type == '収入') {
      amountColor = Colors.blue;
    } else if (this.trade.type == '支出') {
      amountColor = Colors.red;
    } else if (this.trade.type == '貯蓄') {
      amountColor = Colors.teal;
    } else {
      print('Value Error');
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(_createEditRoute(this.trade));
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    this.trade.category,
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    this.trade.group,
                    style: TextStyle(
                      color: kLightTextColor,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                NumberFormat.simpleCurrency(locale: 'ja')
                    .format(this.trade.amount),
                style: TextStyle(
                  color: amountColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                  color: kPrimaryColor,
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
