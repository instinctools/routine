import 'package:flutter/material.dart';
import 'package:routine_flutter/ui/todo/todolist.dart';

void main() =>runApp(RoutineApp());

class RoutineApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoList(),
    );
  }
}
