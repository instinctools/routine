class Todo {
  final int _id;
  final String _title;
  final String _periodUnit;
  final int _periodValue;
  final int _timestamp;

  Todo(this._id, this._title, this._periodUnit, this._periodValue,
      this._timestamp);

  int get periodValue => _periodValue;

  String get title => _title;

  String get periodUnit => _periodUnit;

  int get id => _id;

  int get timestamp => _timestamp;

  @override
  String toString() {
    return """Todo{id = $id, 
    periodValue = $periodValue, 
    periodUnit = $periodUnit, 
    title = $title, 
    timestamp = $timestamp}""";
  }
}
