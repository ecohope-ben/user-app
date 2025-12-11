import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';

import '../../../blocs/subscription_cubit.dart';
import '../../../models/subscription_models.dart';
import '../../../style.dart';
import '../../../utils/pop_up.dart';

class SubscriptionChangePaymentMethod extends StatelessWidget {
  final String subscriptionId;

  const SubscriptionChangePaymentMethod({
    super.key,
    required this.subscriptionId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubscriptionCubit(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainPurple,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            "Change Payment Method",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: _ChangePaymentMethodView(subscriptionId: subscriptionId),
      ),
    );
  }
}

class _ChangePaymentMethodView extends StatefulWidget {
  final String subscriptionId;

  const _ChangePaymentMethodView({required this.subscriptionId});

  @override
  State<_ChangePaymentMethodView> createState() =>
      _ChangePaymentMethodViewState();
}

class _ChangePaymentMethodViewState extends State<_ChangePaymentMethodView> {
  String? _setupIntentId;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Request payment method update when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubscriptionCubit>().requestPaymentMethodUpdate(
            widget.subscriptionId,
          );
    });
  }

  Future<void> _presentPaymentSheet(String setupIntentClientSecret) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'Eco Hope',
          setupIntentClientSecret: setupIntentClientSecret,
          allowsDelayedPaymentMethods: true,
        ),
      );

      // Show Stripe's native UI
      await Stripe.instance.presentPaymentSheet();
      
      // Payment sheet completed successfully, now complete the update
      if (_setupIntentId != null && mounted) {
        final cubit = context.read<SubscriptionCubit>();
        await cubit.completePaymentMethodUpdate(
          widget.subscriptionId,
          CompletePaymentMethodUpdateRequest(
            setupIntentId: _setupIntentId!,
          ),
        );
      }
    } on StripeException catch (e) {
      // Handle Stripe-specific errors
      if (mounted) {
        // Check if user cancelled (StripeException with specific error code)
        final errorCode = e.error.code;
        print("--error code: ${errorCode}");
        if (errorCode == FailureCode.Canceled) {
          // User cancelled, just go back silently
          context.pop();
        } else {
          // Other Stripe errors - show error message
          await showForcePopup(
            context,
            title: '錯誤',
            message: e.error.message ?? '更改付款方法失敗',
          );
        }
      }
    } catch (e) {
      // For other exceptions, check if it's a cancellation
      if (mounted) {
        final errorString = e.toString().toLowerCase();
        if (errorString.contains('cancel') || 
            errorString.contains('user') && errorString.contains('cancel')) {
          // User cancelled, go back
          context.pop();
        } else {
          // Other errors
          await showForcePopup(
            context,
            title: '錯誤',
            message: '更改付款方法時發生錯誤: ${e.toString()}',
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubscriptionCubit, SubscriptionState>(
      listener: (context, state) {
        if (state is SubscriptionPaymentMethodUpdateRequested) {
          // Store setup intent ID for later use
          _setupIntentId = state.request.setupIntentId;
          
          // Present Stripe payment sheet
          _presentPaymentSheet(state.request.setupIntentClientSecret);
        } else if (state is SubscriptionActionSuccess &&
            state.action == 'complete_payment_method_update') {
          // Payment method update completed successfully
          if (mounted) {
            showForcePopup(
              context,
              title: '成功',
              message: '付款方式已成功更新！',
              onConfirm: () {
                context.pop(true); // Return true to indicate success
              },
            );
          }
        } else if (state is SubscriptionError) {
          // Handle error
          if (mounted && !_isProcessing) {
            showForcePopup(
              context,
              title: '錯誤',
              message: state.message,
            );
          }
        }
      },
      child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
        builder: (context, state) {
          if (state is SubscriptionLoading) {
            _isProcessing = true;
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('處理中...'),
                ],
              ),
            );
          }

          _isProcessing = false;

          if (state is SubscriptionError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '發生錯誤',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SubscriptionCubit>().requestPaymentMethodUpdate(
                            widget.subscriptionId,
                          );
                    },
                    child: const Text('重試'),
                  ),
                ],
              ),
            );
          }

          // Default state - show loading or waiting for payment sheet
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('準備更改付款方法...'),
              ],
            ),
          );
        },
      ),
    );
  }
}
