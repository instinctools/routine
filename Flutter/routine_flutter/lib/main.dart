import 'package:flutter/material.dart';
import 'package:routine_flutter/ui/todo/todolist.dart';
import 'package:routine_flutter/utils/consts.dart';
import 'package:routine_flutter/utils/styles.dart';

void main() => runApp(RoutineApp());

class RoutineApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            elevation: 0,
            textTheme: TextTheme(
              title: Styles.APP_BAR_TEXT,
            )),
        primaryIconTheme: IconThemeData(color: Colors.black87),
        primaryColor: ColorsRes.mainBgColor,
        scaffoldBackgroundColor: ColorsRes.mainBgColor,
      ),
      home: TodoList(),
    );
  }
}
