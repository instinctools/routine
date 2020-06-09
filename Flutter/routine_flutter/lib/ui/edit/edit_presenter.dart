import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routine_flutter/data/todo.dart';
import 'package:routine_flutter/utils/time_utils.dart';

class EditPresenter {
  int id;
  String periodUnit = 'day';
  int periodValue = 1;
  int timestamp = 0;
  ResetType resetType = ResetType.RESET_TO_PERIOD;

  final TextEditingController controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  EditPresenter(Todo todo) {
    if (todo != null) {
      this.id = todo.id;
      this.periodUnit = todo.periodUnit;
      this.periodValue = todo.periodValue;
      this.timestamp = todo.timestamp;
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

  Todo getResult() => Todo(
      id: id,
      title: controller.value.text,
      periodUnit: periodUnit,
      periodValue: periodValue,
      timestamp: TimeUtils.calculateTargetTime(controller.value.text, periodUnit, periodValue).millisecondsSinceEpoch,
      resetType: resetType);
}

enum ResetType {
  RESET_TO_PERIOD,
  RESET_TO_DATE,
}

extension ResetTypeExtension on ResetType {
  static const values = {
    ResetType.RESET_TO_PERIOD: "RESET_TO_PERIOD",
    ResetType.RESET_TO_DATE: "RESET_TO_DATE",
  };

  String get value => values[this];

  static ResetType find(final String value) {
    switch (value) {
      case "RESET_TO_PERIOD":
        return ResetType.RESET_TO_PERIOD;
      case "RESET_TO_DATE":
        return ResetType.RESET_TO_DATE;
      default:
        throw Exception("undefined reset type");
    }
  }
}
