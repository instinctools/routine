enum Period { DAY, WEEK, MONTH }

Period findPeriod(String value) =>
    Period.values.firstWhere((element) => element.name == value);

extension PeriodExt on Period {
  static const periodNameMap = {
    Period.DAY: 'day',
    Period.WEEK: 'week',
    Period.MONTH: 'month'
  };

  int get id => this.index;

  String get name => periodNameMap[this];
}
