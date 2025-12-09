

import 'package:intl/intl.dart';

String convertToDateStringWithTz8(String? isoString) {
  if(isoString == null) return "";
  // Parse the ISO string into DateTime
  DateTime utcDate = DateTime.parse(isoString);
  // Convert to +8 timezone
  DateTime tz8Date = utcDate.toUtc().add(const Duration(hours: 8));
  // Format to dd-mm-yyyy
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String day = twoDigits(tz8Date.day);
  String month = twoDigits(tz8Date.month);
  String year = tz8Date.year.toString();
  return '$day-$month-$year';
}

String convertDateTimeToString(DateTime? dateTime, String format){
  if(dateTime == null) return "";
  DateTime? dateTime2 = dateTime.add(const Duration(hours: 8));
  var formatter = DateFormat(format, 'en_US');
  String formattedDate = formatter.format(dateTime2);
  return formattedDate;
}

/// 將 DateTime 轉成 yyyy-MM-dd HH:mm:ss 格式的 string
String dateTimeToString(DateTime? dateTime) {
  if(dateTime == null) return "";
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String year = dateTime.year.toString();
  String month = twoDigits(dateTime.month);
  String day = twoDigits(dateTime.day);
  String hour = twoDigits(dateTime.hour);
  String minute = twoDigits(dateTime.minute);
  String second = twoDigits(dateTime.second);
  return '$year-$month-$day $hour:$minute:$second';
}
