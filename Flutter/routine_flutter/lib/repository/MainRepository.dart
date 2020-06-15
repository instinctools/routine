import 'package:cloud_firestore/cloud_firestore.dart';

class MainRepository {
  var collection = Firestore.instance.collection("users/12SesGjfsYa0iJgOQ4O4bpbNbX53/todos"); //todo add login

  Stream<QuerySnapshot> getTodos() {
    print("get todos");
    return collection.snapshots();
  }

  void addTodo() {
    print("add Todo ");
    final Map<String, String> aa = {
      "id": "a",
      "b": "b",
    };
    collection.add(aa);
  }

  void updateTodo() {
    print("update Todo ");
  }
}
