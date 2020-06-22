import 'package:equatable/equatable.dart';

abstract class TodoUpdateState extends Equatable {
  const TodoUpdateState();

  @override
  List<Object> get props => [];
}

class TodoInitial extends TodoUpdateState {}

class TodoUpdateSuccess extends TodoUpdateState {}

class TodoUpdateFailure extends TodoUpdateState {
  final String error;

  const TodoUpdateFailure(this.error);

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'TodoUpdateFailure{error: $error}';
}
