import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../components/register/action_button.dart';

class CommonErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const CommonErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  message.isEmpty ? tr("error_text") : message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                ActionButton(tr("error.retry"), onTap: onRetry)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
