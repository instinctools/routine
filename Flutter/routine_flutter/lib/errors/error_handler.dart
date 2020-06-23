import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:routine_flutter/errors/error_codes.dart';
import 'package:routine_flutter/utils/consts.dart';

import 'action_result.dart';

class ErrorHandler {
  bool _isConnected = false;
  StreamSubscription _subscription;

  static final ErrorHandler instance = ErrorHandler._();

  ErrorHandler._() {
    _subscription = Connectivity().onConnectivityChanged.asBroadcastStream().listen((event) {
      _isConnected = event != ConnectivityResult.none;
      print("set isconnected = $_isConnected");
    });
  }

  Future<bool> get isConnected async {
    return await Connectivity().checkConnectivity() != ConnectivityResult.none;
  }

  String getErrorMessage(Object error) {
    if (!_isConnected) {
      return Strings.errorMessageNetworkIsNotAvailable;
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
        return Strings.errorMessageNetworkIsNotAvailable;
      default:
        return "${error.code} : ${error.message}";
    }
  }

  void clear() => _subscription.cancel();
}
