import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/components/subscription/address.dart';
import 'package:user_app/components/subscription/features.dart';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:user_app/components/subscription/preview.dart';
import 'package:user_app/routes.dart';
import '../../api/index.dart';
import '../../api/endpoints/subscription_api.dart';
import '../../components/subscription/payment_detail_row.dart';
import '../../models/logistics_models.dart';
import '../../models/subscription_models.dart';
import '../../style.dart';
import '../../utils/pop_up.dart';
import '../../utils/snack.dart';
import '../../utils/time.dart';

class SubscriptionSignUp extends StatefulWidget {
  final PlanListItem plan;
  final List<String> features;
  const SubscriptionSignUp({super.key, required this.plan, required this.features});

  @override
  State<SubscriptionSignUp> createState() => _SubscriptionSignUpState();
}

class _SubscriptionSignUpState extends State<SubscriptionSignUp> {

  // API instances
  final _logisticsApi = Api.instance().logistics();
  final _subscriptionApi = Api.instance().subscription();

  // Loading states
  bool _isLoadingDistricts = true;
  bool _isLoadingPreview = true;
  bool _isCreatingSubscription = false;
  bool _isCheckingActivation = false;
  String? _districtsError;
  String? _previewError;
  bool _hasAcceptedTerms = false;

  // Timer for polling activation status
  Timer? _activationCheckTimer;

  // District data
  List<District> _districts = [];
  District? _selectedDistrict;
  SubDistrict? _selectedSubDistrict;

  // Preview data
  PreviewSubscriptionResponse? _previewData;

  final TextEditingController addressController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadDistricts(),
      _loadPreview(),
    ]);
  }

  Future<void> _loadDistricts() async {
    setState(() {
      _isLoadingDistricts = true;
      _districtsError = null;
    });

    try {
      final envelope = await _logisticsApi.listDistricts();
      setState(() {
        _districts = envelope.data;
        _isLoadingDistricts = false;
        // Set default selection if available
        // if (_districts.isNotEmpty) {
        //   _selectedDistrict = _districts.first;
        //   if (_selectedDistrict!.subDistricts.isNotEmpty) {
        //     _selectedSubDistrict = _selectedDistrict!.subDistricts.first;
        //   }
        // }
      });
    } catch (e) {
      setState(() {
        _isLoadingDistricts = false;
        _districtsError = e.toString();
      });
    }
  }

  Future<void> _loadPreview() async {
    setState(() {
      _isLoadingPreview = true;
      _previewError = null;
    });

    try {
      final request = PreviewSubscriptionCreationRequest(
        planId: widget.plan.id,
        planVersionId: widget.plan.versionId,
        discountId: widget.plan.discount?.id,
      );
      print("--preview request");
      print(widget.plan.id);
      print(widget.plan.versionId);
      print(widget.plan.discount?.id);
      final preview = await _subscriptionApi.previewSubscription(request: request);
      setState(() {
        _previewData = preview;
        _isLoadingPreview = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingPreview = false;
        _previewError = e.toString();
      });
    }
  }

  void _onDistrictChanged(District? district) {
    setState(() {
      _selectedDistrict = district;
      _selectedSubDistrict = district?.subDistricts.isNotEmpty == true
          ? district!.subDistricts.first
          : null;
    });
  }

  void _onSubDistrictChanged(SubDistrict? subDistrict) {
    setState(() {
      _selectedSubDistrict = subDistrict;
    });
  }

  // String _formatDate(DateTime date) {
  //   const months = [
  //     'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  //     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  //   ];
  //   return '${date.day} ${months[date.month - 1]} ${date.year}';
  // }

  String _formatAmount(int amount, String currency) {
    final formatted = (amount / 100).toStringAsFixed(2);
    return '$currency$formatted';
  }

  String _getBillingCycleText() {
    return widget.plan.billingCycle == BillingCycle.monthly
        ? tr("subscription.monthly")
        : tr("subscription.yearly");
  }

  String _getRenewalText() {
    if (_previewData == null) return '';
    return convertDateTimeToString(context, _previewData!.periodEnd);
  }

  String _getAmountText() {
    if (_previewData == null) return '';
    if (!_previewData!.requirePayment) {
      return tr("subscription.amount_text_with_discount", args: [_formatAmount(_previewData!.amount, _previewData!.currency), convertDateTimeToString(context, _previewData!.periodEnd), widget.plan.priceDecimal]) ;
      // return '${_formatAmount(_previewData!.amount, _previewData!.currency)} | pay nothing until ${_formatDate(_previewData!.periodEnd)}, then \$${widget.plan.priceDecimal}/Month';
    }
    return _formatAmount(_previewData!.amount, _previewData!.currency);
  }

  String _getAutoRenewText() {
    final cycle = widget.plan.billingCycle == BillingCycle.monthly ? tr("subscription.billing_cycle.monthly") : tr("subscription.billing_cycle.yearly");
    return tr("subscription.auto_renew_text", args: [cycle]);
  }

  Future<void> presentSubscriptionSheet({String? paymentIntentClientSecret, String? setupIntentClientSecret}) async {

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        merchantDisplayName: 'Eco Hope',
        // This is a PaymentIntent flow for the first subscription invoice:
        paymentIntentClientSecret: paymentIntentClientSecret,
        setupIntentClientSecret: setupIntentClientSecret,
        allowsDelayedPaymentMethods: true, // optional
        style: ThemeMode.light
      ),
    );

    // Shows Stripe’s native UI
    await Stripe.instance.presentPaymentSheet();
    print("--payment finished");
  }

  Future<void> _createSubscription() async {


    // Validate required fields
    if (_selectedDistrict == null) {
      popSnackBar(context, tr("validation.select_region"));
      return;
    }

    if (_selectedSubDistrict == null) {
      popSnackBar(context, tr("validation.select_district"));
      return;
    }

    final address = addressController.text.trim();
    if (address.isEmpty) {
      popSnackBar(context, tr("validation.input_address"));
      return;
    }

    if (!_hasAcceptedTerms) {
      popSnackBar(context, tr("validation.agree_terms"));
      return;
    }

    if (_previewData == null) {
      popSnackBar(context, tr("error.preview_not_load"));
      return;
    }

    setState(() {
      _isCreatingSubscription = true;
    });

    try {
      final request = CreateSubscriptionRequest(
        planId: widget.plan.id,
        planVersionId: widget.plan.versionId,
        districtId: _selectedDistrict!.id,
        subDistrictId: _selectedSubDistrict!.id,
        address: address,
        discountId: widget.plan.discount?.id,
        amount: _previewData!.amount,
        currency: _previewData!.currency,
      );

      final response = await _subscriptionApi.createSubscription(request: request);

      setState(() {
        _isCreatingSubscription = false;
      });

      // Handle success - navigate to payment or show success message
      // Based on nextAction, you may need to navigate to payment page
      // For now, show success and navigate back
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tr("subscription.subscription_created", args: [response.subscriptionId])),
            duration: const Duration(seconds: 2),
          ),
        );
        try {
          if (response.nextAction == PaymentNextAction.setup) {
            await presentSubscriptionSheet(setupIntentClientSecret: response.clientSecret);
          } else if (response.nextAction == PaymentNextAction.pay) {
            await presentSubscriptionSheet(paymentIntentClientSecret: response.clientSecret);
          }
        }on StripeException catch(e){
          if (e.error.code == FailureCode.Canceled) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(tr("subscription.canceled_payment_by_user"))),
            );
          }else if(e.error.code == FailureCode.Failed){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(tr("subscription.payment_failed"))),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(tr("subscription.payment_failed_with_msg", args: [?e.error.localizedMessage]))),
            );
          }
        }catch(e){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(tr("subscription.payment_failed_try_later"))),
          );
        }

        print("--after payment");
        _checkSubscriptionStatus(response.subscriptionId);

      }
    } catch (e) {
      setState(() {
        _isCreatingSubscription = false;
      });

      if (mounted) {
        String errorMessage = '';
        if (e is SubscriptionException) {
          errorMessage = e.message;
        } else {
          errorMessage = e.toString();
        }

        await showForcePopup(
          context,
          title: 'error_text',
          message: errorMessage,
        );
      }
    }
  }

  /// Check subscription activation status by polling checkActivation API every 5 seconds
  Future<void> _checkSubscriptionStatus(String subscriptionId) async {
    // Cancel any existing timer
    _activationCheckTimer?.cancel();
    
    setState(() {
      _isCheckingActivation = true;
    });

    // Start polling
    _activationCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }

      try {
        final response = await _subscriptionApi.checkActivation(subscriptionId: subscriptionId);
        print("--check active: ${response.subscriptionId} | ${response.result}");
        if (!mounted) return;

        if (response.result == ActivateSubscriptionResult.activated) {
          // Success - stop polling and show success message
          timer.cancel();
          setState(() {
            _isCheckingActivation = false;
          });

          // await showForcePopup(
          //   context,
          //   title: tr("success"),
          //   message: tr("subscription.subscription_created_successful"),
          // );

          // Navigate back or to home page
          if (mounted) {
            // Navigator.pop(context);
            context.go("/subscription/confirmation");
          }
        } else if (response.result == ActivateSubscriptionResult.failed) {
          // Failed - stop polling and show error message
          timer.cancel();
          setState(() {
            _isCheckingActivation = false;
          });

          await showForcePopup(
            context,
            title: tr("error_text"),
            message: tr("subscription.subscription_created_failed"),
          );
        }
        // If result is 'pending', continue polling
      } catch (e) {
        // On error, continue polling but log the error
        print('Error checking activation status: $e');
        // Optionally, you might want to stop after a certain number of retries
      }
    });

    // Also check immediately (don't wait for first 5 seconds)
    try {
      final response = await _subscriptionApi.checkActivation(subscriptionId: subscriptionId);

      print("--check active2: ${response.subscriptionId} | ${response.result}");

      if (!mounted) return;

      if (response.result == ActivateSubscriptionResult.activated) {
        _activationCheckTimer?.cancel();
        setState(() {
          _isCheckingActivation = false;
        });

        await showForcePopup(
          context,
          title: tr("success"),
          message: tr("subscription.subscription_created_successful"),

        );

        if (mounted) {
          context.go("/subscription/confirmation");
        }
      } else if (response.result == ActivateSubscriptionResult.failed) {
        _activationCheckTimer?.cancel();
        setState(() {
          _isCheckingActivation = false;
        });

        await showForcePopup(
          context,
          title: tr("error_text"),
          message: tr("subscription.subscription_created_failed"),
        );
      }
    } catch (e) {
      // If immediate check fails, continue with polling
      print('Error on immediate activation check: $e');
    }
  }

  @override
  void dispose() {
    _activationCheckTimer?.cancel();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0,
            height: 200,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFF294F55),
                        Color(0xFF294F55),
                        Color(0xFF294F55),
                        Color(0xFF376752),
                        Color(0xFF376752),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // scrollable content
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          _getBillingCycleText(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), // let title be center
                    ],
                  ),
                ),

                // 主要滾動內容
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FeatureCard(
                          features: widget.features,
                          themColor: listItemGreen,
                        ),

                        const SizedBox(height: 15),

                        //  Details Box
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              // color: Color(0xFFfafafa),
                              border: Border.all(color: const Color(0xFFC7C7C7))
                          ),
                          child: _isLoadingPreview
                              ? const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(child: CircularProgressIndicator()),
                                )
                              : _previewError != null
                                  ? Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        '',
                                        // 'Error loading preview: $_previewError',
                                        style: const TextStyle(color: Colors.red),
                                      ),
                                    )
                                  : SubscriptionPreviewCard(
                                      billingRecycleType: _getBillingCycleText(),
                                      renewalText: _getRenewalText(),
                                      amountText: _getAmountText(),
                                      autoRenewText: _getAutoRenewText())
                        ),

                        const SizedBox(height: 15),

                        // Address Section
                        Text(
                         tr("your_address"),
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tr("your_address_description"),
                          style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 20),

                        // Dropdowns Row
                        _isLoadingDistricts
                            ? const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(child: CircularProgressIndicator()),
                              )
                            : _districtsError != null
                                ? Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      '',
                                      // 'Error loading districts: $_districtsError',
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  )
                                : AddressDistrictSelect(
                                    districts: _districts, 
                                    selectedDistrict: _selectedDistrict,
                                    selectedSubDistrict: _selectedSubDistrict,
                                    onDistrictChanged: _onDistrictChanged,
                                    onSubDistrictChanged: _onSubDistrictChanged,
                                  ),

                        const SizedBox(height: 16),

                        // Address Line Input
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tr("address_line"), style: TextStyle(color: Colors.black54)),
                            const SizedBox(height: 6),
                            TextFormField(
                              maxLines: 3,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8)
                              ),
                              controller: addressController,
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Bottom Button
                        Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              border: Border(
                                bottom: BorderSide(color: blueTextUnderline, width: 3.0),
                              ),
                            ),
                            child: TextButton(
                              onPressed: (_isCreatingSubscription) ? null : () {
                                _createSubscription();
                              },
                              child: (_isCreatingSubscription || _isCheckingActivation)
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : Text(
                                      tr("confirm_and_proceed"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                            )
                        ),


                        const SizedBox(height: 16),

                        // T&C
                        Row(
                          children: [
                            Checkbox(
                              activeColor: Colors.black,
                              value: _hasAcceptedTerms,
                              onChanged: (value) {
                                setState(() {
                                  _hasAcceptedTerms = value ?? false;
                                });
                              },
                            ),

                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(color: Colors.black54, fontSize: 14, height: 1.5),
                                  children: [
                                    TextSpan(text: tr("tnc_click")),
                                    TextSpan(
                                      text: tr("terms"),
                                      style: const TextStyle(decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()..onTap = () {},
                                    ),
                                    TextSpan(text: tr("privacy_policy_click")),
                                    TextSpan(
                                      text: tr("privacy_policy"),
                                      style: const TextStyle(decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()..onTap = () {},
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
