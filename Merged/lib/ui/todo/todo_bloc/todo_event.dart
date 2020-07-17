import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:routine_flutter/data/todo.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class GetTodos extends TodoEvent {}

class TodoDelete extends TodoEvent {
  final Todo todo;

  const TodoDelete({@required this.todo});

  @override
  List<Object> get props => [todo];

  @override
  String toString() {
    return 'TodoDelete{todo: $todo}';
  }
}

class TodoReset extends TodoEvent {
  final Todo todo;

  const TodoReset({@required this.todo});

  @override
  List<Object> get props => [todo];

  @override
  String toString() {
    return 'TodoReset{todo: $todo}';
  }
}
