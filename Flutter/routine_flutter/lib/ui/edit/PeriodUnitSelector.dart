import 'package:flutter/material.dart';
import 'package:routine_flutter/ui/edit/period.dart';
import 'package:routine_flutter/ui/todo/todoitem.dart';
import 'package:routine_flutter/utils/consts.dart';
import 'package:routine_flutter/utils/styles.dart';

class PeriodUnitSelector extends StatefulWidget {
  final Todo todo;

  PeriodUnitSelector(this.todo);

  @override
  _PeriodUnitSelectorState createState() => _PeriodUnitSelectorState();
}

class _PeriodUnitSelectorState extends State<PeriodUnitSelector> {
  int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.todo != null ? 1 : -1;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _createButtons());
  }

  List<Widget> _createButtons() {
    List<Widget> result = <Widget>[];
    final periodUnits = Period.values;
    for (var index = 0; index < periodUnits.length; index++) {
      var task = Task(index, periodUnits[index]);
      var periodButton = _createPeriodButton(task);
      result.add(periodButton);
    }
    return result;
  }

  Widget _createPeriodButton(Task task) {
    var isSelected = task.id == _selectedIndex;
    var periodText = 'Every ${task.periodUnit.name}';
    var bgColor = isSelected
        ? ColorsRes.selectedPeriodUnitColor
        : ColorsRes.unselectedPeriodUnitColor;
    var iconColor = isSelected
        ? ColorsRes.unselectedPeriodUnitColor
        : ColorsRes.selectedPeriodUnitColor;
    var textStyle = isSelected
        ? Styles.editUnselectedPeriodTextStyle
        : Styles.editSelectedPeriodTextStyle;

    return GestureDetector(
        onTap: () {
          _onPeriodSelected(task.id);
        },
        child: Container(
            margin: EdgeInsets.only(top: Dimens.COMMON_PADDING_DOUBLE),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    Dimens.edit_period_button_border_radius),
                color: bgColor),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimens.COMMON_PADDING_DOUBLE,
                  vertical: Dimens.edit_period_button_vertical_padding),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    periodText,
                    style: textStyle,
                  ),
                  Icon(
                    Icons.brightness_1,
                    color: iconColor,
                  )
                ],
              ),
            )));
  }

  void _onPeriodSelected(int id) {
    setState(() {
      print('Selected index = $id period = ${Period.values[id].name}');
      _selectedIndex = id;
    });
  }
}

class Task {
  int id;
  Period periodUnit;
  int periodValue;

  Task(this.id, this.periodUnit, {this.periodValue = 1});
}
