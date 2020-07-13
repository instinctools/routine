import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routine_flutter/data/todo.dart';
import 'package:routine_flutter/ui/edit/edit_presenter.dart';
import 'package:routine_flutter/ui/edit/edit_screen_bloc/edit_screen_bloc.dart';
import 'package:routine_flutter/ui/edit/period_unit_selector.dart';
import 'package:routine_flutter/ui/edit/resetSelector.dart';
import 'package:routine_flutter/utils/consts.dart';
import 'package:routine_flutter/utils/styles.dart';

import 'edit_screen_bloc/edit_screen_event.dart';
import 'edit_screen_bloc/edit_screen_state.dart';

class EditScreenBody extends StatefulWidget {
  final Todo todo;

  EditScreenBody({this.todo});

  @override
  State<EditScreenBody> createState() => _EditScreenBodyState();
}

class _EditScreenBodyState extends State<EditScreenBody> {
  final TextEditingController _titleTodoController = TextEditingController();
  EditPresenter editPresenter;

  EditScreenBloc _editScreenBloc;

  bool isDoneButtonEnabled(EditScreenState state) => state.isTitleTodoValid;

  @override
  void initState() {
    super.initState();
    editPresenter = EditPresenter(widget.todo);
    _editScreenBloc = BlocProvider.of<EditScreenBloc>(context);
    _titleTodoController.addListener(() {
      _editScreenBloc.add(
        EditScreenTitleTodoChanged(titleTodo: _titleTodoController.text),
      );
    });
    if (widget.todo != null) {
      _titleTodoController.text = widget.todo.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditScreenBloc, EditScreenState>(
      listener: (context, state) {
        if (state.isCancel) {
          Navigator.pop(context);
        }
        if (state.isSuccess) {
          Navigator.pop(context);
        }
        if (state.isFailure) {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => new AlertDialog(
              content: new Text(Strings.errorMessageDefault),
              actions: <Widget>[
                new FlatButton(
                  child: new Text(Strings.close),
                  onPressed: () {
                    _editScreenBloc.add(CloseErrorDialogPressed());
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
      },
      child: BlocBuilder<EditScreenBloc, EditScreenState>(
        builder: (context, state) {
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
                      Strings.editCancelButtonText,
                      style: Styles.edit_appbar_cancel_text_style,
                    ),
                    onPressed: () => _editScreenBloc.add(CancelPressed()),
                  ),
                  FlatButton(
                    child: Text(
                      Strings.editDoneButtonText,
                      style: Styles.edit_appbar_done_text_style,
                    ),
                    onPressed: state.isTitleTodoValid
                        ? () {
                            _editScreenBloc.add(DonePressed(todo: editPresenter.getTodo(_titleTodoController.text)));
                          }
                        : null,
                  )
                ],
              ),
            ),
            body: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    controller: _titleTodoController,
                    style: Styles.edit_input_text_style,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: Styles.edit_input_text_style,
                      hintText: Strings.editTextInputHint,
                      errorStyle: Styles.edit_input_error_style,
                    ),
                  ),
                  ResetSelector(editPresenter),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: DividerWithLabel(),
                  ),
                  PeriodUnitSelector(editPresenter)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _titleTodoController.dispose();
    super.dispose();
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
            margin: EdgeInsets.only(right: Dimens.commonPadding),
            child: Divider(thickness: Dimens.editDividerThickness, color: Colors.black26),
          ),
        ),
        Text(
          Strings.editDividerLabel,
          style: Styles.edit_divider_label_style,
        ),
        Expanded(
          flex: 4,
          child: Container(
            margin: EdgeInsets.only(left: Dimens.commonPadding),
            child: Divider(
              thickness: Dimens.editDividerThickness,
              color: Colors.black26,
            ),
          ),
        )
      ],
    );
  }
}
