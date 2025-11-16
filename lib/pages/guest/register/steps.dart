import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../components/register/action_button.dart';
import '../../../components/register/otp_input.dart';
import 'widgets.dart';





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

