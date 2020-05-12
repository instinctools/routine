enum Period { DAY, WEEK, MONTH }

extension PeriodExt on Period {
  static const periodNameMap = {
    Period.DAY: 'day',
    Period.WEEK: 'week',
    Period.MONTH: 'month'
  };

  int get id => this.index;

  String get name => periodNameMap[this];
}
