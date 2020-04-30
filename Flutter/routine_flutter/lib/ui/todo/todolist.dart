import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routine_flutter/data/db_helper.dart';
import 'package:routine_flutter/data/todo.dart';
import 'package:routine_flutter/ui/edit/edit_screen.dart';
import 'package:routine_flutter/ui/todo/todoitem.dart';
import 'package:routine_flutter/utils/consts.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  DatabaseHelper helper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            Strings.APP_NAME,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => EditScreen())),
            )
          ],
        ),
        body: FutureBuilder<List<Todo>>(
          future: helper.getTodos(),
          builder: (context, snap) {
            if (snap.hasData) {
              return ListView.builder(itemBuilder: (context, index) {
                return TodoItem(snap.data[index], index);
              });
            }
            return Text("TMP");
          },
        ));
  }
}
