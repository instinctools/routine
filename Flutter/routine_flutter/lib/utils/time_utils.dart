import 'package:routine_flutter/ui/edit/period.dart';

class TimeUtils {
  static int getCurrentTime() {
    DateTime current = DateTime.now();
    return DateTime(current.year, current.month, current.day)
        .millisecondsSinceEpoch;
  }

  static String getPrettyPeriod(Period periodUnit, int periodValue) {
    var isPlural = periodValue > 1;
    var periodCount = isPlural ? '$periodValue ' : '';
    var pluralPostfix = isPlural && periodUnit != Period.MONTH ? 's' : '';

    return 'Every $periodCount${periodUnit.name}$pluralPostfix';
  }
}
