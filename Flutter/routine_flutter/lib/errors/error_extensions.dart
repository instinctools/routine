import 'package:flutter/material.dart';
import 'package:routine_flutter/errors/error_handler.dart';

import 'action_result.dart';
import 'error_utils.dart';

extension FutureExt<T> on Future<T> {
  Future<ActionResult> wrapError([String logPrefix]) async {
    try {
      await this;
      return ActionSuccess();
    } catch (e) {
      print("$logPrefix : $e");
      return ActionFailure(ErrorHandler.instance.getErrorMessage(e));
    }
  }

  void checkAndShowFailure(BuildContext context) async {
    var result = await this;
    if (result is ActionFailure) {
      ErrorUtils.showError(context, message: null);
    }
  }
}