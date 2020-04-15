import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
            Strings.appName,
            textAlign: TextAlign.left,
            textScaleFactor: 1.5,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => print('on add clicked'),
            )
          ],
        ),
        body: ListView.builder(
            itemCount: tasks.length,
            padding: EdgeInsets.all(16.0),
            itemBuilder: (context, i) {
              return ListTile(
                  title: Text(
                tasks[i],
                textAlign: TextAlign.center,
                style: _biggerSize,
              ));
            }));
  }
}
