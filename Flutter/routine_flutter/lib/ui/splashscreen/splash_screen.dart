import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routine_flutter/repository/mainRepository.dart';
import 'package:routine_flutter/ui/todo/todolist.dart';

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
      return _scaffoldProgress();
    }
  }

  void login() {
    _mainRepository.signInAnonymously().then((value) {
      setState(() {});
    });
  }

  Widget _scaffoldProgress() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
