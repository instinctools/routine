import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routine_flutter/data/db_helper.dart';
import 'package:routine_flutter/data/todo.dart';
import 'package:routine_flutter/ui/edit/edit_presenter.dart';
import 'package:routine_flutter/ui/edit/period_unit_selector.dart';
import 'package:routine_flutter/utils/consts.dart';
import 'package:routine_flutter/utils/styles.dart';

class EditScreen extends StatefulWidget {
  final Todo entry;

  EditScreen({this.entry});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  EditPresenter presenter;
  DatabaseHelper helper;

  @override
  void initState() {
    super.initState();
    presenter = EditPresenter(widget.entry);
    helper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              onPressed: () {
                doDone();
              },
            )
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TitleInputForm(presenter),
            Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: DividerWithLabel(),
            ),
            PeriodUnitSelector(presenter)
          ],
        ),
      ),
    );
  }

  void doDone() async {
    if (presenter.validateAndPrint()) {
      await helper.changeTodo(presenter.getResult());
      Navigator.pop(context, true);
    }
  }
}

class TitleInputForm extends StatefulWidget {
  const TitleInputForm(this.presenter, {Key key}) : super(key: key);
  final EditPresenter presenter;

  @override
  _TitleInputFormState createState() => _TitleInputFormState();
}

class _TitleInputFormState extends State<TitleInputForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.presenter.formKey,
      child: TextFormField(
        controller: widget.presenter.controller,
        style: Styles.edit_input_text_style,
        keyboardType: TextInputType.text,
        validator: (value) =>
            value.isNotEmpty ? null : Strings.edit_input_error_message,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: Styles.edit_input_text_style,
            hintText: Strings.edit_text_input_hint,
            errorStyle: Styles.edit_input_error_style),
      ),
    );
  }
}

class DividerWithLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.only(right: Dimens.COMMON_PADDING),
            child: Divider(
                thickness: Dimens.edit_divider_thickness,
                color: Colors.black26),
          ),
        ),
        Text(
          Strings.edit_divider_label,
          style: Styles.edit_divider_label_style,
        ),
        Expanded(
          flex: 4,
          child: Container(
            margin: EdgeInsets.only(left: Dimens.COMMON_PADDING),
            child: Divider(
              thickness: Dimens.edit_divider_thickness,
              color: Colors.black26,
            ),
          ),
        )
      ],
    );
  }
}
