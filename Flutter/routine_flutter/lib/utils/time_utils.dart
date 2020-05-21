import 'package:routine_flutter/ui/edit/period.dart';

class TimeUtils {
  static DateTime getCurrentTime() {
    DateTime current = DateTime.now();
    return DateTime(current.year, current.month, current.day).toUtc();
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
    print("month = $month, days = $day");
    return DateTime(now.year, now.month + month, now.day + day).toUtc();
  }

  static calculateTimeLeft(String targetDate) {
    DateTime target =
        DateTime.fromMillisecondsSinceEpoch(int.parse(targetDate), isUtc: true);
    DateTime now = getCurrentTime();
    var days = target.difference(now).inDays + 1;
    print("days = $days");
    String result = "";
    switch (days) {
      case -1:
        result = "Fuckuped";
        break;
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
    print("result = $result");
    return result;
  }
}
