import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/registration_cubit.dart';
import '../../../../components/register/action_button.dart';
import '../../../../components/register/text_input.dart';
import '../widgets.dart';
class EmailInputStep extends StatefulWidget {
  const EmailInputStep({super.key});

  @override
  State<EmailInputStep> createState() => _EmailInputStepState();
}

class _EmailInputStepState extends State<EmailInputStep> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  // Email validation function
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return tr("validation.email_required"); // Add this translation key
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return tr("validation.email_invalid"); // Add this translation key
    }
    return null; // Return null if validation passes
  }

  @override
  void dispose() {
    _emailController.dispose();

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
          Image.asset("assets/icon/register_email.png", width: 180),
          TitleText(tr("register.email_address")),
          SubTitleText(tr("register.email_description")),
          TextInput(tr("register.your_email_address"), validator: _validateEmail, controller: _emailController),
      
          ActionButton(tr("send_otp"), onTap: () async {
            if (_formKey.currentState!.validate()) {
              // If validation passes, get the email and update registration
              final email = _emailController.text;

              final bloc = context.read<RegistrationCubit>();
              bloc.updateRegistration(email: email);

            }
          })
        ],
      ),
    );
  }
}