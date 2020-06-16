import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:routine_flutter/ui/edit/resetType.dart';
import 'package:routine_flutter/utils/consts.dart';

class Todo {
  final String id;
  final String title;
  final String periodUnit;
  final int periodValue;
  final int targetDate; //MillisecondsSinceEpoch
  final ResetType resetType;
  final DocumentReference reference;

  Todo(this.id, this.title, this.periodUnit, this.periodValue, this.targetDate, this.resetType, [this.reference]);

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> values = {
      Strings.todoKeyId: id,
      Strings.todoKeyPeriod: periodValue,
      Strings.todoKeyPeriodUnit: periodUnit,
      Strings.todoKeyResetType: resetType.value,
      Strings.todoKeyTimestamp: Timestamp.fromMillisecondsSinceEpoch(targetDate),
      Strings.todoKeyTitle: title,
    };
    return values;
  }

  @override
  String toString() {
    return """Todo{id = $id, 
    periodValue = $periodValue, 
    periodUnit = $periodUnit, 
    title = $title, 
    targetDate = $targetDate,
    reference = $reference,
    resetType = $resetType}""";
  }

  Todo.updateTargetDate(Todo todo, int newTargetDate)
      : id = todo.id,
        periodValue = todo.periodValue,
        periodUnit = todo.periodUnit,
        resetType = todo.resetType,
        targetDate = newTargetDate,
        title = todo.title,
        reference = todo.reference;

  Todo.fromDocumentSnapshotMap(Map<String, dynamic> map, {this.reference})
      : assert(map[Strings.todoKeyId] != null),
        assert(map[Strings.todoKeyPeriod] != null),
        assert(map[Strings.todoKeyPeriodUnit] != null),
        assert(map[Strings.todoKeyResetType] != null),
        assert(map[Strings.todoKeyTimestamp] != null),
        assert(map[Strings.todoKeyTitle] != null),
        id = map[Strings.todoKeyId],
        periodValue = map[Strings.todoKeyPeriod],
        periodUnit = map[Strings.todoKeyPeriodUnit],
        resetType = findResetType(map[Strings.todoKeyResetType]),
        targetDate = ((map[Strings.todoKeyTimestamp]) as Timestamp).millisecondsSinceEpoch,
        title = map[Strings.todoKeyTitle];

  Todo.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) : this.fromDocumentSnapshotMap(documentSnapshot.data, reference: documentSnapshot.reference);
}
