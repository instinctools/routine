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

  void updateTodo(Todo todo) {
    todo.reference.updateData(todo.toMap());
  }

  void deleteTodo(Todo todo) {
    print("delete Todo");
    todo.reference.delete();
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
