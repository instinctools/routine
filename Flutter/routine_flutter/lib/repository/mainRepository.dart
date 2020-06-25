import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:routine_flutter/data/todo.dart';

class MainRepository {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Firestore _fireStore = Firestore.instance;
  CollectionReference _collectionReference;

  Stream<QuerySnapshot> getTodos() {
    print("get todos");
    return _collectionReference.snapshots();
  }

  void addTodo(Todo todo) {
    print("add Todo");
    _collectionReference.add(todo.toMap());
  }

  Future<void> updateTodo(Todo todo) async {
    print("update Todo");
    await todo.reference.updateData(todo.toMap());
  }

  Future<void> deleteTodo(Todo todo) async {
    print("delete Todo");
    await todo.reference.delete();
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
}
