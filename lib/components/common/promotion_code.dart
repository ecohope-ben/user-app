import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PromotionCodeInput extends StatelessWidget {
  final VoidCallback onTap;
  final TextEditingController controller;
  final bool isLoading;
  const PromotionCodeInput({required this.onTap, required this.controller, required this.isLoading, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            controller: controller,
            onTapOutside: (a){
              FocusManager.instance.primaryFocus?.unfocus();
            },
            maxLines: 1,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8)
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.black,
            child: TextButton(
                onPressed: onTap,
                child: isLoading ? SizedBox(
                    height: 30.0,
                    width: 30.0,
                    child: Center(child: CircularProgressIndicator(color: Colors.white))) : Text(tr("apply"))
            ),
          ),
        )
      ],
    );
  }
}

class PromotionCodeName extends StatelessWidget {
  final String title;
  final VoidCallback onClose;
  const PromotionCodeName(this.title, {required this.onClose, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: EdgeInsets.all(8),
      color: Colors.black,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: TextStyle(color: Colors.white),),
          SizedBox(width: 10),
          InkWell(
            onTap: onClose,
            child: Icon(Icons.close, color: Colors.white, size: 18,)
          ),
        ],
      ),
    );
  }
}
