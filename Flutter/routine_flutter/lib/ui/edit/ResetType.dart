enum ResetType {
  RESET_TO_PERIOD,
  RESET_TO_DATE,
}

extension ResetTypeExtension on ResetType {
  static const values = {
    ResetType.RESET_TO_PERIOD: "RESET_TO_PERIOD",
    ResetType.RESET_TO_DATE: "RESET_TO_DATE",
  };

  String get value => values[this];
}

ResetType findResetType(final String value) => ResetType.values.firstWhere((element) => element.value == value);
