import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routine_flutter/data/todo.dart';
import 'package:routine_flutter/repository/mainRepository.dart';

import 'edit_screen_bloc/edit_screen_bloc.dart';
import 'edit_screen_body.dart';

class EditScreen extends StatelessWidget {
  final Todo todo;
  final MainRepository _mainRepository;

  EditScreen({this.todo, MainRepository mainRepository})
      : assert(mainRepository != null),
        _mainRepository = mainRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<EditScreenBloc>(
        create: (context) => EditScreenBloc(mainRepository: _mainRepository),
        child: EditScreenBody(todo: todo),
      ),
    );
  }
}
