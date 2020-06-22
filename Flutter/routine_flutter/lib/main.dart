import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:routine_flutter/utils/consts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routine_flutter/repository/mainRepository.dart';
import 'package:routine_flutter/ui/splashscreen/splash_screen.dart';
import 'package:routine_flutter/utils/styles.dart';

import 'authentication/authenticationBloc.dart';

void main() {
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runApp(RoutineApp());
}

class RoutineApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainRepository _mainRepository = MainRepository();

    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            elevation: 0,
            textTheme: TextTheme(
              headline6: Styles.APP_BAR_TEXT,
            )),
        primaryIconTheme: IconThemeData(color: Colors.black87),
        primaryColor: ColorsRes.mainBgColor,
        scaffoldBackgroundColor: ColorsRes.mainBgColor,
      ),
      home: BlocProvider<AuthenticationBloc>(
        create: (context) => AuthenticationBloc(mainRepository: _mainRepository),
        child: SplashScreen(_mainRepository),
      ),
    );
  }
}
