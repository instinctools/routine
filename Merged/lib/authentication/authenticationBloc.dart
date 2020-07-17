import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:routine_flutter/authentication/authenticationEvent.dart';
import 'package:routine_flutter/authentication/authenticationState.dart';
import 'package:routine_flutter/repository/mainRepository.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final MainRepository mainRepository;

  AuthenticationBloc({@required this.mainRepository}) : assert(mainRepository != null);

  @override
  AuthenticationState get initialState => AuthenticationInitial();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AuthenticationStarted || event is AuthenticationRetry) {
      yield AuthenticationInProgress();
      try {
        await mainRepository.signInAnonymously();
        yield AuthenticationSuccess();
      } catch (exception) {
        yield AuthenticationFailure("signInAnonymously exception = ${exception.toString()}");
      }
    }
  }
}
