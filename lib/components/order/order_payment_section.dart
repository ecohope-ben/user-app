import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class OrderPaymentSection extends StatefulWidget {
  const OrderPaymentSection({super.key});

  @override
  State<OrderPaymentSection> createState() => _OrderPaymentSectionState();
}

class _OrderPaymentSectionState extends State<OrderPaymentSection> {
  Widget _buildTitle(){
    return Row(
      children: [
        Text(
          tr("order.payment_details"),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentItem(double amount){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("單次上門回收費用"),
          Text("\$$amount", style: TextStyle(fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Widget _buildTotal(double amount){
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black12,
        border: Border.all(color: Colors.black12)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("總計"),
          Text("\$$amount", style: TextStyle(fontWeight: FontWeight.bold))
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitle(),
        SizedBox(height: 10),
        _buildPaymentItem(50),
        Divider(),
        _buildTotal(50)
      ],
    );
  }
}
