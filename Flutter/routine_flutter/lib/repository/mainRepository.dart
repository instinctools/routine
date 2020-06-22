import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:routine_flutter/errors/action_result.dart';
import 'package:routine_flutter/errors/error_handler.dart';
import 'package:routine_flutter/data/todo.dart';

class MainRepository {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Firestore _fireStore = Firestore.instance;
  CollectionReference _collectionReference;

  Stream<QuerySnapshot> getTodos() {
    print("get todos");
    return _collectionReference.snapshots();
  }

  Future<ActionResult> addTodo(Todo todo) {
    print("add Todo");
    return _collectionReference.add(todo.toMap()).wrapError("add todo error");
  }

  Future<ActionResult> updateTodo(Todo todo) {
    print("update Todo");
    return _fireStore.runTransaction((transaction) async {
      await transaction.update(todo.reference, todo.toMap());
    }).wrapError("update todo error");
  }

  Future<ActionResult> deleteTodo(Todo todo) {
    print("delete Todo");
    return _fireStore.runTransaction((transaction) async {
      await transaction.delete(todo.reference);
    }).wrapError("delete todo error");
  }

  Future<ActionResult> signInAnonymously() async {
    return await _firebaseAuth
        .signInAnonymously()
        .then((value) => _collectionReference = _fireStore.collection("users/${value.user.uid}/todos"))
        .wrapError("error _signInAnonymously exception");
  }
}

extension FutureExt<T> on Future<T> {
  Future<ActionResult> wrapError([String logPrefix]) async {
    try {
      await this;
      return ActionSuccess();
    } catch (e) {
      print("$logPrefix : $e");
      return ActionFailure(ErrorHandler.instance.getErrorMessage(e));
    }
  }
}
