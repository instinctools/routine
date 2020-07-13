import 'package:meta/meta.dart';

@immutable
class EditScreenState {
  final bool isTitleTodoValid;
  final bool isCancel;
  final bool isSuccess;
  final bool isFailure;

  EditScreenState({
    @required this.isTitleTodoValid,
    @required this.isCancel,
    @required this.isSuccess,
    @required this.isFailure,
  });

  factory EditScreenState.initial() {
    return EditScreenState(
      isTitleTodoValid: false,
      isCancel: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  EditScreenState update({bool isTitleTodoValid, bool isCancel, bool isSuccess, bool isFailure}) {
    return copyWith(
      isTitleTodoValid: isTitleTodoValid,
      isCancel: isCancel,
      isSuccess: isSuccess,
      isFailure: isFailure,
    );
  }

  EditScreenState copyWith({
    bool isTitleTodoValid,
    bool isCancel,
    bool isSuccess,
    bool isFailure,
  }) {
    return EditScreenState(
      isTitleTodoValid: isTitleTodoValid ?? this.isTitleTodoValid,
      isCancel: isCancel ?? this.isCancel,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return 'EditScreenState{isTitleTodoValid: $isTitleTodoValid, isCancel: $isCancel, isSuccess: $isSuccess, isFailure: $isFailure}';
  }
}
