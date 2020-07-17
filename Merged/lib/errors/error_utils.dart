import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorUtils {
  static void showError(BuildContext context, {@required String message, SnackBarAction action, Duration duration}) {
    try {
      Scaffold.of(context).showSnackBar(_createSnackbar(message, action: action, duration: duration));
    } catch (error) {
      print("show error with context: $error");
    }
  }

  static void showErrorFromKey(GlobalKey<ScaffoldState> key, {@required String message, SnackBarAction action}) {
    try {
      key.currentState.showSnackBar(_createSnackbar(message, action: action));
    } catch (error) {
      print("show error with with global key: $error");
    }
  }

  static SnackBar _createSnackbar(String message, {SnackBarAction action, Duration duration}) => SnackBar(
        content: Text(message),
        duration: duration ?? Duration(seconds: 3),
        action: action,
      );
}