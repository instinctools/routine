import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:routine_flutter/errors/error_codes.dart';
import 'package:routine_flutter/errors/error_handler.dart';

import 'action_result.dart';
import 'error_utils.dart';

extension FutureExt<T> on Future<T> {
  Future<ActionResult> wrapError({String logMessage = "wrap future error"}) async {
    ErrorHandler errorHandler = ErrorHandler.instance;
    try {
      if (!(await errorHandler.isConnectedAsync)) {
        throw PlatformException(code: ErrorCodes.networkRequestFailed);
      }
      await this;
      return ActionSuccess();
    } catch (e) {
      print("$logMessage : $e");
      return ActionFailure(errorHandler.getErrorMessage(e));
    }
  }

  FutureOr<T> checkAndShowFailure(BuildContext context) async {
    var result = await this;
    if (result is ActionFailure) {
      ErrorUtils.showError(context, message: null);
    }
    return result;
  }
}

extension StreamExt<T> on Stream<T> {
  Stream<ActionResult> wrapError({String logMessage = "wrap stream error"}) {
    ErrorHandler errorHandler = ErrorHandler.instance;
    return this.map((snap) {
      if (!errorHandler.isConnected) {
        throw PlatformException(code: ErrorCodes.networkRequestFailed);
      }
      return ActionSuccess(snap);
    }).handleError((error) {
      print("$logMessage : $error");
      return ActionFailure(errorHandler.getErrorMessage(error));
    });
  }
}
