import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/style.dart';

import '../../../blocs/recycle_order_cubit.dart';
import '../../../models/payment_models.dart';
import '../../../models/recycle_models.dart';
import '../../../utils/time.dart';

class TransactionHistoryDetailsPage extends StatelessWidget {
  final PaymentListItem history;

  const TransactionHistoryDetailsPage(this.history, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainPurple,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => context.pop
        ),
        title: const Text(
          'Transaction Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        centerTitle: false,
      ),
      body: _buildBody(context, history)
    );
  }


  Widget _buildBody(BuildContext context, PaymentListItem history) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Order Number Section
            _buildLabel('Transaction ID'),
            const SizedBox(height: 4),
            Text(
              history.id,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 16),

            const Divider(thickness: 1, color: Colors.black12),
            const SizedBox(height: 16),

            _buildLabel('Type'),
            const SizedBox(height: 6),
            _buildValue(history.description),

            const SizedBox(height: 16),
            _buildLabel('Amount'),
            const SizedBox(height: 6),
            _buildValue("${history.currency} ${history.amountDecimal}"),
            const SizedBox(height: 16),

            _buildLabel('Transaction Date'),
            const SizedBox(height: 6),
            _buildValue(convertDateTimeToString(context, history.occurredAt, format: "dd MMM y | HH:mm")),

            const SizedBox(height: 20),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }


  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black54,
      ),
    );
  }


  Widget _buildValue(String text) {
    return Text(
      text,
      maxLines: null,
      style: const TextStyle(
        fontSize: 15,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        height: 1.3,
      ),
    );
  }
}