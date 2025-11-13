import 'package:flutter/material.dart';

import '../../style.dart';

class PhoneInput extends StatefulWidget {
  final String title;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  const PhoneInput(this.title, {this.validator, this.controller, super.key});

  @override
  State<PhoneInput> createState() => _PhoneInputState();
}

class _PhoneInputState extends State<PhoneInput> {
  final TextEditingController _controller = TextEditingController();

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
        controller: _controller,
        validator: widget.validator,
        style: TextStyle(fontSize: 30),
        maxLength: 6,
        decoration: InputDecoration(
          hintText: widget.title,
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
        ),
        onChanged: (text) {
          // Perform actions when the text changes
          print('Current text: $text');
        }
      ),
    );
  }
}
