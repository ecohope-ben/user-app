import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:user_app/utils/time.dart';

import '../../style.dart';
import 'dob_select.dart';


class DatePicker extends StatefulWidget {
  final Function(int, int) onChange;
  final String? Function(String?)? validator;
  const DatePicker({required this.onChange, this.validator, super.key});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  final TextEditingController _controller = TextEditingController();
  Map<String, int>? result;
  Future<void> _selectBirthday(BuildContext context) async {

    result = await BirthdayOneStepPicker.show(context);

    if (result != null) {
      setState(() {
        widget.onChange(result?['month'] as int, result?['day'] as int);

        int? month = result?['month'];
        int? day = result?['day'];
        if(month != null && day != null){
          DateTime selectedDateTime = DateTime(2025, month, day);
          _controller.text = convertDateTimeToString(context, selectedDateTime, format: tr("format.date_day"));
        }
      });

      print(result?['month']);
      print(result?['day']);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 12),
      child: TextFormField(
        controller: _controller,
        validator: widget.validator,
        style: TextStyle(fontSize: 27),
        onTap: (){
          _selectBirthday(context);
        },
        readOnly: true,
        decoration: InputDecoration(
          hintText: tr("register.date_of_birth"),
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
        )
      ),
    );
  }
}