import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:user_app/api/index.dart';
import 'package:user_app/components/order/order_payment_section.dart';
import 'package:user_app/components/register/action_button.dart';
import 'package:user_app/models/recycle_models.dart';
import 'package:user_app/models/subscription_models.dart';
import 'package:user_app/style.dart';
import 'package:user_app/utils/snack.dart';
import 'package:user_app/utils/time.dart';

import '../../api/endpoints/recycle_api.dart';
import '../../components/common/promotion_code.dart';
import '../../components/order/notice_banner.dart';
import '../../utils/number.dart';
import '../../utils/pop_up.dart';

class SchedulePickUpOrderPage extends StatefulWidget {
  final SubscriptionDetail subscriptionDetail;
  const SchedulePickUpOrderPage(this.subscriptionDetail, {super.key});

  @override
  State<SchedulePickUpOrderPage> createState() => _SchedulePickUpOrderPageState();
}

class _SchedulePickUpOrderPageState extends State<SchedulePickUpOrderPage> {
  final TextEditingController _addressController = TextEditingController();
  Timer? _activationCheckTimer;
  bool _isCheckingActivation = false;

  // Pickup slots data
  List<PickupSlotDate>? _availableDates;
  String? _selectedDate;
  String? _selectedTime;
  bool _isLoading = true;
  bool _isSubmitLoading = false;
  bool isAdditionalOrder = false;
  bool paymentRequired = false;
  bool hasPreviewError = false;
  String? _previewError;
  double amount = 0;
  double totalAmount = 0;
  double? discountAmount;
  String? usedPromotionCode;
  late RecycleOrderPreflightEnvelope preflightEnvelope;
  bool _isLoadingPreviewWithPromotionCode = false;


  String? _errorMessage;

  final TextEditingController promotionCodeController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    if((widget.subscriptionDetail.deliveryAddress.fullAddress?.isEmpty ?? true) || widget.subscriptionDetail.deliveryAddress.fullAddress == null){
      _addressController.text = widget.subscriptionDetail.deliveryAddress.address;
    }else {
      _addressController.text = widget.subscriptionDetail.deliveryAddress.fullAddress!;
    }
    _loadPickupSlotsAndPreflight(widget.subscriptionDetail.id);
  }

  void setTotalAmount(){
    setState(() {
      if(discountAmount != null){
        totalAmount = amount - discountAmount!;
      }else{
        totalAmount = amount;
      }
    });
  }

  /// Check additional order status by polling checkActivation API every 5 seconds
  Future<void> _checkAdditionOrderStatus(String serviceOrderId, String orderId) async {
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
        final response = await Api.instance().recycle().checkAdditionalOrderStatus(serviceOrderId);
        if (!mounted) return;

        if (response.result == CheckAdditionalOrderResult.completed) {
          // Success - stop polling and show success message
          timer.cancel();
          setState(() {
            _isCheckingActivation = false;
          });

          // Navigate back or to home page
          if (mounted) {
            // Navigator.pop(context);
            context.go("/order/confirmation", extra: orderId);
          }
        } else if (response.result == CheckAdditionalOrderResult.failed) {
          // Failed - stop polling and show error message
          timer.cancel();
          setState(() {
            _isCheckingActivation = false;
          });

          await showForcePopup(
            context,
            title: tr("error_text"),
            message: tr("order.create_failed"),
          );
        }
        // If result is 'pending', continue polling
      } catch (e) {
        if(kDebugMode) {
          print('Error checking activation status: $e');
        }
      }
    });

    // Also check immediately (don't wait for first 5 seconds)
    try {

      final response = await Api.instance().recycle().checkAdditionalOrderStatus(serviceOrderId);
      if (!mounted) return;

      if (response.result == CheckAdditionalOrderResult.completed) {
        _activationCheckTimer?.cancel();
        setState(() {
          _isCheckingActivation = false;
        });

        if (mounted) {
          context.go("/order/confirmation", extra: orderId);
        }
      } else if (response.result == CheckAdditionalOrderResult.failed) {
        _activationCheckTimer?.cancel();
        setState(() {
          _isCheckingActivation = false;
        });

        await showForcePopup(
          context,
          title: tr("error_text"),
          message: tr("order.create_failed"),
        );
      }
    } catch (e) {
      // If immediate check fails, continue with polling
      if(kDebugMode) {
        print('Error on immediate activation check: $e');
      }
    }
  }

  Future<void> processPayment({required String clientSecret, required String serviceOrderId, required String orderId}) async {
    try {
      await presentSubscriptionSheet(paymentIntentClientSecret: clientSecret);

      await _checkAdditionOrderStatus(serviceOrderId, orderId);

    }on StripeException catch(e){
      if(kDebugMode) {
        print("--StripeException");
        print(e.error.code);
      }
      if (e.error.code == FailureCode.Canceled) {
        popSnackBar(context, tr("subscription.canceled_payment_by_user"));

      }else if(e.error.code == FailureCode.Failed){
        popSnackBar(context, tr("subscription.payment_failed"));
      } else {
        popSnackBar(context, tr("subscription.payment_failed_with_msg", args: [?e.error.localizedMessage]));
      }
    }catch(e,t){
      if(kDebugMode) {
        print(e.toString());
        print(t.toString());
      }
      popSnackBar(context, tr("subscription.payment_failed_try_later"));
    }
  }

  Future<void> onSubmit() async {

    // Validate required fields
    if (_selectedDate == null) {
      popSnackBar(context, tr("order.select_date"));
      return;
    }

    if (_selectedTime == null) {
      popSnackBar(context, tr("order.select_time"));
      return;
    }

    try {
      setState(() {
        _isSubmitLoading = true;
        _errorMessage = null;
      });
      // Create order request
      final request = RecycleOrderCreateRequest(
        subscriptionId: widget.subscriptionDetail.id,
        pickupDate: _selectedDate!,
        pickupTime: _selectedTime!,
        settlementType: preflightEnvelope.settlementType,
        serviceVersionId: preflightEnvelope.serviceVersionId,
        amount: doubleToIntWithTwoDigit(totalAmount),
        currency: preflightEnvelope.currency,
        promotionCode: usedPromotionCode
      );

      // Call API to create order
      final response = await Api.instance().recycle().createOrder(request: request);
      if(isAdditionalOrder && paymentRequired){
        await processPayment(
            clientSecret: response.clientSecret ?? "",
            serviceOrderId: response.serviceOrderId ?? "",
            orderId: response.id
        );
      }

      setState(() {
        _isSubmitLoading = false;
      });

      // Show success message
      if (mounted) {
        // Navigate back after showing success message
        if(!paymentRequired) {
          context.go("/order/confirmation", extra: response.id);
        }
      }

    } on RecycleException catch (e){
      setState(() {
        _isSubmitLoading = false;
      });
      if (mounted) {
        popSnackBar(context, e.message);
      }
    }catch (e) {
      setState(() {
        _isSubmitLoading = false;
      });

      // Show error message
      if (mounted) {
        popSnackBar(context, tr("order.create_failed"));
      }
    }
  }

  Future<void> previewOrder({String? promotionCode}) async {

    // Validate required fields
    if (_selectedDate == null) {
      popSnackBar(context, tr("order.select_date"));
      return;
    }

    if (_selectedTime == null) {
      popSnackBar(context, tr("order.select_time"));
      return;
    }

    try {
      setState(() {
        _isLoadingPreviewWithPromotionCode = true;
        _previewError = null;
        usedPromotionCode = null;
        hasPreviewError = false;
      });

      // Create order request
      final request = RecycleOrderPreviewRequest(
        subscriptionId: widget.subscriptionDetail.id,
        pickupDate: _selectedDate!,
        pickupTime: _selectedTime!,
        settlementType: preflightEnvelope.settlementType,
        serviceVersionId: preflightEnvelope.serviceVersionId,
        promotionCode: promotionCode,
      );

      // Call API to create order
      final response = await Api.instance().recycle().previewOrder(request: request);
      amount = response.originalAmount / 100;
      discountAmount = response.discountAmount / 100;
      setTotalAmount();
      setState(() {
        paymentRequired = response.paymentRequired;
        _isLoadingPreviewWithPromotionCode = false;
        usedPromotionCode = promotionCode;
      });

    } on RecycleException catch (e){
      setState(() {
        _isLoadingPreviewWithPromotionCode = false;
        hasPreviewError = true;
        _previewError = e.message;
      });

    }catch (e) {
      // Set error message
      setState(() {
        _isLoadingPreviewWithPromotionCode = false;
        hasPreviewError = true;
        _previewError = e.toString();
      });
    }
  }

  Future<void> _loadPickupSlotsAndPreflight(String subscriptionId) async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final response = await Api.instance().recycle().getRecycleOrderPreflightPickupSlots(subscriptionId);
      preflightEnvelope = response;
      amount = preflightEnvelope.amount / 100;
      setTotalAmount();
      setState(() {
        _availableDates = response.availableDates;
        isAdditionalOrder = preflightEnvelope.settlementType == RecycleOrderSettlementType.oneTimePayment ? true : false;
        paymentRequired = preflightEnvelope.settlementType == RecycleOrderSettlementType.oneTimePayment ? true : false;

        _isLoading = false;
      });
    } catch (e, t) {
      if(kDebugMode) {
        print(e.toString());
        print(t.toString());
      }
      setState(() {
        _isLoading = false;
        _errorMessage = tr("error.fail_to_load_pickup_slot");
      });
    }
  }

  Future<void> presentSubscriptionSheet({String? paymentIntentClientSecret, String? setupIntentClientSecret}) async {

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        merchantDisplayName: 'ECOHOPE',
        paymentIntentClientSecret: paymentIntentClientSecret,
        setupIntentClientSecret: setupIntentClientSecret,
        style: ThemeMode.light,
        // Apple Pay requires Stripe.merchantIdentifier to be set (in main.dart) and
        // Apple Pay enabled in Stripe dashboard. See: https://support.stripe.com/questions/enable-apple-pay-on-your-stripe-account
        applePay: PaymentSheetApplePay(
          merchantCountryCode: 'HK',
            // cartItems: [
            //   ApplePayCartSummaryItem.immediate(label: 'Item', amount: "100"),
            // ],
        ),
      ),
    );

    // Shows Stripe’s native UI
    await Stripe.instance.presentPaymentSheet();
  }

  // Get available timeslots for selected date
  List<PickupSlotTimeslot>? _getAvailableTimeslots() {
    if (_selectedDate == null || _availableDates == null) {
      return null;
    }
    
    try {
      final selectedDateSlot = _availableDates!.firstWhere(
        (dateSlot) => dateSlot.date == _selectedDate,
      );
      return selectedDateSlot.timeslots;
    } catch (e) {
      return null;
    }
  }

  // Format date for display
  String _formatDateForDisplay(String date) {
    try {
      final dateTime = DateTime.parse(date);

      return '${tr("weekday.${dateTime.weekday}")}, ${convertDateTimeToString(context, dateTime)}';
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: (_isSubmitLoading || _isCheckingActivation) ? false : context.canPop(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainPurple,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => (_isSubmitLoading || _isCheckingActivation) ? null : context.pop(),
          ),
          title: Text(
            tr("order.schedule_pickup_now"),
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Skeletonizer(
          enabled: _isLoading,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. 訂閱 Banner (Subscription Card)
                  _buildSubscriptionBanner(),
                  const SizedBox(height: 12),
                  if(isAdditionalOrder) Skeleton.leaf(child: AdditionalOrderNoticeBanner()),

                  if(isAdditionalOrder) const SizedBox(height: 12),
                  // 3. 標題區域
                  Row(
                    children: [
                      Text(
                        tr("order.pickup_details"),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.help_outline, size: 20, color: Colors.black54),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tr("order.fill_information"),
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  const SizedBox(height: 20),

                  // 4. 表單區域
                  // Pick Up Date
                  _buildLabel("${tr("order.pickup_date")} *"),
                  _buildDateDropdown(),
                  const SizedBox(height: 16),

                  // Pick Up Time
                  _buildLabel("${tr("order.pickup_time")} *"),
                  _buildTimeDropdown(),
                  const SizedBox(height: 16),


                  // Address
                  _buildLabel(tr("order.address")),
                  Skeleton.leaf(
                    child: Container(
                      color: Colors.black12,
                      child: TextField(
                        readOnly: true,
                        controller: _addressController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.zero
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.zero
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.zero
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),


                  if(isAdditionalOrder) Text(
                    "${tr("promote.code")}（${tr("optional")}）",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  if(isAdditionalOrder) const SizedBox(height: 10),
                  if(isAdditionalOrder) Skeleton.shade(
                    child: PromotionCodeInput(
                      onTap: (){
                        if(promotionCodeController.text.isNotEmpty){
                          previewOrder(promotionCode: promotionCodeController.text);
                        }
                      },
                      isLoading: _isLoadingPreviewWithPromotionCode,
                      controller: promotionCodeController,
                    ),
                  ),

                  if(hasPreviewError && isAdditionalOrder) Text(_previewError ?? tr("promote.error"), style: TextStyle(color: Colors.red)),

                  if(isAdditionalOrder) const SizedBox(height: 30),

                  // Additional Order Payment
                  if(isAdditionalOrder) Skeleton.shade(
                    child: OrderPaymentSection(
                      amount: amount,
                      discountAmount: discountAmount,
                      totalAmount: totalAmount
                    ),
                  ),

                  if(isAdditionalOrder) const SizedBox(height: 16),

                  // 5. 確認按鈕
                  Skeleton.shade(child: ActionButton(tr("order.confirm_pickup_schedule"), onTap: onSubmit, showLoading: _isSubmitLoading)),
                  const SizedBox(height: 16),

                  // 6. 底部條款文字
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                      children: [
                        TextSpan(text: tr("order.by_clicking_to_agree")),
                        TextSpan(
                          text: tr("order.terms"),
                          style: TextStyle(decoration: TextDecoration.underline),
                        ),
                        TextSpan(text: tr("order.have_read_acknowledge")),
                        TextSpan(
                          text: tr("order.privacy_policy"),
                          style: TextStyle(decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 輔助方法：構建 Banner
  Widget _buildSubscriptionBanner() {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],

        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assets/widget/subscription_header.png") as ImageProvider,
        ),
      ),
      child: Stack(
        children: [
          // 文字內容
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tr("subscription.billing_cycle.${widget.subscriptionDetail.plan.billingCycle.name}.plan"),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 輔助方法：構建標籤文本
  Widget _buildLabel(String text) {
    bool isRequired = text.contains("*");
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          text: text.replaceAll("*", ""),
          style: const TextStyle(color: Colors.black54, fontSize: 14),
          children: [
            if (isRequired)
              const TextSpan(
                text: " *",
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  // 輔助方法：構建日期下拉選單
  Widget _buildDateDropdown() {
    // if (_isLoading) {
    //   return Container(
    //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    //     decoration: BoxDecoration(
    //       border: Border.all(color: Colors.black12),
    //       borderRadius: BorderRadius.zero,
    //     ),
    //     child: const Row(
    //       children: [
    //         SizedBox(
    //           width: 16,
    //           height: 16,
    //           child: CircularProgressIndicator(strokeWidth: 2),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    if (_errorMessage != null && _availableDates == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red.shade300),
          borderRadius: BorderRadius.zero,
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade300, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red.shade700, fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }

    final dateItems = _availableDates?.map((dateSlot) {
      final displayDate = _formatDateForDisplay(dateSlot.date);
      return DropdownMenuItem<String>(
        value: dateSlot.date,
        child: Text(displayDate),
      );
    }).toList() ?? [];

    return DropdownButtonFormField<String>(
      initialValue: _selectedDate,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black12, width: 1),
          borderRadius: BorderRadius.zero,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: purpleUnderline, width: 1),
          borderRadius: BorderRadius.zero,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black12, width: 1),
          borderRadius: BorderRadius.zero,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      style: const TextStyle(fontSize: 14, color: Colors.black),
      icon: const Icon(
        Icons.keyboard_arrow_down_sharp,
        size: 20,
        color: Colors.black54,
      ),
      isExpanded: true,
      hint: Text(
        tr("order.select_date"),
        style: TextStyle(fontSize: 14, color: Colors.grey),
      ),
      items: dateItems,
      onChanged: (value) {
        setState(() {
          _selectedDate = value;
          _selectedTime = null; // Reset time when date changes
        });
      },
    );
  }

  // 輔助方法：構建時間下拉選單
  Widget _buildTimeDropdown() {
    // if (_isLoading) {
    //   return Container(
    //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    //     decoration: BoxDecoration(
    //       border: Border.all(color: Colors.black12),
    //       borderRadius: BorderRadius.zero,
    //     ),
    //     child: const Row(
    //       children: [
    //         SizedBox(
    //           width: 16,
    //           height: 16,
    //           child: CircularProgressIndicator(strokeWidth: 2),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    final timeslots = _getAvailableTimeslots();
    final timeItems = timeslots?.map((timeslot) {
      return DropdownMenuItem<String>(
        value: timeslot.value,
        child: Text(timeslot.displayTime),
      );
    }).toList() ?? [];

    return DropdownButtonFormField<String>(
      initialValue: _selectedTime,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: _selectedDate != null ? Colors.black12 : Colors.grey.shade300,
            width: 1,
          ),
          borderRadius: BorderRadius.zero,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: _selectedDate != null ? purpleUnderline : Colors.grey.shade300,
            width: 1,
          ),

          borderRadius: BorderRadius.zero,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: _selectedDate != null ? Colors.black12 : Colors.grey.shade300,
            width: 1,
          ),

          borderRadius: BorderRadius.zero,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      style: TextStyle(
        fontSize: 14,
        color: _selectedDate != null ? Colors.black : Colors.grey,
      ),
      icon: Icon(
        Icons.keyboard_arrow_down_sharp,
        size: 20,
        color: Colors.black54,
      ),
      isExpanded: true,
      hint: Text(
        tr("order.select_time"),
        style: TextStyle(
          fontSize: 14,
          color: _selectedDate != null ? Colors.grey : Colors.grey.shade400,
        ),
      ),
      items: timeItems,
      onChanged: _selectedDate != null
          ? (value) {
              setState(() {
                _selectedTime = value;
              });
            }
          : null,
    );
  }
}