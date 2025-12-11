import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../style.dart';
import '../register/dob_select.dart';


class ProfileDatePicker extends StatefulWidget {
  final Function(int, int) onChange;
  final String? Function(String?)? validator;
  final int? initialMonth;
  final int? initialDay;
  final bool showMainColor;
  const ProfileDatePicker({
    required this.onChange,
    this.validator,
    this.initialMonth,
    this.initialDay,
    this.showMainColor = true,
    super.key,
  });

  @override
  State<ProfileDatePicker> createState() => _ProfileDatePickerState();
}

class _ProfileDatePickerState extends State<ProfileDatePicker> {
  final TextEditingController _controller = TextEditingController();
  Map<String, int>? result;
  
  @override
  void initState() {
    super.initState();
    if (widget.initialMonth != null && widget.initialDay != null) {
      _controller.text = "${tr("month_to_words.${widget.initialMonth}")} ${widget.initialDay}";
    }
  }
  Future<void> _selectBirthday(BuildContext context) async {

    result = await BirthdayOneStepPicker.show(context);

    if (result != null) {
      setState(() {
        widget.onChange(result?['month'] as int, result?['day'] as int);

        int? month = result?['month'];
        int? day = result?['day'];
        _controller.text = "${tr("month_to_words.$month")} $day";
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
          onTap: (){
            _selectBirthday(context);
          },
          readOnly: true,
          decoration: InputDecoration(
            hintText: tr("register.date_of_birth"),
            hintStyle: TextStyle(color: Colors.grey),
            suffixIcon: Icon(Icons.calendar_month_outlined, color: widget.showMainColor ? mainPurple : Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(
                color: mainPurple
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(
                color: widget.showMainColor ? mainPurple : Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(
                color: mainPurple,
              ),
            ),
          )
      ),
    );
  }
}