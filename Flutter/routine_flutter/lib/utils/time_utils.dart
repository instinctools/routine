import 'package:routine_flutter/ui/edit/period.dart';

class TimeUtils {
  static DateTime getCurrentTime() {
    DateTime current = DateTime.now();
    return DateTime(current.year, current.month, current.day);
  }

  static int getCurrentTimeMillis() => getCurrentTime().millisecondsSinceEpoch;

  static String getPrettyPeriod(String periodUnit, [int periodValue = 1]) {
    var isPlural = periodValue > 1;
    var periodCount = isPlural ? '$periodValue ' : '';
    var pluralPostfix = isPlural && periodUnit != Period.MONTH.name ? 's' : '';

    return 'Every $periodCount$periodUnit$pluralPostfix';
  }

  static DateTime calculateTargetTime(String unit, int value) {
    DateTime now = getCurrentTime();
    int day = 0, month = 0;
    switch (findPeriod(unit)) {
      case Period.DAY:
        day = value;
        break;
      case Period.WEEK:
        day = value * 7;
        break;
      case Period.MONTH:
        month = value;
        break;
    }
    return DateTime(now.year, now.month + month, now.day + day);
  }

  static calculateTimeLeft(String targetDate) {
    DateTime target = DateTime.fromMillisecondsSinceEpoch(int.parse(targetDate),
        isUtc: false);
    DateTime now = getCurrentTime();
    var days = target.difference(now).inDays;
    String result = "";
    switch (days) {
      case 0:
        result = "Today";
        break;
      case 1:
        result = "Tomorrow";
        break;
      case 7:
        result = "One week left";
        break;
      default:
        if (days > 1 && days < 7) {
          result = "$days days left";
        }
    }
    return result;
  }

  static int compareTargetDates(int first, int second) {
    var firstDate = DateTime.fromMillisecondsSinceEpoch(first);
    var secondDate = DateTime.fromMillisecondsSinceEpoch(second);
    return firstDate.compareTo(secondDate);
  }
}
