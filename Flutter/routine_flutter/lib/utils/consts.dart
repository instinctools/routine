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

  static const String emptyTodosPlaceholderTitle = "Oh! It's still empty";
  static const String emptyTodosPlaceholderSubtitle = "There are no routine tasks";

  static const String listResetSlideActionLabel = "Reset";
  static const String listDeleteSlideActionLabel = "Delete";
  static const String listDialogContentText = "Are You sure want to delete this task?";
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

  static const String splashScreenText = "Setting up account";
  static const String splashScreenFailureText = "An error occurred!";
  static const String splashScreenRetryButtonText = "Retry";

//  error handling
  static const String errorMessageDefault = "Something went wrong...";
  static const String errorMessageNetworkIsNotAvailable = " Internet is not available!";
}

class Dimens {
  static const double commonPaddingHalf = 4.0;
  static const double commonPadding = 8.0;
  static const double commonPaddingDouble = 16.0;
  static const double commonPaddingLarge = 32.0;
  static const double commonBorderRadius = 8.0;

  static const double listProgressSize = 20.0;

  static const double itemBoxBorderRadius = 8.0;

  static const double editDividerThickness = 2.0;
  static const double editPeriodButtonBorderRadius = 10.0;
  static const double editPickerItemExtent = 40;
  static const double editResetSelectorBorderRadius = 4.0;
  static const double editResetSelectorTextSize = 13;
  static const double splashScreenTextSize = 24;
  static const double splashScreenRetryButtonTextSize = 17;
  static const double splashScreenRetryButtonWidth = 156;
  static const double splashScreenRetryButtonHeight = 50;
}

class ColorsRes {
  static Color stdWhite = Colors.white;
  static Color stdBrown = Color(0xff835D51);

  static Color mainBgColor = Colors.grey[200];
  static Color darkGrayColor = Colors.grey[800];
  static Color lightGrayColor = Colors.grey[400];

  static Color selectedPeriodUnitColor = Colors.grey[800];
  static Color unselectedPeriodUnitColor = Colors.grey[400];

  static Color selectedResetTypeTextColor = Color(0xFFFFFFFF);
  static Color unselectedResetTypeTextColor = darkGrayColor;

  static Color selectedResetTypeBackgroundColor = darkGrayColor;
  static Color unselectedResetTypeBackgroundColor = lightGrayColor;

  static Color splashScreenTextColor = stdBrown;
  static Color splashScreenProgressBackgroundColor = stdBrown;
  static Color splashScreenProgressAnimationColor = Color(0xffBCA89A);
  static Color splashScreenRetryButtonTextColor = stdWhite;
  static Color splashScreenRetryButtonBackgroundColor = stdBrown;
}
