import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user_app/models/discount/index.dart';
import 'package:user_app/utils/snack.dart';

import '../../style.dart';

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


/// Promotion code card to attract users to join subscription plan.
class PromotionCodeCard extends StatelessWidget {
  const PromotionCodeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            mainPurple,
            mainPurple.withValues(alpha: 0.85),
            purpleUnderline.withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.zero,
        boxShadow: [
          BoxShadow(
            color: mainPurple.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_offer_rounded, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Text(
                  tr('promote.limited_offer'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              tr('promote.card_description'),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.95),
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.zero,
                border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
              ),
              child: InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: Discount.instance().promotionCode ?? ""));
                  popSnackBar(context, tr('promotion_code_copied'));
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        Discount.instance().promotionCode ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          // letterSpacing: 2,
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.zero,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        child: Text(
                          tr('promote.copy_code'),
                          style: TextStyle(
                            color: mainPurple,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
