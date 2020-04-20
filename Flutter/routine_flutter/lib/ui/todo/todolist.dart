import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routine_flutter/ui/edit/editscreen.dart';
import 'package:routine_flutter/ui/todo/todoitem.dart';
import 'package:routine_flutter/utils/consts.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final _biggerSize = const TextStyle(fontSize: 16.0);
  final List<String> tasks =
      List.generate(50, (int index) => 'Test Task $index');

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
      body: ListView.builder(
          itemCount: tasks.length,
          padding: EdgeInsets.all(Dimens.COMMON_PADDING),
          itemBuilder: (context, i) {
            return TodoItem(TodoTMP(tasks[i]), i);
          }),
    );
  }
}
