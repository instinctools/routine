import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:routine_flutter/errors/error_codes.dart';

import 'action_result.dart';

class ErrorHandler {
  bool _isConnected = false;
  StreamSubscription _subscription;

static final ErrorHandler instance = ErrorHandler._();

  ErrorHandler._() {
    _subscription = Connectivity().onConnectivityChanged.asBroadcastStream().listen((event) {
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
    switch (error.code) {
      case ErrorCodes.networkRequestFailed:
        return "Internet is not available!";
      default:
        return "${error.code} : ${error.message}";
    }
  }

  void clear() => _subscription.cancel();
}
