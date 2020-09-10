import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:routine_flutter/data/todo.dart';
import 'package:routine_flutter/ui/edit/period_unit.dart';
import 'package:routine_flutter/utils/time_utils.dart';
import 'package:uuid/uuid.dart';

import 'resetType.dart';

class EditPresenter {
  static const int initValue = 1;

  String id;
  PeriodUnit selectedPeriodUnit = PeriodUnit.DAY;
  ResetType resetType = ResetType.RESET_TO_PERIOD;
  DocumentReference reference;
  Map<PeriodUnit, int> valuesPeriods = {};


  EditPresenter(Todo todo) {
    PeriodUnit.values.forEach((element) {
      valuesPeriods.addAll({element: initValue});
    });

    if (todo != null) {
      id = todo.id;
      selectedPeriodUnit = todo.periodUnit;
      valuesPeriods[selectedPeriodUnit] = todo.periodValue;
      resetType = todo.resetType;
      reference = todo.reference;
    }
  }

  Todo getTodo(String titleTodo) {
    var selectedValuePeriod = valuesPeriods[selectedPeriodUnit];
    return Todo(
      Uuid().v4(),
      titleTodo,
      selectedPeriodUnit,
      selectedValuePeriod,
      TimeUtils.addPeriodToCurrentMoment(selectedPeriodUnit, selectedValuePeriod).millisecondsSinceEpoch,
      resetType,
      reference,
    );
  }
}
