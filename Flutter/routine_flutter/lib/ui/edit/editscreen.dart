import 'package:flutter/material.dart';

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
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text('Done'),
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
