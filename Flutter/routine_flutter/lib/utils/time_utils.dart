import 'package:routine_flutter/ui/edit/resetType.dart';
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

  static DateTime updateTargetDate(String title, String periodUnit, int periodValue, ResetType resetType, int targetDate) {
    switch (resetType) {
      case ResetType.RESET_TO_PERIOD:
        return addPeriodToCurrentMoment(title, periodUnit, periodValue);
      case ResetType.RESET_TO_DATE:
        DateTime now = getCurrentTime();
        if (compareDateTimes(targetDate, now.millisecondsSinceEpoch) < 0) {
          // targetDate is gone. set now + period
          return addPeriodToCurrentMoment(title, periodUnit, periodValue);
        } else {
          DateTime targetDateTime = DateTime.fromMillisecondsSinceEpoch(targetDate, isUtc: false);
          var daysLeft = targetDateTime.difference(now).inDays;
          int day = 0;
          int month = 0;
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
          int periodInDays = day + month * 30;
          if (daysLeft <= periodInDays) {
            return DateTime(now.year, now.month + month, now.day + day + daysLeft);
          } else {
            //do nothing return the same targetDateTime
            return targetDateTime;
          }
        }
    }
    return getCurrentTime();
  }

  static DateTime addPeriodToCurrentMoment(String title, String periodUnit, int periodValue) {
    int day = 0;
    int month = 0;
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
    DateTime now = getCurrentTime();
    return DateTime(now.year, now.month + month, now.day + day);
  }

  static String calculateTimeLeft(int targetDate) {
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

  static int compareDateTimes(int first, int second) {
    var firstDate = DateTime.fromMillisecondsSinceEpoch(first);
    var secondDate = DateTime.fromMillisecondsSinceEpoch(second);
    return firstDate.compareTo(secondDate);
  }
}
