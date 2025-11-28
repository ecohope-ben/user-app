import 'package:flutter/material.dart';

class PaymentDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  const PaymentDetailRow(this.label, this.value, {this.isBold = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w700)),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
