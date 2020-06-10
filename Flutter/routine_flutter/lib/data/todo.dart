import 'package:routine_flutter/ui/edit/ResetType.dart';
import 'package:routine_flutter/utils/time_utils.dart';

import 'db_helper.dart';

class Todo {
  final int id;
  final String title;
  final String periodUnit;
  final int periodValue;
  final int targetTime;
  final ResetType resetType;

  Todo({this.id, this.title, this.periodUnit, this.periodValue, this.targetTime, this.resetType});

  factory Todo.fromMap(Map<String, dynamic> map) => Todo(
        id: map[COLUMN_ID],
        title: map[COLUMN_TITLE],
        periodUnit: map[COLUMN_UNIT],
        periodValue: map[COLUMN_VALUE],
        targetTime: map[COLUMN_TARGET_TIME],
        resetType: findResetType(map[COLUMN_RESET_TYPE]),
      );

  Map<String, dynamic> toMap() => {
        COLUMN_ID: id,
        COLUMN_TITLE: title,
        COLUMN_UNIT: periodUnit,
        COLUMN_VALUE: periodValue,
        COLUMN_TARGET_TIME: targetTime,
        COLUMN_RESET_TYPE: resetType.value,
      };

  Todo shiftTargetTime() => Todo(
        id: this.id,
        title: this.title,
        periodUnit: this.periodUnit,
        periodValue: this.periodValue,
        targetTime: TimeUtils.calculateTargetTime(this.title, this.periodUnit, this.periodValue, true).millisecondsSinceEpoch,
        resetType: this.resetType,
      );

  @override
  String toString() {
    return """Todo{id = $id, 
    periodValue = $periodValue, 
    periodUnit = $periodUnit, 
    title = $title, 
    targetTime = $targetTime,
    resetType = $resetType}""";
  }
}
