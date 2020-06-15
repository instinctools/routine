import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routine_flutter/data/todo.dart';
import 'package:routine_flutter/utils/time_utils.dart';

import 'ResetType.dart';

class EditPresenter {
  String id;
  String periodUnit = 'day';
  int periodValue = 1;
  ResetType resetType = ResetType.RESET_TO_PERIOD;

  final TextEditingController controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  EditPresenter(Todo todo) {
    if (todo != null) {
      this.id = todo.id;
      this.periodUnit = todo.periodUnit;
      this.periodValue = todo.periodValue;
      this.controller.text = todo.title;
      this.resetType = todo.resetType;
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

  NewTodo getResult() => NewTodo(
        id,
        controller.value.text,
        periodUnit,
        periodValue,
        TimeUtils.addPeriodToCurrentMoment(controller.value.text, periodUnit, periodValue).millisecondsSinceEpoch,
        resetType,
      );
}
