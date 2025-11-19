import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/registration_cubit.dart';
import '../../../../components/register/action_button.dart';
import '../../../../components/register/otp_input.dart';
import '../../../../components/register/resend_button.dart';
import '../../../../models/registration_models.dart';
import '../../../../style.dart';
import '../../widgets.dart';


class PhoneVerificationStep extends StatefulWidget {
  const PhoneVerificationStep({super.key});

  @override
  State<PhoneVerificationStep> createState() => _PhoneVerificationStepState();
}

class _PhoneVerificationStepState extends State<PhoneVerificationStep> {
  String? phone;

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
    context.read<RegistrationCubit>().verifyPhoneOtp(verificationCode);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final state = context.read<RegistrationCubit>().state;
        if(state is RegistrationInProgress && state.registration.phone.otpSentAt == null) {
          phone = state.registration.phone.value;
          context.read<RegistrationCubit>().requestPhoneOtp();
        }
      }
    });
    super.initState();
  }

  void reSendOTP(){
    context.read<RegistrationCubit>().requestPhoneOtp();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset("assets/icon/register_phone.png", width: 180),
        TitleText(tr("register.verify_phone_number")),
        SubTitleText(tr("register.verify_phone_description", args: [phone ?? ""])),
        OTPInput(validator: _validateOTP, submitOTP: _submitOTP, showLoading: context.read<RegistrationCubit>().state is RegistrationInProgressLoading),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(tr("register.dont_receive_code")),
            ResendButton(reSendOTP),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () => context.read<RegistrationCubit>().changeStage(RegistrationStage.phoneInput),

                child: Text(tr("register.edit_phone", args: [phone ?? ""]), style: TextStyle(color: blueRegisterText))
            ),
          ],
        ),
      ],
    );
  }
}