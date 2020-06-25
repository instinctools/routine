import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class TodoUpdateState extends Equatable {
  const TodoUpdateState();

  @override
  List<Object> get props => [];
}

class TodoInitial extends TodoUpdateState {}

class TodosReceived extends TodoUpdateState {
  final Stream<QuerySnapshot> todos;

  const TodosReceived(this.todos);

  @override
  List<Object> get props => [todos];

  @override
  String toString() {
    return 'TodoReceived{todos: $todos}';
  }
}

class TodoUpdateSuccess extends TodoUpdateState {
  final Stream<QuerySnapshot> todos;

  const TodoUpdateSuccess(this.todos);

  @override
  List<Object> get props => [todos];

  @override
  String toString() {
    return 'TodoUpdateSuccess{todos: $todos}';
  }
}

class TodoUpdateFailure extends TodoUpdateState {
  final String error;

  const TodoUpdateFailure(this.error);

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'TodoUpdateFailure{error: $error}';
}
