import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routine_flutter/authentication/authenticationBloc.dart';
import 'package:routine_flutter/authentication/authenticationEvent.dart';
import 'package:routine_flutter/authentication/authenticationState.dart';
import 'package:routine_flutter/repository/mainRepository.dart';
import 'package:routine_flutter/ui/todo/todolist.dart';
import 'package:routine_flutter/utils/consts.dart';
import 'package:routine_flutter/utils/styles.dart';

class SplashScreen extends StatelessWidget {
  final MainRepository _mainRepository;

  SplashScreen(this._mainRepository);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          print("authenticationBloc  state = $state");
          if (state is AuthenticationInitial) {
            BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationStarted());
          }
          if (state is AuthenticationInProgress) {
            return _splashScreenScreen();
          }
          if (state is AuthenticationSuccess) {
            return TodoList(_mainRepository);
          }
          return _splashScreenScreen();
        },
      ),
    );
  }

  Widget _splashScreenScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/loading_logo.png'),
            SizedBox(height: 50),
            Text(
              Strings.splashScreenText,
              style: Styles.splashScreenTextStyle,
            ),
            SizedBox(height: 40),
            CircularProgressIndicator(
              backgroundColor: ColorsRes.splashScreenTextColor,
              valueColor: new AlwaysStoppedAnimation<Color>(ColorsRes.splashScreenProgressAnimationColor),
            ),
          ],
        ),
      ),
    );
  }
}
