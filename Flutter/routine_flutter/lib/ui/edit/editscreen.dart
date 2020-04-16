import 'package:flutter/material.dart';
import 'package:routine_flutter/utils/consts.dart';
import 'package:routine_flutter/utils/styles.dart';

class EditScreen extends StatefulWidget {
  final String value;

  EditScreen(this.value);

  @override
  _EditScreenState createState() => _EditScreenState(value);
}

class _EditScreenState extends State<EditScreen> {
  String value;

  _EditScreenState(this.value);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: Text(
                Strings.EDIT_CANCEL_BUTTON_TEXT,
                style: Styles.edit_appbar_cancel_text_style,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text(
                Strings.EDIT_DONE_BUTTON_TEXT,
                style: Styles.edit_appbar_done_text_style,
              ),
              onPressed: () => print('Done clicked!!'),
            )
          ],
        ),
      ),
      body: Center(
        child: Text('Edit screen s here!! Value = $value'),
      ),
    );
  }
}
