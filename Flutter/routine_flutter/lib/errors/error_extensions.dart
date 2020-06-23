import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:routine_flutter/errors/error_codes.dart';
import 'package:routine_flutter/errors/error_handler.dart';

import 'action_result.dart';
import 'error_utils.dart';

extension FutureExt<T> on Future<T> {
  Future<ActionResult> wrapError([String logPrefix]) async {
    ErrorHandler errorHandler = ErrorHandler.instance;
    try {
      if (!(await errorHandler.isConnected)) {
        throw PlatformException(code: ErrorCodes.networkRequestFailed);
      }
      await this;
      return ActionSuccess();
    } catch (e) {
      print("$logPrefix : $e");
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
