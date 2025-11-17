import 'package:flutter/material.dart'
;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/registration_cubit.dart';
import '../../style.dart';
class ActionButton extends StatefulWidget {
  final String title;
  final VoidCallback? onTap;
  final bool showLoading;
  const ActionButton(this.title, {this.showLoading = false, this.onTap, super.key});

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
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
              onPressed: widget.onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // if(context.read<RegistrationCubit>().state is RegistrationInProgressLoading)
                  if(widget.showLoading)
                    Container(
                      height: 20.0,
                      width: 20.0,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      ),
                    ),
                  Text(widget.title, style: TextStyle(color: Colors.white)),
                ],
              ),
            )
        )
    );
  }
}