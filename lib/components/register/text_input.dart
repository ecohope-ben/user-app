import 'package:flutter/material.dart';

import '../../style.dart';

class TextInput extends StatefulWidget {
  final String title;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  const TextInput(this.title, {this.validator, this.controller, super.key});

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  late final TextEditingController _controller;
  bool _isExternalController = false;

  @override
  void initState() {
    super.initState();
    // Use provided controller or create a new one
    _isExternalController = widget.controller != null;
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    // Only dispose if we created the controller ourselves
    if (!_isExternalController) {
      _controller.dispose();

    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 12),
      child: TextFormField(
        controller: _controller,
        validator: widget.validator,
        style: TextStyle(fontSize: 27),
        decoration: InputDecoration(
          hintText: widget.title,
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
        )
      ),
    );
  }
}

