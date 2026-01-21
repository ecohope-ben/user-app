import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../blocs/registration_cubit.dart';
import '../../../../components/register/action_button.dart';
import '../../../../components/register/text_input.dart';
import '../../../../utils/validator.dart';
import '../../widgets.dart';
class EmailInputStep extends StatefulWidget {
  const EmailInputStep({super.key});

  @override
  State<EmailInputStep> createState() => _EmailInputStepState();
}

class _EmailInputStepState extends State<EmailInputStep> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

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
          TextInput(tr("register.your_email_address"), validator: validateEmail, controller: _emailController),
          ActionButton(
              tr("send_otp"),
              showLoading: context.read<RegistrationCubit>().state is RegistrationInProgressLoading,
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  // If validation passes, get the email and update registration
                  final email = _emailController.text;

                  final prefs = await SharedPreferences.getInstance();
                  bool isAgreeMarketingUse = prefs.getBool('marketing_opt_in') ?? false;

                  if(mounted) {
                    final bloc = context.read<RegistrationCubit>();
                    bloc.updateRegistration(email: email, marketingOptIn: isAgreeMarketingUse);
                  }
                }
              })
        ],
      ),
    );
  }
}