import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
                          child: Slidable(
                            actionPane: SlidableScrollActionPane(),
                            child: TodoItem(item, index),
                            actions: <Widget>[
                              getItemSlidableAction(
                                  Strings.listResetSlideActionLabel,
                                  Colors.green,
                                  true)
                            ],
                            secondaryActions: <Widget>[
                              getItemSlidableAction(
                                  Strings.listDeletSlideActionLabel,
                                  Colors.grey,
                                  false)
                            ],
                          ),
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

  Widget getItemSlidableAction(String title, Color color, bool isPrimary) {
    var dimen = Dimens.COMMON_PADDING_HALF;
    var insets = EdgeInsets.only(
        top: dimen,
        bottom: dimen,
        left: isPrimary ? 0.0 : dimen,
        right: isPrimary ? dimen : 0.0);

    return SlideAction(
      color: ColorsRes.mainBgColor,
      child: Container(
        margin: insets,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimens.ITEM_BOX_BORDER_RADIUS),
            color: color),
        child: Center(
          child: Text(
            title,
            style: Styles.TODO_ITEM_TITLE_TEXT,
          ),
        ),
      ),
    );
  }

  void pushEditScreen({Todo todo}) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => EditScreen(entry: todo)));
}
