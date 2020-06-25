import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routine_flutter/data/todo.dart';
import 'package:routine_flutter/errors/error_utils.dart';
import 'package:routine_flutter/repository/mainRepository.dart';
import 'package:routine_flutter/ui/edit/edit_screen.dart';
import 'package:routine_flutter/ui/todo/empty_todo_placeholder.dart';
import 'package:routine_flutter/ui/todo/todo_bloc/todo_bloc.dart';
import 'package:routine_flutter/ui/todo/todo_bloc/todo_event.dart';
import 'package:routine_flutter/ui/todo/todo_bloc/todo_state.dart';
import 'package:routine_flutter/ui/todo/todoitem.dart';
import 'package:routine_flutter/utils/consts.dart';
import 'package:routine_flutter/utils/styles.dart';
import 'package:routine_flutter/utils/time_utils.dart';

class TodoList extends StatelessWidget {
  final MainRepository _mainRepository;

  TodoList(this._mainRepository);

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
            onPressed: () => _pushEditScreen(context),
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
      body: BlocProvider<TodoBloc>(
        create: (context) => TodoBloc(mainRepository: _mainRepository),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<TodoBloc, TodoUpdateState>(builder: (buildContext, state) {
      print("todoUpdateState = $state");
      if (state is TodoInitial) {
        BlocProvider.of<TodoBloc>(buildContext).add(GetTodos());
        return LinearProgressIndicator();
      } else if (state is TodosReceived) {
        return _todoList(buildContext, state.todosStream);
      } else if (state is TodoUpdateSuccess) {
        return _todoList(buildContext, state.todos);
      } else if (state is TodoUpdateFailure) {
        print("TodoUpdateFailure todoUpdateState.error = ${state.error}");
        ErrorUtils.showError(
          buildContext,
          message: state.error,
          action: SnackBarAction(
            label: Strings.snackbarRetry,
            onPressed: () {
              BlocProvider.of<TodoBloc>(buildContext).add(GetTodos());
            },
          ),
          duration: Duration(days: 1),
        );
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                Strings.listFailureText,
                style: Styles.todosListErrorTextStyle,
              )
            ],
          ),
        );
      }
      throw Exception("unexpected todoUpdateState = $state");
    });
  }

  Widget _todoList(BuildContext buildContext, Stream<QuerySnapshot> todosStream) {
    return StreamBuilder<QuerySnapshot>(
      stream: todosStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        }
        if (snapshot.data.documents.isEmpty) {
//              placeholder for empty list
          return EmptyTodoPlaceholder();
        } else {
          List<Todo> todoList = snapshot.data.documents.map((documentSnapshot) {
            return Todo.fromDocumentSnapshot(documentSnapshot);
          }).toList();
          todoList.sort((a, b) => TimeUtils.compareDateTimes(a.targetDate, b.targetDate));
          List<Widget> widgets = _createItemWidgetsList(buildContext, todoList);
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: Dimens.commonPadding),
            itemCount: widgets.length,
            itemBuilder: (context, index) => widgets[index],
          );
        }
      },
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

  List<Widget> _createItemWidgetsList(BuildContext context, List<Todo> sortedList) {
    List<Widget> widgets = List();
    int lastExpiredIndex = findLastExpiredIndex(sortedList);
    for (int i = 0; i < sortedList.length; i++) {
      Todo todo = sortedList[i];
      int gradientColorIndex = lastExpiredIndex != -1 ? i - lastExpiredIndex - 1 : i;
      widgets.add(_getItemWidget(context, todo, gradientColorIndex));
      if (lastExpiredIndex == i) {
        widgets.add(Divider(color: ColorsRes.selectedPeriodUnitColor));
      }
    }
    return widgets;
  }

  Widget _getItemWidget(BuildContext context, Todo todo, int colorIndex) {
    return GestureDetector(
        child: Dismissible(
          key: Key(todo.id.toString()),
          child: TodoItem(todo, colorIndex),
          confirmDismiss: (direction) => _confirmDismiss(context, direction, todo),
          background: _getDismissibleItemBackground(Strings.listResetSlideActionLabel, ColorsRes.listResetSlideActionBackground, true),
          secondaryBackground: _getDismissibleItemBackground(Strings.listDeleteSlideActionLabel, Colors.grey, false),
        ),
        onTap: () => _pushEditScreen(context, todo: todo));
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

  Future<bool> _confirmDismiss(BuildContext buildContext, DismissDirection direction, Todo item) async {
    if (direction == DismissDirection.startToEnd) {
      BlocProvider.of<TodoBloc>(buildContext).add(TodoReset(todo: item));
      return false;
    } else {
      return await _showConfirmDialog(buildContext, item);
    }
  }

  Future<bool> _showConfirmDialog(BuildContext buildContext, Todo todo) async => await showDialog(
      context: buildContext,
      builder: (context) {
        return AlertDialog(
          content: Text(Strings.listDialogContentText),
          actions: <Widget>[
            FlatButton(
              child: Text(Strings.listDialogActionCancel),
              onPressed: () => Navigator.pop(context, false),
            ),
            FlatButton(
                child: Text(Strings.listDialogActionDelete),
                onPressed: () {
                  BlocProvider.of<TodoBloc>(buildContext).add(TodoDelete(todo: todo));
                  Navigator.pop(context, false);
                }),
          ],
        );
      });

  void _pushEditScreen(BuildContext context, {Todo todo}) async {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => EditScreen(entry: todo, mainRepository: _mainRepository)));
  }
}
