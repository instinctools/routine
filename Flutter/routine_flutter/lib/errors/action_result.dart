import 'package:routine_flutter/utils/consts.dart';

abstract class ActionResult {
  String message;

  ActionResult([this.message]);
}

class ActionSuccess extends ActionResult {}

class ActionFailure extends ActionResult {
  ActionFailure([String message = Strings.errorMessageDefault]) : super(message);
}