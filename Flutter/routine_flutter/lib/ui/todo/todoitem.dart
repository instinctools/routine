import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routine_flutter/utils/consts.dart';

class TodoItem extends StatelessWidget {
  final Todo entry;

  TodoItem(this.entry);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: Dimens.COMMON_PADDING_HALF),
        decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(Dimens.ITEM_BOX_BORDER_RADIUS)),
        child: Padding(
          padding: EdgeInsets.all(Dimens.COMMON_PADDING),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                entry.title,
              ),
              Padding(
                padding: EdgeInsets.only(top: Dimens.COMMON_PADDING_BETWEEN),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text(entry.period), Text(entry.timeLeft)],
                ),
              )
            ],
          ),
        ));
  }
}

class Todo {
  String title;
  String timeLeft;
  String period;

  Todo(this.title, {this.timeLeft = '5 days left', this.period = 'per 2 days'});
}
