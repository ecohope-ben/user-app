import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../../blocs/registration_cubit.dart';
import '../../pages/guest/register/widgets.dart';
import '../../style.dart';
import 'action_button.dart';

class OTPInput extends StatefulWidget {

  final String? Function(String?)? validator;
  final void Function(String) submitOTP;
  const OTPInput({this.validator, required this.submitOTP, super.key});

  @override
  State<OTPInput> createState() => _OTPInputState();
}

class _OTPInputState extends State<OTPInput> {
  String otp = "";
  String? _errorMessage;

  void onSubmit(String verificationCode){

    // Validate OTP
    if (widget.validator != null) {
      final error = widget.validator!(verificationCode);
      setState(() {
        _errorMessage = error;
      });

      // Only verify if validation passes
      if (error == null) {
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
            //handle validation or checks here if necessary
            otp = code;
          },
          //runs when every text field is filled
          onSubmit: onSubmit,
        ),
        SizedBox(height: 20),
        (_errorMessage != null) ? Text(_errorMessage ?? "", style: TextStyle(color: Colors.red)) : Container(),
        SizedBox(height: 20),
        ActionButton(tr("verify_and_next"), onTap: () => onSubmit(otp), showLoading: context.read<RegistrationCubit>().state is RegistrationInProgressLoading)
      ],
    );
  }
}