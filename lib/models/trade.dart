class Trade {
  final int _id;
  String _type;
  String _group;
  String _category;
  int _amount;
  DateTime _date;

  Trade(this._id, this._type, this._group, this._category, this._amount,
      this._date);

  int get id => this._id;
  String get type => this._type;
  String get group => this._group;
  String get category => this._category;
  int get amount => this._amount;
  DateTime get date => this._date;

  set type(String s) {
    this._type = s;
  }

  set group(String s) {
    this._group = s;
  }

  set category(String s) {
    this._category = s;
  }

  set amount(int n) {
    this._amount = n;
  }

  set date(DateTime d) {
    this._date = d;
  }
}
