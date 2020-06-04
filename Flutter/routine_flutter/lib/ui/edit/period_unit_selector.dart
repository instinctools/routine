import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:routine_flutter/ui/edit/edit_presenter.dart';
import 'package:routine_flutter/ui/edit/period.dart';
import 'package:routine_flutter/utils/consts.dart';
import 'package:routine_flutter/utils/styles.dart';
import 'package:routine_flutter/utils/time_utils.dart';

const int BEGIN_VALUE = 1;
const int END_VALUE = 100;

class PeriodUnitSelector extends StatefulWidget {
  final EditPresenter presenter;

  PeriodUnitSelector(this.presenter);

  @override
  _PeriodUnitSelectorState createState() => _PeriodUnitSelectorState();
}

class _PeriodUnitSelectorState extends State<PeriodUnitSelector> {
  int _selectedIndex;
  EditPresenter presenter;

  @override
  void initState() {
    super.initState();
    presenter = widget.presenter;
    _selectedIndex = Period.values
        .firstWhere((value) => value.name == presenter.periodUnit)
        .id;
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
      var data = PeriodData(index, periodUnits[index]);
      var periodButton = _createPeriodButton(data);
      result.add(periodButton);
    }
    return result;
  }

  Widget _createPeriodButton(PeriodData data) {
    var name = data.periodUnit.name;
    var isSelected = data.id == _selectedIndex;
    var periodText = isSelected
        ? TimeUtils.getPrettyPeriod(name, presenter.periodValue)
        : TimeUtils.getPrettyPeriod(name);
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
          _onPeriodSelected(data.id);
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
                  vertical: Dimens.COMMON_PADDING_DOUBLE),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      _showPeriodPicker(context, data.id);
                    },
                    icon: Icon(
                      Icons.menu,
                      color: iconColor,
                    ),
                  ),
                  Text(
                    periodText,
                    style: textStyle,
                  )
                ],
              ),
            )));
  }

  void _onPeriodSelected(int id) {
    print('Selected index = $id period = ${Period.values[id].name}');
    presenter.periodUnit = Period.values[id].name;
    setState(() {
      _selectedIndex = id;
    });
  }

  void _showPeriodPicker(BuildContext context, int id) {
    Picker(
      adapter: NumberPickerAdapter(data: [
        NumberPickerColumn(
            begin: BEGIN_VALUE,
            end: END_VALUE,
            initValue: presenter.periodValue)
      ]),
      title: Text(
        Strings.editPickerDialogTitle,
        style: Styles.edit_divider_label_style,
      ),
      confirmText: Strings.editPickerDialogConfirmButton,
      confirmTextStyle: Styles.edit_appbar_done_text_style,
      cancelTextStyle: Styles.edit_appbar_cancel_text_style,
      itemExtent: Dimens.editPickerItemExtent,
      onConfirm: (picker, values) {
        setState(() {
          _selectedIndex = id;
          presenter.periodValue = picker.getSelectedValues().first;
        });
      },
    ).showModal(context);
  }
}

class PeriodData {
  int id;
  Period periodUnit;

  PeriodData(this.id, this.periodUnit);
}
