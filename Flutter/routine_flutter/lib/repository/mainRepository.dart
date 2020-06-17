import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:routine_flutter/data/todo.dart';

class MainRepository {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Firestore _fireStore = Firestore.instance;
  String _firebaseUserUid;
  CollectionReference _collectionReference;

  bool isLoggedIn() {
    return _firebaseUserUid != null;
  }

  Stream<QuerySnapshot> getTodos() {
    print("get todos");
    return _collectionReference.snapshots();
  }

  void addTodo(Todo todo) async {
    print("add Todo");
    _collectionReference.add(todo.toMap());
  }

  void updateTodo(Todo todo) {
    print("update Todo");
    _fireStore.runTransaction((transaction) async {
      await transaction.update(todo.reference, todo.toMap());
    });
  }

  void deleteTodo(Todo todo) {
    print("delete Todo");
    _fireStore.runTransaction((transaction) async {
      await transaction.delete(todo.reference);
    });
  }

  Future<void> signInAnonymously() async {
    try {
      AuthResult authResult = await _firebaseAuth.signInAnonymously();
      _firebaseUserUid = authResult.user.uid;
      _collectionReference = _fireStore.collection("users/$_firebaseUserUid/todos");
      print("aa3 authResult = $_firebaseUserUid");
    } catch (e) {
      print("error _signInAnonymously exception = $e");
    }
  }
}
