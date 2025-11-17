import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../../../blocs/registration_cubit.dart';
import '../../../components/register/dob_select.dart';
import '../../../components/register/text_input.dart';
import '../../../style.dart';

class TitleText extends StatelessWidget {
  final String title;
  const TitleText(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}

class SubTitleText extends StatelessWidget {
  final String title;
  const SubTitleText(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 15
        ),
      ),
    );
  }
}


