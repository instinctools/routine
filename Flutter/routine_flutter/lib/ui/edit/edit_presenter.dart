import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routine_flutter/data/todo.dart';
import 'package:routine_flutter/errors/action_result.dart';
import 'package:routine_flutter/errors/error_extensions.dart';
import 'package:routine_flutter/errors/error_utils.dart';
import 'package:routine_flutter/repository/mainRepository.dart';
import 'package:routine_flutter/ui/edit/period.dart';
import 'package:routine_flutter/utils/time_utils.dart';

import 'resetType.dart';

class EditPresenter {
  String id;
  PeriodUnit periodUnit = PeriodUnit.DAY;
  int periodValue = 1;
  ResetType resetType = ResetType.RESET_TO_PERIOD;
  DocumentReference reference;

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
      this.reference = todo.reference;
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

  void onDoneClicked(BuildContext context) async {
    var todo = Todo(
      controller.value.text + DateTime.now().millisecondsSinceEpoch.toString(),
      // id = title + now.inMillisecondsSinceEpoch
      controller.value.text,
      periodUnit,
      periodValue,
      TimeUtils.addPeriodToCurrentMoment(controller.value.text, periodUnit, periodValue).millisecondsSinceEpoch,
      resetType,
      reference,
    );
    print("onDoneClicked todo = $todo");
    if (id == null) {
      await mainRepository.addTodo(todo).checkAndShowFailure(context);
    } else {
      await mainRepository.updateTodo(todo).checkAndShowFailure(context);
    }
  }
}
