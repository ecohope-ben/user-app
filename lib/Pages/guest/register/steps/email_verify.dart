import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/registration_cubit.dart';
import '../../../../components/register/otp_input.dart';
import '../widgets.dart';

class EmailVerificationStep extends StatefulWidget {
  const EmailVerificationStep({super.key});

  @override
  State<EmailVerificationStep> createState() => _EmailVerificationStepState();
}

class _EmailVerificationStepState extends State<EmailVerificationStep> {

  String? _validateOTP(String? code) {
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

  void _submitOTP(String verificationCode){
    context.read<RegistrationCubit>().verifyEmailOtp(verificationCode);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final state = context.read<RegistrationCubit>().state;
        if(state is RegistrationInProgress && state.registration.email.otpSentAt == null) {
          context.read<RegistrationCubit>().requestEmailOtp();
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset("assets/icon/register_email.png", width: 180),
        TitleText(tr("register.check_your_email")),
        SubTitleText(tr("register.check_email_description")),
        OTPInput(validator: _validateOTP, submitOTP: _submitOTP),

      ],
    );
  }
}
