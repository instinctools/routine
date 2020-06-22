import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:routine_flutter/data/todo.dart';
import 'package:routine_flutter/repository/mainRepository.dart';
import 'package:routine_flutter/ui/todo/todo_bloc/todo_event.dart';
import 'package:routine_flutter/ui/todo/todo_bloc/todo_state.dart';
import 'package:routine_flutter/utils/time_utils.dart';

class TodoBloc extends Bloc<TodoEvent, TodoUpdateState> {
  final MainRepository _mainRepository;

  TodoBloc({@required MainRepository mainRepository})
      : assert(mainRepository != null),
        _mainRepository = mainRepository;

  @override
  TodoUpdateState get initialState => TodoInitial();

  @override
  Stream<TodoUpdateState> mapEventToState(TodoEvent event) async* {
    if (event is TodoDelete) {
      yield* _mapTodoDeleteToState(event);
    } else if (event is TodoReset) {
      yield* _mapTodoResetToState(event);
    }
  }

  Stream<TodoUpdateState> _mapTodoDeleteToState(TodoDelete event) async* {
    try {
      await _mainRepository.deleteTodo(event.todo);
      yield TodoUpdateSuccess();
    } catch (error) {
      print("deleteTodo failure { error : $error}");
      yield TodoUpdateFailure(error.toString());
    }
  }

  Stream<TodoUpdateState> _mapTodoResetToState(TodoReset event) async* {
    try {
      Todo oldTodo = event.todo;
      Todo newTodo = TimeUtils.updateTargetDate(oldTodo);
      await _mainRepository.updateTodo(newTodo);
      yield TodoUpdateSuccess();
    } catch (error) {
      print("resetTodo failure { error : $error}");
      yield TodoUpdateFailure(error.toString());
    }
  }
}
