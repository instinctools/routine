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

    return '$periodCount$periodUnit$pluralPostfix';
  }

  static DateTime calculateTargetDate(String title, String periodUnit, int periodValue, [bool isReset = false]) {
    DateTime now = getCurrentTime();
    int day = 0, month = 0;
    switch (findPeriod(periodUnit)) {
      case Period.DAY:
        day = periodValue;
        break;
      case Period.WEEK:
        day = periodValue * 7;
        break;
      case Period.MONTH:
        month = periodValue;
        break;
    }

    if (!isReset && title.contains("exp")) {
      print("expired = $title");
      return DateTime(now.year, now.month, now.day - 1);
    }
    return DateTime(now.year, now.month + month, now.day + day);
  }

  static calculateTimeLeft(int targetDate) {
    DateTime target = DateTime.fromMillisecondsSinceEpoch(targetDate, isUtc: false);
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
