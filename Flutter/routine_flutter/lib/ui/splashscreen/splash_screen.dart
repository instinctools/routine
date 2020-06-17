import 'package:flutter/material.dart';
import 'package:routine_flutter/repository/mainRepository.dart';
import 'package:routine_flutter/ui/todo/todolist.dart';
import 'package:flutter/cupertino.dart';
import 'package:routine_flutter/utils/consts.dart';
import 'package:routine_flutter/utils/styles.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  MainRepository _mainRepository = MainRepository();

  _SplashScreenState() {
    login();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: body());
  }

  Widget body() {
    if (_mainRepository.isLoggedIn()) {
      return TodoList(_mainRepository);
    } else {
      return _splashScreenScreen();
    }
  }

  void login() {
    _mainRepository.signInAnonymously().then((value) {
      setState(() {});
    });
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
