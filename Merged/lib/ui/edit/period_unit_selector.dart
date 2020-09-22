import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:routine_flutter/ui/edit/edit_presenter.dart';
import 'package:routine_flutter/ui/edit/period_unit.dart';
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
  EditPresenter get _presenter => widget.presenter;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _createButtons(),
    );
  }

  List<Widget> _createButtons() {
    List<Widget> buttons = <Widget>[];
    PeriodUnit.values.forEach((periodUnit) {
      buttons.add(_createPeriodButton(periodUnit));
    });
    return buttons;
  }

  Widget _createPeriodButton(PeriodUnit periodUnit) {
    var name = periodUnit.name;
    var isSelected = _presenter.selectedPeriodUnit == periodUnit;
    var periodText = TimeUtils.getPrettyPeriodSelector(name, _presenter.valuesPeriods[periodUnit]);
    var bgColor = isSelected ? ColorsRes.selectedPeriodUnitColor : ColorsRes.unselectedPeriodUnitColor;
    var iconColor = isSelected ? ColorsRes.unselectedPeriodUnitColor : ColorsRes.selectedPeriodUnitColor;
    var textStyle = isSelected ? Styles.editUnselectedPeriodTextStyle : Styles.editSelectedPeriodTextStyle;

    return GestureDetector(
      onTap: () {
        _onPeriodClicked(periodUnit);
      },
      child: Container(
        margin: EdgeInsets.only(top: Dimens.commonPaddingDouble),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimens.editPeriodButtonBorderRadius), color: bgColor),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimens.commonPaddingDouble, vertical: Dimens.commonPaddingDouble),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  _showPeriodPicker(context, periodUnit);
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
        ),
      ),
    );
  }

  void _onPeriodClicked(PeriodUnit periodUnit) {
    print("_onPeriodClicked $periodUnit");
    setState(() {
      _presenter.selectedPeriodUnit = periodUnit;
    });
  }

  void _showPeriodPicker(BuildContext context, PeriodUnit periodUnit) {
    Picker(
      height: Dimens.periodPickerHeight,
      columnPadding: EdgeInsets.only(bottom: Dimens.bottomInset),
      adapter: NumberPickerAdapter(data: [NumberPickerColumn(begin: BEGIN_VALUE, end: END_VALUE, initValue: _presenter.valuesPeriods[periodUnit])]),
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
          _presenter.selectedPeriodUnit = periodUnit;
          _presenter.valuesPeriods[periodUnit] = picker.getSelectedValues().first;
        });
      },
    ).showModal(context);
  }
}
