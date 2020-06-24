import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routine_flutter/data/todo.dart';
import 'package:routine_flutter/repository/mainRepository.dart';
import 'package:routine_flutter/ui/edit/period.dart';
import 'package:routine_flutter/utils/time_utils.dart';

import 'resetType.dart';

class EditPresenter {
  static const int initValue = 1;

  String id;
  PeriodUnit selectedPeriodUnit = PeriodUnit.DAY;
  ResetType resetType = ResetType.RESET_TO_PERIOD;
  DocumentReference reference;
  Map<PeriodUnit, int> valuesPeriods = {};

  final TextEditingController controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  MainRepository mainRepository;

  EditPresenter(MainRepository mainRepository, Todo todo) {
    this.mainRepository = mainRepository;
    PeriodUnit.values.forEach((element) {
      valuesPeriods.addAll({element: initValue});
    });

    if (todo != null) {
      id = todo.id;
      selectedPeriodUnit = todo.periodUnit;
      valuesPeriods[selectedPeriodUnit] = todo.periodValue;
      controller.text = todo.title;
      resetType = todo.resetType;
      reference = todo.reference;
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

  void onDoneClicked(BuildContext context) {
    var selectedValuePeriod = valuesPeriods[selectedPeriodUnit];
    var todo = Todo(
      controller.value.text + DateTime.now().millisecondsSinceEpoch.toString(),
      // id = title + now.inMillisecondsSinceEpoch
      controller.value.text,
      selectedPeriodUnit,
      selectedValuePeriod,
      TimeUtils.addPeriodToCurrentMoment(controller.value.text, selectedPeriodUnit, selectedValuePeriod).millisecondsSinceEpoch,
      resetType,
      reference,
    );
    print("onDoneClicked todo = $todo");
    if (id == null) {
      mainRepository.addTodo(todo);
    } else {
      mainRepository.updateTodo(todo);
    }
  }
}
