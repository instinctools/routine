import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routine_flutter/data/db_helper.dart';
import 'package:routine_flutter/data/todo.dart';
import 'package:routine_flutter/ui/edit/edit_screen.dart';
import 'package:routine_flutter/ui/todo/todoitem.dart';
import 'package:routine_flutter/utils/consts.dart';
import 'package:routine_flutter/utils/styles.dart';

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
              onPressed: pushEditScreen,
            )
          ],
        ),
        body: FutureBuilder<List<Todo>>(
          future: helper.getTodos(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.done) {
              if (snap.data.length > 0) {
                return ListView.builder(
                    padding:
                        EdgeInsets.symmetric(horizontal: Dimens.COMMON_PADDING),
                    itemCount: snap.data.length,
                    itemBuilder: (context, index) {
                      var item = snap.data[index];
                      return GestureDetector(
                          child: TodoItem(item, index),
                          onTap: () => pushEditScreen(todo: item));
                    });
              } else {
                return Center(
                    child: Text(
                  Strings.listEmptyPlaceholderText,
                  style: Styles.editSelectedPeriodTextStyle,
                ));
              }
            }
            return Center(
              widthFactor: Dimens.listProgressSize,
              heightFactor: Dimens.listProgressSize,
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  void pushEditScreen({Todo todo}) =>
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => EditScreen(entry: todo)));

}
