abstract class ActionResult {
  String message;

  ActionResult([this.message]);
}

class ActionSuccess extends ActionResult {}

class ActionFailure extends ActionResult {
  ActionFailure([String message = "Something went wrong"]) : super(message);
}