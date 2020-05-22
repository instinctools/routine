import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routine_flutter/data/db_helper.dart';
import 'package:routine_flutter/data/todo.dart';
import 'package:routine_flutter/ui/edit/edit_screen.dart';
import 'package:routine_flutter/ui/todo/todoitem.dart';
import 'package:routine_flutter/utils/consts.dart';
import 'package:routine_flutter/utils/styles.dart';
import 'package:routine_flutter/utils/time_utils.dart';

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
                print("Todos loaded from db, size = ${snap.data.length}");
                var sortedList = snap.data;
                sortedList.sort((a, b) =>
                    TimeUtils.compareTargetDates(a.timestamp, b.timestamp));
                var lastExpiredIndex = findLastExpiredIndex(sortedList);
                return ListView.builder(
                    padding:
                        EdgeInsets.symmetric(horizontal: Dimens.COMMON_PADDING),
                    itemCount: sortedList.length,
                    itemBuilder: (context, index) {
                      var item = sortedList[index];
                      if (lastExpiredIndex != 0 &&
                          index == lastExpiredIndex + 1) {
                        return Divider(
                            color: ColorsRes.selectedPeriodUnitColor);
                      }
                      return GestureDetector(
                          child: Dismissible(
                            key: Key(item.id.toString()),
                            child: TodoItem(item, index),
                            onDismissed: (direction) {
                              setState(() {});
                            },
                            confirmDismiss: (direction) =>
                                _confirmDismiss(direction, item),
                            background: _getItemBackground(
                                Strings.listResetSlideActionLabel,
                                Colors.green,
                                true),
                            secondaryBackground: _getItemBackground(
                                Strings.listDeleteSlideActionLabel,
                                Colors.grey,
                                false),
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

  int findLastExpiredIndex(List<Todo> list) {
    int currentTime = TimeUtils.getCurrentTimeMillis();
    int index = 0;
    for (int i = 0; i <= list.length; i++) {
      var item = list[i];
      if (item.timestamp > currentTime) {
        break;
      }
      index = i;
    }
    print("last expired item index $index");
    return index;
  }

  Widget _getItemBackground(String title, Color color, bool isPrimary) {
    var dimen = Dimens.COMMON_PADDING_HALF;
    var insets = EdgeInsets.only(
        top: dimen,
        bottom: dimen,
        left: isPrimary ? 0.0 : dimen,
        right: isPrimary ? dimen : 0.0);

    MainAxisAlignment alignment =
        isPrimary ? MainAxisAlignment.start : MainAxisAlignment.end;

    return Container(
      color: ColorsRes.mainBgColor,
      child: Row(
        mainAxisAlignment: alignment,
        children: <Widget>[
          FractionallySizedBox(
            heightFactor: 1.0,
            child: Container(
              margin: insets,
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(Dimens.ITEM_BOX_BORDER_RADIUS),
                  color: color),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimens.COMMON_PADDING_LARGE),
                  child: Text(
                    title,
                    style: Styles.TODO_ITEM_TITLE_TEXT,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmDismiss(DismissDirection direction, Todo item) async {
    if (direction == DismissDirection.startToEnd) {
      print('reseted');
    } else {
      return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(Strings.listDialogContentText),
              actions: <Widget>[
                FlatButton(
                    child: Text(Strings.listDialogActionCancel),
                    onPressed: () => Navigator.pop(context, false)),
                FlatButton(
                    child: Text(Strings.listDialogActionDelete),
                    onPressed: () async {
                      bool isSuccess = await helper.deleteTodo(item.id) != null;
                      Navigator.pop(context, isSuccess);
                    }),
              ],
            );
          });
    }
    return false;
  }

  void pushEditScreen({Todo todo}) async {
    var isAdded = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => EditScreen(entry: todo)));
    if (isAdded != null && isAdded) {
      setState(() {});
    }
  }
}
