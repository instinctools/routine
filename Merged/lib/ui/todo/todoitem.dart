import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routine_flutter/data/todo.dart';
import 'package:routine_flutter/ui/edit/period_unit.dart';
import 'package:routine_flutter/utils/consts.dart';
import 'package:routine_flutter/utils/styles.dart';
import 'package:routine_flutter/utils/time_utils.dart';

class TodoItem extends StatelessWidget {
  final Todo entry;
  final int index;

  TodoItem(this.entry, this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: Dimens.commonPaddingHalf),
        decoration: BoxDecoration(color: _pickItemColor(index), borderRadius: BorderRadius.circular(Dimens.itemBoxBorderRadius)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimens.commonPaddingDouble,
            vertical: Dimens.todoItemVerticalPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    entry.title,
                    style: Styles.TODO_ITEM_TITLE_TEXT,
                  ),
                  Text(
                    TimeUtils.calculateTimeLeft(entry.targetDate),
                    style: Styles.TODO_ITEM_TIME_TEXT,
                  ),
                ],
              ),
              SizedBox(
                height: Dimens.commonPaddingHalf,
              ),
              Text(TimeUtils.getPrettyPeriod(entry.periodUnit.name, entry.periodValue), style: Styles.TODO_ITEM_TIME_TEXT),
            ],
          ),
        ));
  }

  Color _pickItemColor(int index, {int maxIndex = 15, color1 = const [255, 190, 67], color2 = const [255, 57, 55]}) {
    if (index < 0) {
      return Colors.red.shade900;
    }
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
