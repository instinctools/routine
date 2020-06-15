import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:routine_flutter/data/todo.dart';

class MainRepository {
  var collection = Firestore.instance.collection("users/JSB6yYjno9NQzocDDGqMSrGdWzY2/todos"); //todo add login

  Stream<QuerySnapshot> getTodos() {
    print("get todos");
    return collection.snapshots();
  }

  void addTodo(Todo todo) async {
    print("add Todo ");
    collection.add(todo.toMap());
  }

  void updateTodo(Todo todo) {
    print("update Todo ");
    Firestore.instance.runTransaction((transaction) async {
      await transaction.update(todo.reference, todo.toMap());
    });
  }
}
