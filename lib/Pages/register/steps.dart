import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../../style.dart';

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

class TextInput extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  TextInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 12),
      child: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Your email address',
          hintStyle: TextStyle(fontSize: 27, color: Colors.grey),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.purple,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: purpleUnderline,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.purple,
            ),
          ),
        ),
        onChanged: (text) {
          // Perform actions when the text changes
          print('Current text: $text');
        },
        onSubmitted: (text) {
          // Perform actions when the user submits the text (e.g., presses Enter)
          print('Submitted text: $text');
        },
      ),
    );
  }
}

class OTPInput extends StatelessWidget {
  const OTPInput({super.key});

  @override
  Widget build(BuildContext context) {

    return OtpTextField(
      numberOfFields: 6,
      borderColor: purpleUnderline,
      focusedBorderColor: Colors.grey,

      enabledBorderColor: purpleUnderline,
      alignment: Alignment.bottomLeft,
      showFieldAsBox: false,
      borderWidth: 2.0,
      //runs when a code is typed in
      onCodeChanged: (String code) {
        //handle validation or checks here if necessary
      },
      //runs when every textfield is filled
      onSubmit: (String verificationCode) {

      },
    );
  }
}


class ActionButton extends StatelessWidget {
  final String title;
  const ActionButton(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 12),
      child: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: blueTextUnderline,
                width: 3 ,
              ),
            ),
          ),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero
              ),
            ),
            onPressed: (){

            },
            child: Text(title),
          )
        )
    );
  }
}

class EmailInputStep extends StatelessWidget {
  const EmailInputStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset("assets/icon/register_email.png", width: 180),
        TitleText(tr("register.email_address")),
        SubTitleText(tr("register.email_description")),
        TextInput(),
        ActionButton(tr("send_otp"))
      ],
    );
  }
}

class EmailVerificationStep extends StatelessWidget {
  const EmailVerificationStep({super.key});

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
        ActionButton(tr("verify_and_next"))
      ],
    );
  }
}

class PhoneInputStep extends StatelessWidget {
  const PhoneInputStep({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class PhoneVerificationStep extends StatelessWidget {
  const PhoneVerificationStep({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

