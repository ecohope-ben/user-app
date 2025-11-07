import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/registration_cubit.dart';
import '../widgets.dart';

class EmailVerificationStep extends StatefulWidget {
  const EmailVerificationStep({super.key});

  @override
  State<EmailVerificationStep> createState() => _EmailVerificationStepState();
}

class _EmailVerificationStepState extends State<EmailVerificationStep> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset("assets/icon/register_email.png", width: 180),
        TitleText(tr("register.check_your_email")),
        SubTitleText(tr("register.check_email_description")),
        OTPInput(),
        SizedBox(height: 20),
        ActionButton(tr("verify_and_next"), onTap: (){

        },)
      ],
    );
  }
}
