import 'package:flutter/cupertino.dart';
import 'package:routine_flutter/utils/consts.dart';
import 'package:routine_flutter/utils/styles.dart';

class EmptyTodoPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/bg_empty_todos.png'),
            _getTextField(
              Strings.emptyTodosPlaceholderTitle,
              Styles.emptyTodosPlaceholderTitle,
            ),
            _getTextField(Strings.emptyTodosPlaceholderSubtitle, Styles.emptyTodosPlaceholderSubtitle)
          ],
        ),
      );

  Widget _getTextField(String text, TextStyle style) {
    return Padding(padding: EdgeInsets.only(top: Dimens.COMMON_PADDING), child: Text(text, style: style));
  }
}
