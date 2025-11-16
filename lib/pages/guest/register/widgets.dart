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



class DatePicker extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  DatePicker({super.key});
  Future<void> _selectBirthday(BuildContext context) async {
    print("--select");
    final result = await BirthdayOneStepPicker.show(
      context,
    );
    print(result);
    if (result != null) {

        print(result['month']);
        print(result['day']);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 12),
      child: TextField(
        controller: _controller,
        style: TextStyle(fontSize: 27),
        onTap: (){
          _selectBirthday(context);
        },
        readOnly: true,
        decoration: const InputDecoration(
          hintText: 'Last Name',
          hintStyle: TextStyle(fontSize: 27, color: Colors.grey),
          suffixIcon: Icon(Icons.calendar_month_outlined, color: purpleUnderline),
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

class ProfileInput extends StatelessWidget {
  const ProfileInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name row
        Row(
          children: [
            Expanded(
              flex: 1,
              child: TextInput(tr("first_name"))
            ),
            SizedBox(width: 20),
            Expanded(
              flex: 1,
                child: TextInput(tr("last_name"))
            )
          ],
        ),

        // Gender
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: purpleUnderline,
                width: 1,
              ),
            ),
          ),
          child: DropdownButton(
            underline: Container(),
            icon: Icon(Icons.keyboard_arrow_down_sharp, size: 30, color: purpleUnderline, fontWeight: FontWeight.normal),
            hint: Padding(
                padding: EdgeInsets.all(0),
                child: Text("Gender ", style: TextStyle(fontSize: 30, color: Colors.grey, fontWeight: FontWeight.normal))
            ),

            items: const [
              DropdownMenuItem(value: 'option1', child: Text('Option 1')),
              DropdownMenuItem(value: 'option2', child: Text('Option 2')),
              DropdownMenuItem(value: 'option3', child: Text('Option 3')),
            ],
            onChanged: (value) {

            },
          ),
        ),
        DatePicker()

      ],
    );
  }
}

