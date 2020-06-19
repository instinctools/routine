import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

import 'action_result.dart';

class ErrorHandler {
  bool _isConnected;
  StreamSubscription _subscription;

  ErrorHandler() {
    _subscription = Connectivity().onConnectivityChanged
        .asBroadcastStream()
        .listen((event) {
      _isConnected = event != ConnectivityResult.none;
    });
  }

  String getErrorMessage(Object error) {
    if (!_isConnected) {
      return " Internet is not available!";
    }
    if (error is PlatformException) {
      return _handlePlatformException(error);
    } else {
      return ActionFailure().message;
    }
  }

  String _handlePlatformException(PlatformException error) {
//    in future will contain a big switch - case with different error codes
    return "${error.code} : ${error.message}";
  }

  void clear() => _subscription.cancel();
}
