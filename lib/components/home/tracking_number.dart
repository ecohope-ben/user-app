import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/snack.dart';

class TrackingNumber extends StatelessWidget {
  final String? trackingNumber;
  const TrackingNumber(this.trackingNumber, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(trackingNumber != null) {
          Clipboard.setData(ClipboardData(text: trackingNumber!)).then((_) {
            popSnackBar(context, tr("tracking_number_copied"));
          });
        }
      },
      child: Container(
        color: Colors.grey.shade300,
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Wrap(
          children: [
            Text(
              tr("order.tracking_number"),
              style: const TextStyle(
                fontSize: 17,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 4,),
            Text(
              "#${trackingNumber ?? ""}",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(width: 4,),
            Icon(Icons.copy_sharp)
          ],
        ),
      ),
    );
  }
}
