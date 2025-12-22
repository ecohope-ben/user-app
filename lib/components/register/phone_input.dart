import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../style.dart';

class PhoneInput extends StatefulWidget {
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const PhoneInput({this.validator, this.controller, super.key});

  @override
  State<PhoneInput> createState() => _PhoneInputState();
}

class _PhoneInputState extends State<PhoneInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = widget.controller ?? TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 12),
      child: TextFormField(
        onTapOutside: (a){
          FocusManager.instance.primaryFocus?.unfocus();
        },
        controller: widget.controller,
        style: TextStyle(fontSize: 30),
        validator: widget.validator,
        maxLength: 8,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: tr("register.phone_number"),
          hintStyle: TextStyle(fontSize: 27, color: Colors.grey),
          prefixIcon: Padding(
              padding: EdgeInsets.only(top: 3, right: 8),
              child: Text("+852", style: TextStyle( fontSize: 30))),
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
