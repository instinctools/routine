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
  Widget build(BuildContext buildContext) {
    return Scaffold(
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          print("authenticationState = $state");
          if (state is AuthenticationInitial) {
            BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationStarted());
            return _splashScreenProgress();
          }
          if (state is AuthenticationInProgress) {
            return _splashScreenProgress();
          }
          if (state is AuthenticationSuccess) {
            return TodoList(_mainRepository);
          }
          if (state is AuthenticationFailure) {
            print("AuthenticationFailure error = ${state.error}");
            return _splashScreenFailure(buildContext);
          }
          throw Exception("unexpected AuthenticationState = $state");
        },
      ),
    );
  }

  Widget _splashScreenProgress() {
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

  Widget _splashScreenFailure(BuildContext buildContext) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/loading_logo.png'),
            SizedBox(height: 50),
            Text(
              Strings.splashScreenFailureText,
              style: Styles.splashScreenTextStyle,
            ),
            SizedBox(height: 40),
            SizedBox(
              width: Dimens.splashScreenRetryButtonWidth,
              height: Dimens.splashScreenRetryButtonHeight,
              child: FlatButton(
                child: Text(
                  Strings.splashScreenRetryButtonText,
                  style: Styles.splashScreenRetryButton,
                ),
                onPressed: () => BlocProvider.of<AuthenticationBloc>(buildContext).add(AuthenticationRetry()),
                color: ColorsRes.splashScreenRetryButtonBackgroundColor,
                textColor: ColorsRes.splashScreenRetryButtonTextColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.commonBorderRadius),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
