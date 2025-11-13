import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../components/register/action_button.dart';
import '../widgets.dart';

class PhoneInputStep extends StatefulWidget {
  const PhoneInputStep({super.key});

  @override
  State<PhoneInputStep> createState() => _PhoneInputStepState();
}

class _PhoneInputStepState extends State<PhoneInputStep> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

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