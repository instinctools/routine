import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:routine_flutter/data/todo.dart';
import 'package:routine_flutter/repository/mainRepository.dart';
import 'package:routine_flutter/ui/todo/todo_bloc/todo_event.dart';
import 'package:routine_flutter/ui/todo/todo_bloc/todo_state.dart';
import 'package:routine_flutter/utils/consts.dart';
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
    if (event is GetTodos) {
      yield* _mapGetTodosToState();
    } else if (event is TodoDelete) {
      yield* _mapTodoDeleteToState(event);
    } else if (event is TodoReset) {
      yield* _mapTodoResetToState(event);
    }
  }

  Stream<TodoUpdateState> _mapTodoDeleteToState(TodoDelete event) async* {
    try {
      _mainRepository.deleteTodo(event.todo);
      yield TodoUpdateSuccess(_mainRepository.getTodosStream());
    } catch (exception) {
      print("TodoUpdateFailure _mapTodoDeleteToState exception = $exception");
      yield TodoUpdateFailure(Strings.errorMessageDefault);
    }
  }

  Stream<TodoUpdateState> _mapTodoResetToState(TodoReset event) async* {
    Todo oldTodo = event.todo;
    Todo newTodo = TimeUtils.updateTargetDate(oldTodo);
    try {
      _mainRepository.updateTodo(newTodo);
      yield TodoUpdateSuccess(_mainRepository.getTodosStream());
    } catch (exception) {
      print("TodoUpdateFailure _mapTodoResetToState exception = $exception");
      yield TodoUpdateFailure(Strings.errorMessageDefault);
    }
  }

  Stream<TodoUpdateState> _mapGetTodosToState() async* {
    try {
      Stream<QuerySnapshot> todosStream = _mainRepository.getTodosStream();
      yield TodosReceived(todosStream);
    } catch (exception) {
      print("TodoUpdateFailure _mapGetTodosToState exception = $exception");
      yield TodoUpdateFailure(Strings.errorMessageDefault);
    }
  }
}
