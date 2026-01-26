import 'package:flutter/material.dart'
;

import '../../style.dart';
class ActionButton extends StatefulWidget {
  final String title;
  final VoidCallback? onTap;
  final bool showLoading;
  final bool disable;
  final bool needPadding;
  final Widget? icon;
  const ActionButton(this.title, {this.showLoading = false, this.needPadding = true, this.disable = false, this.onTap, this.icon, super.key});

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: (widget.needPadding) ? const EdgeInsets.only(bottom: 12.0, top: 12) :  const EdgeInsets.all(0),
        child: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: widget.disable ? Colors.white : blueTextUnderline,
                  width: 3 ,
                ),
              ),
            ),
            child: TextButton.icon(

              style: TextButton.styleFrom(
                backgroundColor: widget.disable ? Colors.black26 : Colors.black,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero
                ),
              ),
              onPressed: widget.showLoading ? null : widget.onTap,
              icon: widget.icon,
              label: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
              ),
            )
        )
    );
  }
}