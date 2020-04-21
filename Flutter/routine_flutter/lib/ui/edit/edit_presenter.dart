import 'package:flutter/cupertino.dart';
import 'package:routine_flutter/data/todo.dart';

class EditPresenter {
  int id = 0;
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

  void validateAndPrint(){
    if(formKey.currentState.validate()){
      print('Edited task = ${getResult().toString()}');
    }else{
      print('Validation failed!');
    }
  }

  Todo getResult() =>
      Todo(id, controller.value.text, periodUnit, periodValue, timestamp);
}
