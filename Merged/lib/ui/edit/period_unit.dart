enum PeriodUnit { DAY, WEEK, MONTH }

PeriodUnit findPeriodUnit(String value) => PeriodUnit.values.firstWhere((element) => element.name == value);

extension PeriodExt on PeriodUnit {
  static const periodNameMap = {
    PeriodUnit.DAY: 'DAY',
    PeriodUnit.WEEK: 'WEEK',
    PeriodUnit.MONTH: 'MONTH',
  };

  int get id => this.index;

  String get name => periodNameMap[this];
}
