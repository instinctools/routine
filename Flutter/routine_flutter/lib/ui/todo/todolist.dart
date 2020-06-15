import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:routine_flutter/data/db_helper.dart';
import 'package:routine_flutter/data/todo.dart';
import 'package:routine_flutter/ui/edit/edit_screen.dart';
import 'package:routine_flutter/ui/todo/empty_todo_placeholder.dart';
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
              onPressed: _pushEditScreen,
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: ListTile(
                  title: Text(
                    "Routine",
                    style: Styles.drawerHeaderTitleTextStyle,
                  ),
                  subtitle: Text(
                    "by Instinctools",
                    style: Styles.drawerHeaderSubtitleTextStyle,
                  ),
                ),
              ),
              ListTile(
                title: Text("Settings"),
                onTap: () {
                  print("on item 1 clicked");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Technology"),
                onTap: () {
                  print("on item 2 clicked");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: FutureBuilder<List<Todo>>(
          future: helper.getTodos(),
          builder: (context, futureResult) {
            if (futureResult.connectionState == ConnectionState.done) {
              if (futureResult.data.length > 0) {
                List<Todo> sortedList = futureResult.data;
                sortedList.sort((a, b) => TimeUtils.compareDateTimes(a.targetDate, b.targetDate));

                List<Widget> widgets = _createItemWidgetsList(sortedList);
                return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: Dimens.COMMON_PADDING), itemCount: widgets.length, itemBuilder: (context, index) => widgets[index]);
              } else {
//              placeholder for empty list
                return EmptyTodoPlaceholder();
              }
            }
//            progress bar
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
    int index = -1;
    for (int i = 0; i <= list.length; i++) {
      var item = list[i];
      if (item.targetDate > currentTime) {
        break;
      }
      index = i;
    }
    print("last expired item index $index");
    return index;
  }

  List<Widget> _createItemWidgetsList(List<Todo> sortedList) {
    List<Widget> widgets = List();
    int lastExpiredIndex = findLastExpiredIndex(sortedList);

    for (int i = 0; i < sortedList.length; i++) {
      Todo todo = sortedList[i];
      int gradientColorIndex = lastExpiredIndex != -1 ? i - lastExpiredIndex - 1 : i;

      widgets.add(_getItemWidget(todo, gradientColorIndex));

      if (lastExpiredIndex == i) {
        widgets.add(Divider(color: ColorsRes.selectedPeriodUnitColor));
      }
    }
    return widgets;
  }

  Widget _getItemWidget(Todo todo, int colorIndex) {
    return GestureDetector(
        child: Dismissible(
          key: Key(todo.id.toString()),
          child: TodoItem(todo, colorIndex),
          onResize: () {
            setState(() {});
            print("reseted");
          },
          onDismissed: (direction) {
            setState(() {});
          },
          confirmDismiss: (direction) => _confirmDismiss(direction, todo),
          background: _getDismissibleItemBackground(Strings.listResetSlideActionLabel, Colors.green, true),
          secondaryBackground: _getDismissibleItemBackground(Strings.listDeleteSlideActionLabel, Colors.grey, false),
        ),
        onTap: () => _pushEditScreen(todo: todo));
  }

  Widget _getDismissibleItemBackground(String title, Color color, bool isPrimary) {
    var dimen = Dimens.COMMON_PADDING_HALF;
    var insets = EdgeInsets.only(top: dimen, bottom: dimen, left: isPrimary ? 0.0 : dimen, right: isPrimary ? dimen : 0.0);

    MainAxisAlignment alignment = isPrimary ? MainAxisAlignment.start : MainAxisAlignment.end;

    return Container(
      color: ColorsRes.mainBgColor,
      child: Row(
        mainAxisAlignment: alignment,
        children: <Widget>[
          FractionallySizedBox(
            heightFactor: 1.0,
            child: Container(
              margin: insets,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimens.ITEM_BOX_BORDER_RADIUS), color: color),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimens.COMMON_PADDING_LARGE),
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
      await _resetTodo(item);
    } else {
      return _showConfirmDialog(item);
    }
    return false;
  }

  Future<void> _resetTodo(Todo item) async {
    var reseted = item.resetTargetDate();
    if (await helper.changeTodo(reseted) != null) {
      setState(() {});
    }
  }

  Future<bool> _showConfirmDialog(Todo item) async => await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(Strings.listDialogContentText),
          actions: <Widget>[
            FlatButton(child: Text(Strings.listDialogActionCancel), onPressed: () => Navigator.pop(context, false)),
            FlatButton(
                child: Text(Strings.listDialogActionDelete),
                onPressed: () async {
                  bool isSuccess = await helper.deleteTodo(item.id) != null;
                  Navigator.pop(context, isSuccess);
                }),
          ],
        );
      });

  void _pushEditScreen({Todo todo}) async {
    var isAdded = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => EditScreen(entry: todo)));
    if (isAdded != null && isAdded) {
      setState(() {});
    }
  }
}
