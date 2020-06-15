import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routine_flutter/data/todo.dart';
import 'package:routine_flutter/repository/MainRepository.dart';
import 'package:routine_flutter/ui/edit/period.dart';
import 'package:routine_flutter/utils/time_utils.dart';

import 'resetType.dart';

class EditPresenter {
  String id;
  String periodUnit = Period.DAY.name;
  int periodValue = 1;
  ResetType resetType = ResetType.RESET_TO_PERIOD;

  final TextEditingController controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  MainRepository mainRepository;

  EditPresenter(MainRepository mainRepository, Todo todo) {
    this.mainRepository = mainRepository;
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

  void onDoneClicked() {
    if (id == null) {
      mainRepository.addTodo(
        Todo(
          controller.value.text + DateTime.now().millisecondsSinceEpoch.toString(), // id = title + now.inMillisecondsSinceEpoch
          controller.value.text,
          periodUnit,
          periodValue,
          TimeUtils.addPeriodToCurrentMoment(controller.value.text, periodUnit, periodValue).millisecondsSinceEpoch,
          resetType,
        ),
      );
    } else {
      mainRepository.updateTodo();
    }
  }
}
