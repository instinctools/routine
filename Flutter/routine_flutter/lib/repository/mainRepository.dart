import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:routine_flutter/data/todo.dart';
import 'package:routine_flutter/errors/action_result.dart';
import 'package:routine_flutter/errors/error_extensions.dart';

class MainRepository {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Firestore _fireStore = Firestore.instance;
  CollectionReference _collectionReference;

  Stream<ActionResult> getTodos() {
    print("get todos");
    return _collectionReference.snapshots().wrapError(logMessage: "get todos error");
  }

  Future<ActionResult> addTodo(Todo todo) {
    print("add Todo");
    return _collectionReference.add(todo.toMap()).wrapError(logMessage: "add todo error");
  }

  Future<ActionResult> updateTodo(Todo todo) {
    print("update Todo");
    return _fireStore.runTransaction((transaction) async {
      await transaction.update(todo.reference, todo.toMap());
    }).wrapError(logMessage: "update todo error");
  }

  Future<ActionResult> deleteTodo(Todo todo) {
    print("delete Todo");
    return _fireStore.runTransaction((transaction) async {
      await transaction.delete(todo.reference);
    }).wrapError(logMessage: "delete todo error");
  }

  Future<ActionResult> signInAnonymously() async {
    return await _firebaseAuth
        .signInAnonymously()
        .then((value) => _collectionReference = _fireStore.collection("users/${value.user.uid}/todos"))
        .wrapError(logMessage: "error _signInAnonymously exception");
  }
}
