import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../../style.dart';
import 'action_button.dart';

class OTPInput extends StatefulWidget {

  final String? Function(String?)? validator;
  final void Function(String) submitOTP;
  final bool showLoading;
  const OTPInput({this.validator, required this.submitOTP, required this.showLoading, super.key});

  @override
  State<OTPInput> createState() => _OTPInputState();
}

class _OTPInputState extends State<OTPInput> {
  String otp = "";
  String? _errorMessage;
  List<TextEditingController?> _controllers = [];

  // Helper method to get full OTP from all controllers
  String _getFullOtp() {
    return _controllers
        .map((controller) => controller?.text ?? '')
        .join('');
  }

  void onSubmit(String verificationCode){
    print("--otp: $verificationCode");
    print("--otp: $otp");
    // Validate OTP
    if (widget.validator != null) {
      final error = widget.validator!(verificationCode);
      setState(() {
        _errorMessage = error;
      });

      // Only verify if validation passes
      if (error == null) {
        print("--error is null");
        widget.submitOTP(verificationCode);
      }
    } else {
      // If no validator, directly verify
      widget.submitOTP(verificationCode);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        OtpTextField(
          numberOfFields: 6,
          borderColor: purpleUnderline,
          focusedBorderColor: Colors.grey,

          enabledBorderColor: purpleUnderline,
          alignment: Alignment.bottomLeft,
          showFieldAsBox: false,

          borderWidth: 2.0,
          //runs when a code is typed in
          onCodeChanged: (String code) {
            // Get full OTP from all controllers
            final fullOtp = _getFullOtp();
            print("--onOtpChange: $code");
            print("--fullOtp: $fullOtp");
            //handle validation or checks here if necessary
            setState(() {
              otp = fullOtp;
            });
          },
          handleControllers: (List<TextEditingController?> controllers){
            // Store controllers to access their values later
            _controllers = controllers;
          },
          //runs when every text field is filled
          onSubmit: onSubmit,
        ),
        SizedBox(height: 20),
        (_errorMessage != null) ? Text(_errorMessage ?? "", style: TextStyle(color: Colors.red)) : Container(),
        SizedBox(height: 20),
        ActionButton(tr("verify_and_next"), onTap: () => onSubmit(_getFullOtp()), showLoading: widget.showLoading)
      ],
    );
  }
}