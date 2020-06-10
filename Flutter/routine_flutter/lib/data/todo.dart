import 'package:routine_flutter/ui/edit/ResetType.dart';
import 'package:routine_flutter/utils/time_utils.dart';

import 'db_helper.dart';

class Todo {
  final int id;
  final String title;
  final String periodUnit;
  final int periodValue;
  final int targetDate;
  final ResetType resetType;

  Todo({this.id, this.title, this.periodUnit, this.periodValue, this.targetDate, this.resetType});

  factory Todo.fromMap(Map<String, dynamic> map) => Todo(
        id: map[COLUMN_ID],
        title: map[COLUMN_TITLE],
        periodUnit: map[COLUMN_UNIT],
        periodValue: map[COLUMN_VALUE],
        targetDate: map[COLUMN_TARGET_DATE],
        resetType: findResetType(map[COLUMN_RESET_TYPE]),
      );

  Map<String, dynamic> toMap() => {
        COLUMN_ID: id,
        COLUMN_TITLE: title,
        COLUMN_UNIT: periodUnit,
        COLUMN_VALUE: periodValue,
        COLUMN_TARGET_DATE: targetDate,
        COLUMN_RESET_TYPE: resetType.value,
      };

  Todo shiftTargetTime() => Todo(
        id: this.id,
        title: this.title,
        periodUnit: this.periodUnit,
        periodValue: this.periodValue,
        targetDate: TimeUtils.calculateTargetDate(title, periodUnit, periodValue, true).millisecondsSinceEpoch,
        resetType: this.resetType,
      );

  @override
  String toString() {
    return """Todo{id = $id, 
    periodValue = $periodValue, 
    periodUnit = $periodUnit, 
    title = $title, 
    targetDate = $targetDate,
    resetType = $resetType}""";
  }
}
