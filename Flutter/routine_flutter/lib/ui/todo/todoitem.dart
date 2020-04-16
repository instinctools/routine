import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routine_flutter/utils/consts.dart';
import 'package:routine_flutter/utils/styles.dart';

class TodoItem extends StatelessWidget {
  final Todo entry;
  final int index;

  TodoItem(this.entry, this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: Dimens.COMMON_PADDING_HALF),
        decoration: BoxDecoration(
            color: _pickItemColor(index),
            borderRadius: BorderRadius.circular(Dimens.ITEM_BOX_BORDER_RADIUS)),
        child: Padding(
          padding: EdgeInsets.all(Dimens.COMMON_PADDING),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                entry.title,
                style: Styles.TODO_ITEM_TITLE_TEXT,
              ),
              Padding(
                padding: EdgeInsets.only(top: Dimens.COMMON_PADDING_DOUBLE),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(entry.period, style: Styles.TODO_ITEM_TIME_TEXT),
                    Text(entry.timeLeft, style: Styles.TODO_ITEM_TIME_TEXT)
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Color _pickItemColor(int index,
      {int maxIndex = 15,
      color1 = const [255, 190, 67],
      color2 = const [255, 57, 55]}) {
    var w1 = 1.0;
    if (index < maxIndex) {
      w1 = index / maxIndex;
    }
    var w2 = 1 - w1;
    var colorRgb = [];
    for (var i = 0; i < 3; i++) {
      var resultPart = ((color1[i] * w1 + color2[i] * w2) as num).round();
      colorRgb.add(resultPart);
    }
    return Color.fromRGBO(colorRgb[0], colorRgb[1], colorRgb[2], 1);
  }
}

class Todo {
  String title;
  String timeLeft;
  String period;

  Todo(this.title, {this.timeLeft = '5 days left', this.period = 'per 2 days'});
}
