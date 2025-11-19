import 'package:easy_localization/easy_localization.dart';

// Email validation function
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return tr("validation.email_required"); // Add this translation key
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return tr("validation.email_invalid"); // Add this translation key
  }
  return null; // Return null if validation passes
}

String? validateOTP(String? code) {
  if (code == null || code.isEmpty || code == "") {
    return tr("validation.otp_required");
  }
  if (code.length != 6) {
    return tr("validation.otp_incomplete");
  }
  // Check if OTP contains only digits
  if (!RegExp(r'^\d+$').hasMatch(code)) {
    return tr("validation.otp_invalid_format");
  }
  return null; // Return null if validation passes
}