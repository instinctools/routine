import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:routine_flutter/data/todo.dart';

class MainRepository {
  static const methodAddReminder = "addReminder";
  static const methodCancelReminder = "cancelReminder";
  static const keyTodoId = "keyTodoId";
  static const keyTodoMessage = "keyTodoMessage";
  static const keyTodoTargetDate = "keyTodoTargetDate";
  static const methodChannel = const MethodChannel('routine.flutter/reminder');
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Firestore _fireStore = Firestore.instance;
  CollectionReference _collectionReference;

  Stream<QuerySnapshot> getTodosStream() {
    print("get todos");
    return _collectionReference.snapshots();
  }

  void addTodo(Todo todo) {
    print("add Todo");
    _collectionReference.add(todo.toMap());
    _addReminderToNative(todo);
  }

  void updateTodo(Todo todo) {
    print("update Todo");
    todo.reference.updateData(todo.toMap());
    _addReminderToNative(todo);
  }

  void deleteTodo(Todo todo) {
    print("delete Todo");
    todo.reference.delete();
    _cancelReminderToNative(todo);
  }

  Future<void> signInAnonymously() async {
    return await _firebaseAuth.signInAnonymously().then(
      (authResult) {
        if (authResult != null) {
          _collectionReference = _fireStore.collection("users/${authResult.user.uid}/todos");
        } else {
          throw Exception("_firebaseAuth.signInAnonymously authResult = null");
        }
      },
    );
  }

  Future<void> _addReminderToNative(Todo todo) async {
    try {
      await methodChannel.invokeMethod(
        methodAddReminder,
        {
          keyTodoId: todo.id,
          keyTodoMessage: todo.title,
          keyTodoTargetDate: todo.targetDate,
        },
      );
      print("_addReminderToNative done. todo = $todo");
    } on PlatformException catch (e) {
      print("_addReminderToNative PlatformException = $e");
    }
  }

  Future<void> _cancelReminderToNative(Todo todo) async {
    try {
      await methodChannel.invokeMethod(
        methodCancelReminder,
        {
          keyTodoId: todo.id,
        },
      );
      print("_cancelReminderToNative done. todo = $todo");
    } on PlatformException catch (e) {
      print("_cancelReminderToNative PlatformException = $e");
    }
  }
}
