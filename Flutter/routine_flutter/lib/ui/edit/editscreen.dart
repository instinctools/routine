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

  TextEditingController _controller;
  final _titleFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

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
              onPressed: () => _titleFormKey.currentState.validate()
                  ? print('value = ${_controller.value.text}')
                  : print('validation failed'),
            )
          ],
        ),
      ),
      body: Center(
        child: TitleInputForm(_controller, _titleFormKey),
      ),
    );
  }
}

class TitleInputForm extends StatefulWidget {
  const TitleInputForm(this._controller, this._formKey, {Key key})
      : super(key: key);
  final TextEditingController _controller;
  final GlobalKey _formKey;

  @override
  _TitleInputFormState createState() => _TitleInputFormState();
}

class _TitleInputFormState extends State<TitleInputForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: TextFormField(
        controller: widget._controller,
        style: Styles.edit_input_text_style,
        keyboardType: TextInputType.text,
        validator: (value) =>
            value.isNotEmpty ? null : Strings.edit_input_error_message,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(),
            hintStyle: Styles.edit_input_text_style,
            hintText: Strings.edit_text_input_hint,
            errorStyle: Styles.edit_input_error_style),
      ),
    );
  }
}
