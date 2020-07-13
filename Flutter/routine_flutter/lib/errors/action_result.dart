import 'package:routine_flutter/utils/consts.dart';

abstract class ActionResult {
  String message;

  ActionResult([this.message]);
}

class ActionSuccess<T> extends ActionResult {
  T payload;

  ActionSuccess([this.payload, String message]):super(message);
}

class ActionFailure extends ActionResult {
  ActionFailure([String message = Strings.errorMessageDefault]) : super(message);
}