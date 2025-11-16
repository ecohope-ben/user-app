import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/registration_cubit.dart';
import '../../../../components/register/action_button.dart';
import '../../../../components/register/phone_input.dart';
import '../widgets.dart';

class PhoneInputStep extends StatefulWidget {
  const PhoneInputStep({super.key});

  @override
  State<PhoneInputStep> createState() => _PhoneInputStepState();
}

class _PhoneInputStepState extends State<PhoneInputStep> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();


  String? hkPhoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return tr('register.phone_required'); // or provide your own default message
    }
    final pattern = RegExp(r'^[4-9][0-9]{7}$');
    if (!pattern.hasMatch(value)) {
      return tr('register.invalid_phone_hk'); // or provide your own default message
    }
    return null;
  }


  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset("assets/icon/register_phone.png", width: 150),
          TitleText(tr("register.phone_number")),
          SubTitleText(tr("register.phone_description")),
          PhoneInput(controller: _phoneController, validator: hkPhoneValidator),
          SizedBox(height: 20),
          ActionButton(tr("send_otp"), onTap: () async {
            if (_formKey.currentState!.validate()) {
              // If validation passes, get the email and update registration
              final phone = "+852${_phoneController.text}";
              final bloc = context.read<RegistrationCubit>();
              bloc.updateRegistration(phone: phone);
            }
          })
        ],
      ),
    );
  }
}