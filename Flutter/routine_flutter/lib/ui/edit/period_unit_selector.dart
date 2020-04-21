import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:routine_flutter/ui/edit/edit_presenter.dart';
import 'package:routine_flutter/ui/edit/period.dart';
import 'package:routine_flutter/utils/consts.dart';
import 'package:routine_flutter/utils/styles.dart';

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
    var isPlural = isSelected && presenter.periodValue > 1;

    var periodCount = isPlural ? '${presenter.periodValue} ' : '';
    var pluralPostfix = isPlural && name != Period.MONTH.name ? 's' : '';

    var periodText = 'Every $periodCount$name$pluralPostfix';
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
    print('Selected index = $id period = ${Period.values[id].name}');
    presenter.periodUnit = Period.values[id].name;
    _showPeriodPicker(context);
    _selectedIndex = id;
  }

  void _showPeriodPicker(BuildContext context) {
    Picker(
      adapter: NumberPickerAdapter(data: [
        NumberPickerColumn(
            begin: BEGIN_VALUE,
            end: END_VALUE,
            initValue: presenter.periodValue)
      ]),
      title: Text(Strings.editPickerDialogTitle),
      textScaleFactor: Dimens.editPickerScale,
      hideHeader: true,
      onConfirm: (picker, values) {
        setState(() {
          presenter.periodValue = picker.getSelectedValues().first;
        });
      },
    ).showDialog(context);
  }
}

class PeriodData {
  int id;
  Period periodUnit;

  PeriodData(this.id, this.periodUnit);
}
