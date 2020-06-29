import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:routine_flutter/data/todo.dart';
import 'package:routine_flutter/repository/mainRepository.dart';
import 'package:routine_flutter/utils/validators.dart';
import 'package:rxdart/rxdart.dart';

import 'edit_screen_event.dart';
import 'edit_screen_state.dart';

class EditScreenBloc extends Bloc<EditScreenEvent, EditScreenState> {
  final MainRepository _mainRepository;

  EditScreenBloc({@required MainRepository mainRepository})
      : assert(mainRepository != null),
        _mainRepository = mainRepository;

  @override
  EditScreenState get initialState => EditScreenState.initial();

  @override
  Stream<EditScreenState> mapEventToState(EditScreenEvent event) async* {
    print("EditScreenBloc EditScreenEvent = $event");
    if (event is EditScreenTitleTodoChanged) {
      yield* _mapEditScreenTitleTodoChangedToState(event.titleTodo);
    } else if (event is CancelPressed) {
      yield* _mapCancelPressedToState();
    } else if (event is DonePressed) {
      yield* _mapDonePressedToState(event.todo);
    } else if (event is CloseErrorDialogPressed) {
      yield* _mapCloseErrorDialogPressedToState();
    }
  }

  @override
  Stream<Transition<EditScreenEvent, EditScreenState>> transformEvents(
    Stream<EditScreenEvent> events,
    TransitionFunction<EditScreenEvent, EditScreenState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! EditScreenTitleTodoChanged);
    });
    final debounceStream = events
        .where((event) {
          return (event is EditScreenTitleTodoChanged);
        })
        .distinct()
        .debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  Stream<EditScreenState> _mapEditScreenTitleTodoChangedToState(String titleTodo) async* {
    yield state.update(
      isTitleTodoValid: Validators.isTitleTodoValid(titleTodo),
    );
  }

  Stream<EditScreenState> _mapCancelPressedToState() async* {
    yield state.update(
      isCancel: true,
    );
  }

  Stream<EditScreenState> _mapDonePressedToState(Todo todo) async* {
    try {
      if (todo.reference == null) {
        _mainRepository.addTodo(todo);
      } else {
        _mainRepository.updateTodo(todo);
      }
      yield state.update(
        isSuccess: true,
      );
    } catch (exception) {
      print("_mapDonePressedToState exception = $exception");
      yield state.update(
        isFailure: true,
      );
    }
  }

  Stream<EditScreenState> _mapCloseErrorDialogPressedToState() async* {
    yield state.update(isFailure: false);
  }
}
