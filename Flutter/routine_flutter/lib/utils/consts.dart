import 'package:flutter/material.dart';

class Strings {
  static const String appName = 'Routine';

  static const String editCancelButtonText = 'Cancel';
  static const String editDoneButtonText = 'Done';
  static const String editTextInputHint = 'Type recurring task name...';
  static const String editInputErrorMessage = 'Title should be not empty!';
  static const String editDividerLabel = 'Repeat every';
  static const String editPickerDialogTitle = 'Choose period';
  static const String editPickerDialogConfirmButton = 'Done';
  static const String editResetSelectorToPeriod = 'Reset to period';
  static const String editResetSelectorToDate = 'Reset to date';

  static const String listEmptyPlaceholderText = "You don't have any tasks";
  static const String listResetSlideActionLabel = "Reset";
  static const String listDeleteSlideActionLabel = "Delete";
  static const String listDialogContentText =
      "Are You sure want to delete this task?";
  static const String listDialogActionCancel = "Cancel";
  static const String listDialogActionDelete = "Delete";

  static const String todoKeyId = "id";
  static const String todoKeyPeriod = "period";
  static const String todoKeyPeriodUnit = "periodUnit";
  static const String todoKeyResetType = "resetType";
  static const String todoKeyTitle = "title";
  static const String todoKeyTargetDate = "targetDate";
  static const String todoKeyTimestamp = "timestamp";
  static const String todoKeyReference = "reference";
}

class Dimens {
  static const double commonPaddingHalf = 4.0;
  static const double commonPadding = 8.0;
  static const double commonPaddingDouble = 16.0;
  static const double commonPaddingLarge = 32.0;

  static const double listProgressSize = 20.0;

  static const double itemBoxBorderRadius = 8.0;

  static const double editDividerThickness = 2.0;
  static const double editPeriodButtonBorderRadius = 10.0;
  static const double editPickerItemExtent = 40;
  static const double editResetSelectorBorderRadius = 4.0;
  static const double editResetSelectorTextSize = 13;
}

class ColorsRes {
  static Color mainBgColor = Colors.grey[200];
  static Color darkGrayColor = Colors.grey[800];
  static Color lightGrayColor = Colors.grey[400];

  static Color selectedPeriodUnitColor = Colors.grey[800];
  static Color unselectedPeriodUnitColor = Colors.grey[400];

  static Color selectedResetTypeTextColor = Color(0xFFFFFFFF);
  static Color unselectedResetTypeTextColor = darkGrayColor;

  static Color selectedResetTypeBackgroundColor = darkGrayColor;
  static Color unselectedResetTypeBackgroundColor = lightGrayColor;
}
