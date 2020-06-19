import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:routine_flutter/authentication/authenticationEvent.dart';
import 'package:routine_flutter/authentication/authenticationState.dart';
import 'package:routine_flutter/errors/action_result.dart';
import 'package:routine_flutter/errors/error_handler.dart';
import 'package:routine_flutter/repository/mainRepository.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final MainRepository mainRepository;

  AuthenticationBloc({@required this.mainRepository}) : assert(mainRepository != null);

  @override
  AuthenticationState get initialState => AuthenticationInitial();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AuthenticationStarted) {
      yield AuthenticationInProgress();
      ActionResult authResult = await mainRepository.signInAnonymously();

      if (authResult is ActionSuccess) {
        yield AuthenticationSuccess();
      } else {
        print(authResult.message);
        yield AuthenticationFailure();
      }
    }
  }
}
