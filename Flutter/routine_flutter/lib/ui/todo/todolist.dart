import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:routine_flutter/data/db_helper.dart';
import 'package:routine_flutter/data/todo.dart';
import 'package:routine_flutter/main.dart';
import 'package:routine_flutter/repository/mainRepository.dart';
import 'package:routine_flutter/ui/edit/edit_screen.dart';
import 'package:routine_flutter/ui/todo/empty_todo_placeholder.dart';
import 'package:routine_flutter/ui/todo/todoitem.dart';
import 'package:routine_flutter/utils/consts.dart';
import 'package:routine_flutter/utils/styles.dart';
import 'package:routine_flutter/utils/time_utils.dart';

class TodoList extends StatefulWidget {
  final mainRepository;

  TodoList(this.mainRepository);

  @override
  State<StatefulWidget> createState() => _TodoListState(mainRepository);
}

class _TodoListState extends State<TodoList> {
  DatabaseHelper helper = DatabaseHelper();
  MainRepository mainRepository;

  _TodoListState(mainRepository) {
    this.mainRepository = mainRepository;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Strings.appName,
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
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: mainRepository.getTodos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LinearProgressIndicator();
          }
          if (snapshot.data.documents.isEmpty) {
//              placeholder for empty list
            return EmptyTodoPlaceholder();
          } else {
            return _buildList(context, snapshot.data.documents);
          }
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> documentSnapshots) {
    List<Todo> todoList = documentSnapshots.map((documentSnapshot) {
      return Todo.fromDocumentSnapshot(documentSnapshot);
    }).toList();
//    print("todoList:  $todoList");
    todoList.sort((a, b) => TimeUtils.compareDateTimes(a.targetDate, b.targetDate));
    List<Widget> widgets = _createItemWidgetsList(todoList);
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: Dimens.commonPadding),
      itemCount: widgets.length,
      itemBuilder: (context, index) => widgets[index],
    );
  }

  int findLastExpiredIndex(List<Todo> list) {
    int currentTime = TimeUtils.getCurrentTimeMillis();
    int index = -1;
    list.forEach((element) {
      if (element.targetDate < currentTime) {
        index = list.indexOf(element);
      }
    });
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
    var dimen = Dimens.commonPaddingHalf;
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
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimens.itemBoxBorderRadius), color: color),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimens.commonPaddingLarge),
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

  Future<void> _resetTodo(Todo todo) async {
    mainRepository.updateTodo(TimeUtils.updateTargetDate(todo));
  }

  Future<bool> _showConfirmDialog(Todo todo) async => await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(Strings.listDialogContentText),
          actions: <Widget>[
            FlatButton(child: Text(Strings.listDialogActionCancel), onPressed: () => Navigator.pop(context, false)),
            FlatButton(
                child: Text(Strings.listDialogActionDelete),
                onPressed: () {
                  mainRepository.deleteTodo(todo);
                  Navigator.pop(context);
                }),
          ],
        );
      });

  void _pushEditScreen({Todo todo}) async {
    var isAdded = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => EditScreen(entry: todo, mainRepository: mainRepository)));
    if (isAdded != null && isAdded) {
      setState(() {});
    }
  }
}
