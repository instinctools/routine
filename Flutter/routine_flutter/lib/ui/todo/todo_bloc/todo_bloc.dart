import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:routine_flutter/data/todo.dart';
import 'package:routine_flutter/errors/action_result.dart';
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
    ActionResult actionResult = await _mainRepository.deleteTodo(event.todo);
    if (actionResult is ActionSuccess) {
      yield TodoUpdateSuccess();
    } else if (actionResult is ActionFailure) {
      yield TodoUpdateFailure(actionResult.message);
    }
  }

  Stream<TodoUpdateState> _mapTodoResetToState(TodoReset event) async* {
    Todo oldTodo = event.todo;
    Todo newTodo = TimeUtils.updateTargetDate(oldTodo);

    ActionResult actionResult = await _mainRepository.updateTodo(newTodo);
    if (actionResult is ActionSuccess) {
      yield TodoUpdateSuccess();
    } else if (actionResult is ActionFailure) {
      yield TodoUpdateFailure(actionResult.message);
    }
  }
}
