import 'package:flutter/material.dart';

class Strings {
  static const String APP_NAME = 'Routine';

  static const String EDIT_CANCEL_BUTTON_TEXT = 'Cancel';
  static const String EDIT_DONE_BUTTON_TEXT = 'Done';
  static const String edit_text_input_hint = 'Type recurring task name...';
  static const String edit_input_error_message = 'Title should be not empty!';
  static const String edit_divider_label = 'Repeat';
  static const String editPickerDialogTitle = 'Select period...';

  static const String listEmptyPlaceholderText = "You don't have any tasks";
  static const String listResetSlideActionLabel = "Reset";
  static const String listDeleteSlideActionLabel = "Delete";
  static const String listDialogContentText =
      "Are You sure want to delete this task?";
  static const String listDialogActionCancel = "Cancel";
  static const String listDialogActionDelete = "Delete";
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
  static const double edit_period_button_vertical_padding = 32.0;
  static const double editPickerScale = 1.2;
}

class ColorsRes {
  static Color mainBgColor = Colors.grey[200];

  static Color selectedPeriodUnitColor = Colors.grey[800];
  static Color unselectedPeriodUnitColor = Colors.grey[400];
}
