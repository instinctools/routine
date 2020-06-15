import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:routine_flutter/ui/edit/ResetType.dart';

class NewTodo {
  String id;
  String title;
  String periodUnit;
  int periodValue;
  int targetDate;
  ResetType resetType;

  NewTodo(this.id, this.title, this.periodUnit, this.periodValue, this.targetDate, this.resetType);
}

class Todo {
  final String id;
  final String title;
  final String periodUnit;
  final int periodValue;
  final int targetDate;
  final ResetType resetType;
  final DocumentReference reference;

  Todo(this.id, this.title, this.periodUnit, this.periodValue, this.targetDate, this.resetType, this.reference);

  /* factory Todo.fromMap(Map<String, dynamic> map) =>
      Todo(
        id: map[COLUMN_ID],
        title: map[COLUMN_TITLE],
        periodUnit: map[COLUMN_UNIT],
        periodValue: map[COLUMN_VALUE],
        targetDate: map[COLUMN_TARGET_DATE],
        resetType: findResetType(map[COLUMN_RESET_TYPE]),
      );

  Map<String, dynamic> toMap() =>
      {
        COLUMN_ID: id,
        COLUMN_TITLE: title,
        COLUMN_UNIT: periodUnit,
        COLUMN_VALUE: periodValue,
        COLUMN_TARGET_DATE: targetDate,
        COLUMN_RESET_TYPE: resetType.value,
      };*/

/*
  Todo resetTargetDate() => Todo(
        id,
        title,
        periodUnit,
        periodValue,
        TimeUtils.updateTargetDate(title, periodUnit, periodValue, resetType, targetDate).millisecondsSinceEpoch,
        resetType,
      );
*/

  @override
  String toString() {
    return """Todo{id = $id, 
    periodValue = $periodValue, 
    periodUnit = $periodUnit, 
    title = $title, 
    targetDate = $targetDate,
    resetType = $resetType}""";
  }

  static fromSnapshot(Map<String, dynamic> data) {}

  Todo.fromDocumentSnapshotMap(Map<String, dynamic> map, {this.reference})
      :
//        assert(map['id'] != null),
//        assert(map['periodUnit'] != null),
        id = map['id'],
        title = map['title'],
        periodUnit = map['periodUnit'],
        targetDate = ((map['timestamp']) as Timestamp).millisecondsSinceEpoch,
        periodValue = map['period'],
        resetType = ResetType.RESET_TO_DATE;

  Todo.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) : this.fromDocumentSnapshotMap(documentSnapshot.data, reference: documentSnapshot.reference);
}
