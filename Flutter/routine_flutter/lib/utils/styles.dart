import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routine_flutter/utils/consts.dart';

class Styles {
  static const APP_BAR_TEXT = TextStyle(
      color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 32.0);

  // ignore: non_constant_identifier_names
  static TextStyle TODO_ITEM_TITLE_TEXT =
      TextStyle(color: Colors.white.withOpacity(0.95), fontSize: 19.0);

  static const TODO_ITEM_TIME_TEXT = TextStyle(
    color: Colors.white54,
    fontSize: 14.0,
  );

  static const edit_appbar_done_text_style =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0);

  static const edit_appbar_cancel_text_style =
      TextStyle(fontWeight: FontWeight.w400, fontSize: 18.0);

  static const edit_input_text_style = TextStyle(fontSize: 25.0);

  static const edit_input_error_style =
      TextStyle(fontWeight: FontWeight.w400, fontSize: 18.0);

  static const edit_divider_label_style = TextStyle(
      fontWeight: FontWeight.w500, fontSize: 16.0, color: Colors.black38);

  static TextStyle editSelectedPeriodTextStyle = TextStyle(
      fontWeight: FontWeight.w500, fontSize: 20.0, color: ColorsRes.selectedPeriodUnitColor);

  static TextStyle  editUnselectedPeriodTextStyle = TextStyle(
      fontWeight: FontWeight.w500, fontSize: 20.0, color: ColorsRes.unselectedPeriodUnitColor);
}
