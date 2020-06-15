import 'package:flutter/material.dart';

class Strings {
  static const String APP_NAME = 'Routine';

  static const String EDIT_CANCEL_BUTTON_TEXT = 'Cancel';
  static const String EDIT_DONE_BUTTON_TEXT = 'Done';
  static const String edit_text_input_hint = 'Type recurring task name...';
  static const String edit_input_error_message = 'Title should be not empty!';
  static const String edit_divider_label = 'Repeat every';
  static const String editPickerDialogTitle = 'Choose period';
  static const String editPickerDialogConfirmButton = 'Done';
  static const String edit_reset_selector_to_period = 'Reset to period';
  static const String edit_reset_selector_to_date = 'Reset to date';

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
}

class Dimens {
  static const double COMMON_PADDING_HALF = 4.0;
  static const double COMMON_PADDING = 8.0;
  static const double COMMON_PADDING_DOUBLE = 16.0;
  static const double COMMON_PADDING_LARGE = 32.0;

  static const double listProgressSize = 20.0;

  static const double ITEM_BOX_BORDER_RADIUS = 8.0;

  static const double edit_divider_thickness = 2.0;
  static const double edit_period_button_border_radius = 10.0;
  static const double editPickerItemExtent = 40;
  static const double EDIT_RESET_SELECTOR_BORDER_RADIUS = 4.0;
  static const double EDIT_RESET_SELECTOR_TEXT_SIZE = 13;
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
