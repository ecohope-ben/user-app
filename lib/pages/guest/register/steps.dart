import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import '../../../blocs/registration_cubit.dart';
import '../../../components/register/text_input.dart';
import 'widgets.dart';
import '../../../style.dart';



class PhoneInputStep extends StatelessWidget {
  const PhoneInputStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset("assets/icon/register_phone.png", width: 150),
        TitleText(tr("register.phone_number")),
        SubTitleText(tr("register.phone_description")),
        PhoneInput(),
        SizedBox(height: 20),
        ActionButton(tr("send_otp"))
      ],
    );
  }
}

class PhoneVerificationStep extends StatelessWidget {
  const PhoneVerificationStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset("assets/icon/register_phone.png", width: 180),
        TitleText(tr("register.verify_phone_number")),
        SubTitleText(tr("register.verify_phone_description")),
        OTPInput(),
        SizedBox(height: 20),
        ActionButton(tr("verify_and_next"))
      ],
    );
  }
}

class CreateProfileStep extends StatelessWidget {
  const CreateProfileStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset("assets/icon/register_profile.png", width: 140),
        TitleText(tr("register.profile")),
        SubTitleText(tr("register.profile_description")),
        ProfileInput(),
        SizedBox(height: 20),
        ActionButton(tr("verify_and_next"))
      ],
    );
  }
}

