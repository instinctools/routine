import 'package:flutter/cupertino.dart';
import 'package:routine_flutter/data/todo.dart';
import 'package:routine_flutter/utils/time_utils.dart';

class EditPresenter {
  int id;
  String periodUnit = 'day';
  int periodValue = 1;
  int timestamp = 0;

  final TextEditingController controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  EditPresenter(Todo todo) {
    if (todo != null) {
      this.id = todo.id;
      this.periodUnit = todo.periodUnit;
      this.periodValue = todo.periodValue;
      this.timestamp = todo.timestamp;
      this.controller.text = todo.title;
    }
  }

  bool validateAndPrint() {
    if (formKey.currentState.validate()) {
      return true;
    } else {
      print('Validation failed!');
      return false;
    }
  }

  Todo getResult() => Todo(
      id: id,
      title: controller.value.text,
      periodUnit: periodUnit,
      periodValue: periodValue,
      timestamp: TimeUtils.getCurrentTime());
}
