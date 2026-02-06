import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/style.dart';

import '../../../models/payment_models.dart';
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
            onPressed: () => context.pop()
        ),
        title: Text(
          tr("transaction.details"),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
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
            _buildLabel(tr("transaction.id")),
            const SizedBox(height: 4),
            Text(
              history.id,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 16),

            const Divider(thickness: 1, color: Colors.black12),
            const SizedBox(height: 16),

            _buildLabel(tr("transaction.type")),
            const SizedBox(height: 6),
            _buildValue(history.description),

            const SizedBox(height: 16),

            _buildLabel(tr("transaction.amount")),
            const SizedBox(height: 6),
            _buildValue("${history.currency} ${history.amountDecimal}"),
            const SizedBox(height: 16),

            _buildLabel(tr("transaction.date")),
            const SizedBox(height: 6),
            _buildValue(convertDateTimeToString(context, history.occurredAt, format: tr("format.date_time"))),

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