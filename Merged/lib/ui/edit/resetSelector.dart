import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routine_flutter/ui/edit/edit_presenter.dart';
import 'package:routine_flutter/utils/consts.dart';
import 'package:routine_flutter/utils/styles.dart';

import 'resetType.dart';

class ResetSelector extends StatefulWidget {
  final EditPresenter _presenter;

  ResetSelector(this._presenter);

  @override
  State<StatefulWidget> createState() => _ResetSelectorState(_presenter);
}

class _ResetSelectorState extends State<ResetSelector> {
  final EditPresenter _presenter;

  _ResetSelectorState(this._presenter);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              onPressed: () => _setResetType(ResetType.RESET_TO_PERIOD, _presenter.resetType),
              color: _setBackgroundColor(ResetType.RESET_TO_PERIOD, _presenter.resetType),
              textColor: _setTextColor(ResetType.RESET_TO_PERIOD, _presenter.resetType),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimens.editResetSelectorBorderRadius),
                  bottomLeft: Radius.circular(Dimens.editResetSelectorBorderRadius),
                ),
              ),
              child: Text(
                Strings.editResetSelectorToPeriod,
                style: Styles.editResetTypeTextStyle,
              ),
            ),
          ),
          Expanded(
            child: FlatButton(
              onPressed: () => _setResetType(ResetType.RESET_TO_DATE, _presenter.resetType),
              color: _setBackgroundColor(ResetType.RESET_TO_DATE, _presenter.resetType),
              textColor: _setTextColor(ResetType.RESET_TO_DATE, _presenter.resetType),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(Dimens.editResetSelectorBorderRadius),
                  bottomRight: Radius.circular(Dimens.editResetSelectorBorderRadius),
                ),
              ),
              child: Text(
                Strings.editResetSelectorToDate,
                style: Styles.editResetTypeTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _setResetType(final ResetType selectedResetType, final ResetType actual) {
    print("on $selectedResetType clicked");
    if (selectedResetType != actual) {
      setState(() => _presenter.resetType = selectedResetType);
    }
  }
}

_setBackgroundColor(final ResetType current, final ResetType actual) =>
    current == actual ? ColorsRes.selectedResetTypeBackgroundColor : ColorsRes.unselectedResetTypeBackgroundColor;

_setTextColor(final ResetType current, final ResetType actual) => current == actual ? ColorsRes.selectedResetTypeTextColor : ColorsRes.unselectedResetTypeTextColor;