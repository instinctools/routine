import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:routine_flutter/errors/action_result.dart';
import 'package:routine_flutter/errors/error_handler.dart';
import 'package:routine_flutter/data/todo.dart';

class MainRepository {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Firestore _fireStore = Firestore.instance;
  CollectionReference _collectionReference;
  ErrorHandler _errorHandler = ErrorHandler();

  Stream<QuerySnapshot> getTodos() {
    print("get todos");
    return _collectionReference.snapshots();
  }

  void addTodo(Todo todo) async {
    print("add Todo");
    _collectionReference.add(todo.toMap());
  }

  Future<void> updateTodo(Todo todo) async {
    print("update Todo");
    _fireStore.runTransaction((transaction) async {
      await transaction.update(todo.reference, todo.toMap());
    });
  }

  Future<void> deleteTodo(Todo todo) async {
    print("delete Todo");
    _fireStore.runTransaction((transaction) async {
      await transaction.delete(todo.reference);
    });
  }

  Future<ActionResult> signInAnonymously() async {
    try {
      AuthResult authResult = await _firebaseAuth.signInAnonymously();
      _collectionReference = _fireStore.collection("users/${authResult.user.uid}/todos");
      return ActionSuccess();
    } catch (e) {
      print("error _signInAnonymously exception = $e");
      return ActionFailure(_errorHandler.getErrorMessage(e));
    }
  }
}
