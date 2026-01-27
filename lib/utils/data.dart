
Map<String, dynamic> cleanNullValueFromMap(Map<String, dynamic> payload) {
  payload.removeWhere((key, value) => value == null);
  return payload;
}
