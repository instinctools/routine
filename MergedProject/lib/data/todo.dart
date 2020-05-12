import 'db_helper.dart';

class Todo {
  final int id;
  final String title;
  final String periodUnit;
  final int periodValue;
  final int timestamp;

  Todo(
      {this.id, this.title, this.periodUnit, this.periodValue, this.timestamp});

  factory Todo.fromMap(Map<String, dynamic> map) => Todo(
      id: map[COLUMN_ID],
      title: map[COLUMN_TITLE],
      periodUnit: map[COLUMN_UNIT],
      periodValue: map[COLUMN_VALUE],
      timestamp: map[COLUMN_TIMESTAMP]);

  Map<String, dynamic> toMap() => {
        COLUMN_ID: id,
        COLUMN_TITLE: title,
        COLUMN_UNIT: periodUnit,
        COLUMN_VALUE: periodValue,
        COLUMN_TIMESTAMP: timestamp
      };

  @override
  String toString() {
    return """Todo{id = $id, 
    periodValue = $periodValue, 
    periodUnit = $periodUnit, 
    title = $title, 
    timestamp = $timestamp}""";
  }
}
