import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:routine_flutter/data/todo.dart';

abstract class EditScreenEvent extends Equatable {
  const EditScreenEvent();

  @override
  List<Object> get props => [];
}

class EditScreenTitleTodoChanged extends EditScreenEvent {
  final String titleTodo;

  const EditScreenTitleTodoChanged({@required this.titleTodo});

  @override
  List<Object> get props => [titleTodo];

  @override
  String toString() {
    return 'EditScreenTitleTodoChanged{titleTodo: $titleTodo}';
  }
}

class CancelPressed extends EditScreenEvent {}

class DonePressed extends EditScreenEvent {
  final Todo todo;

  const DonePressed({@required this.todo});

  @override
  List<Object> get props => [todo];

  @override
  String toString() {
    return 'DonePressed{todo: $todo}';
  }
}
