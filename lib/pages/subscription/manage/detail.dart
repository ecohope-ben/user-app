
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/utils/time.dart';
import '../../../api/index.dart';
import '../../../api/endpoints/subscription_api.dart';
import '../../../components/subscription/features.dart';
import '../../../components/subscription/notice_banner.dart';
import '../../../components/subscription/preview.dart';
import '../../../models/subscription_models.dart';
import '../../../style.dart';
import '../../../utils/pop_up.dart';
import 'list.dart';

class SubscriptionManageDetail extends StatefulWidget {
  final PlanListItem plan;
  final List<String> features;
  final String subscriptionId;
  const SubscriptionManageDetail({super.key, required this.plan, required this.features, required this.subscriptionId});

  @override
  State<SubscriptionManageDetail> createState() => _SubscriptionManageDetailState();
}

class _SubscriptionManageDetailState extends State<SubscriptionManageDetail> {

  // API instances
  final _subscriptionApi = Api.instance().subscription();

  // Loading states
  bool _isLoadingDetail = true;
  bool _isProcessing = false;

  bool _isSchedulingPlanChange = false;
  SubscriptionDetail? _subscriptionDetail;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSubscriptionDetail();
  }

  String _buildAmountText(){
    if(_subscriptionDetail?.discount != null){
      if(_subscriptionDetail!.discount?.discountType == DiscountType.freeCycles){
        return tr("subscription.amount_text_with_discount_without_original_price", args: [convertDateTimeToString(context, _subscriptionDetail?.currentPeriodEnd), widget.plan.priceDecimal]);
      }else {
        return '${_subscriptionDetail?.plan.priceDecimal}';
      }
    }

    return _subscriptionDetail?.plan.priceDecimal ?? "";

  }

  String _buildRenewText(){
    final cycle = tr("subscription.billing_cycle.${widget.plan.billingCycle.name}.period");
    return tr("subscription.auto_renew_text", args: [cycle]);
  }

  Future<void> _loadSubscriptionDetail() async {
    setState(() {
      _isLoadingDetail = true;
      _errorMessage = null;
    });

    try {
      final detail = await _subscriptionApi.getSubscriptionDetail(
        subscriptionId: widget.subscriptionId,
      );
      setState(() {
        _subscriptionDetail = detail;
        _isLoadingDetail = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingDetail = false;
        if (e is SubscriptionException) {
          _errorMessage = e.message;
        } else {
          _errorMessage = e.toString();
        }
      });
    }
  }

  String _getBillingCycleText() {
    return tr("subscription.billing_cycle.${widget.plan.billingCycle.name}.plan");
  }

  // Check if subscription has scheduled cancellation
  bool get _hasScheduledCancellation {
    return _subscriptionDetail?.scheduledCancellation != null;
  }

  bool get _hasScheduledPlanChange {
    return _subscriptionDetail?.scheduledPlanChange != null;
  }

  Future<void> _cancelPlanChange() async {
    setState(() {
      _isSchedulingPlanChange = true;
    });

    try {
      await _subscriptionApi.cancelPlanChange(
        subscriptionId: widget.subscriptionId,
      );

      setState(() {
        _isSchedulingPlanChange = false;
      });

      // Reload subscription detail to update UI
      await _loadSubscriptionDetail();

      if (mounted) {
        await showForcePopup(
          context,
          title: tr("success"),
          message: tr("cancel_plan_change_success"),
        );
      }
    } catch (e) {
      setState(() {
        _isSchedulingPlanChange = false;
      });

      if (mounted) {
        String errorMessage = tr("cancel_plan_change_error");
        if (e is SubscriptionException) {
          errorMessage = e.message;
        } else {
          errorMessage = e.toString();
        }

        await showForcePopup(
          context,
          title: tr("error_text"),
          message: errorMessage,
        );
      }
    }
  }


  Future<void> _cancelSubscription() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      await _subscriptionApi.scheduleCancellation(subscriptionId: widget.subscriptionId);

      // Reload subscription detail to update UI
      await _loadSubscriptionDetail();

      setState(() {
        _isProcessing = false;
      });

      if (mounted) {
        await showForcePopup(
          context,
          title: tr("success"),
          message: tr("subscription.cancel.success"),
        );
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });

      if (mounted) {
        String errorMessage = tr("subscription.cancel.error");
        if (e is SubscriptionException) {
          errorMessage = e.message;
        } else {
          errorMessage = e.toString();
        }

        await showForcePopup(
          context,
          title: tr("error_text"),
          message: errorMessage,
        );
      }
    }
  }

  Future<void> _keepSubscription() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      await _subscriptionApi.cancelCancellation(subscriptionId: widget.subscriptionId);

      // Reload subscription detail to update UI
      await _loadSubscriptionDetail();

      setState(() {
        _isProcessing = false;
      });

      if (mounted) {
        await showForcePopup(
          context,
          title: tr("success"),
          message: tr("subscription.keep.success"),
        );
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });

      if (mounted) {
        String errorMessage = tr("subscription.keep.error");
        if (e is SubscriptionException) {
          errorMessage = e.message;
        } else {
          errorMessage = e.toString();
        }

        await showForcePopup(
          context,
          title: tr("error_text"),
          message: errorMessage,
        );
      }
    }
  }

  @override
  void dispose() {
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
                          widget.plan.name,
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

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FeatureCard(
                          features: widget.features,
                          themColor: listItemGreen,
                          isSubscriptionCanceled: _hasScheduledCancellation,
                        ),

                        if(_hasScheduledCancellation) const SizedBox(height: 15),
                        if(_hasScheduledCancellation) NoticeBanner(convertDateTimeToString(context, _subscriptionDetail?.currentPeriodEnd)),
                        const SizedBox(height: 15),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Color(0xFFfafafa),
                              border: Border.all(color: const Color(0xFFC7C7C7))
                          ),
                          child: SubscriptionPreviewCard(
                            billingRecycleType: _getBillingCycleText(),
                            renewalText: (_hasScheduledCancellation) ? "--" : convertDateTimeToString(context, _subscriptionDetail?.currentPeriodEnd),
                            amountText: _buildAmountText(),
                            autoRenewText: _buildRenewText()
                          ),
                        ),


                        const SizedBox(height: 20),
                        Text(
                          tr("your_address"),
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 0),
                        Text(
                          tr("your_address_description"),
                          style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () async {
                            print("--ontap");
                            final result = await context.push("/subscription/manage/change_address", extra: _subscriptionDetail!);
                            // Reload subscription detail if address was updated successfully
                            if (result == true) {
                              await _loadSubscriptionDetail();
                            }
                          },
                          // onTap: () => _subscriptionDetail != null ? context.push("/subscription/manage/change_address", extra: _subscriptionDetail!) : null,
                          child: Container(
                            color: Colors.white,
                            child: TextField(
                              readOnly: true,
                              controller: TextEditingController(text: _subscriptionDetail?.deliveryAddress.fullAddress),

                              maxLines: null,
                              decoration: InputDecoration(
                                suffixIcon: InkWell(
                                  onTap: () async {
                                    final result = await context.push("/subscription/manage/change_address", extra: _subscriptionDetail!);
                                    // Reload subscription detail if address was updated successfully
                                    if (result == true) {
                                      await _loadSubscriptionDetail();
                                    }
                                  },
                                    child: Icon(Icons.chevron_right)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black12),
                                    borderRadius: BorderRadius.zero
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black12),
                                    borderRadius: BorderRadius.zero
                                ),
                                enabledBorder  : OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black12),
                                    borderRadius: BorderRadius.zero
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              ),
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        Text(
                          tr("payment_method"),
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          tr("your_credit_debit_card"),
                          style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 10),

                        InkWell(
                          onTap: () async {
                            if (_subscriptionDetail != null) {
                              final result = await context.push(
                                "/subscription/manage/change_payment_method",
                                extra: widget.subscriptionId,
                              );
                              // Reload subscription detail if payment method was updated successfully
                              if (result == true) {
                                await _loadSubscriptionDetail();
                              }
                            }
                          },
                          child: Container(
                            height: 45,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black12
                              )
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,

                              children: [
                                // SvgPicture.asset("assets/icon/credit_card/visa.svg", fit: BoxFit.contain, alignment: Alignment.centerLeft),
                                Image.asset(
                                  "assets/icon/credit_card/${_subscriptionDetail?.defaultPaymentMethod?.brand.toLowerCase()}.png",
                                  errorBuilder: (context, o, t){
                                    return Text(_subscriptionDetail?.defaultPaymentMethod?.brand.toUpperCase() ?? "");
                                  },
                                ),
                                SizedBox(width: 10),
                                Text("**${_subscriptionDetail?.defaultPaymentMethod?.last4 ?? ""}"),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(Icons.chevron_right),
                                  ),
                                )

                              ],
                            ),
                          ),
                        ),
                        Text("${tr("next_billing_date")}: ${convertDateTimeToString(context, _subscriptionDetail?.currentPeriodEnd)}"),
                        if(_subscriptionDetail?.lifecycleState == SubscriptionLifecycleState.pastDue) _buildFailedPaymentNotice(),
                        (_hasScheduledCancellation || _hasScheduledPlanChange) ? const SizedBox(height: 20) : const SizedBox(height: 40),


                        // Change Plan button
                        if(!_hasScheduledCancellation && !_hasScheduledPlanChange)
                        Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black)
                            ),
                            child: TextButton(
                              onPressed:() => context.push("/subscription/manage/list", extra: SubscriptionManageTarget.change),
                              child: Text(
                                tr("change_plan"),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            )
                        ),

                        const SizedBox(height: 10),
                        if(_hasScheduledPlanChange)
                          _buildCancelSchedulePlanChange(),

                        const SizedBox(height: 00),
                        // Bottom Button
                        _isLoadingDetail
                            ? const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(child: CircularProgressIndicator(color: Colors.black)),
                              )
                            : _errorMessage != null
                                ? Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          "${tr("error_occurred")}: $_errorMessage",
                                          style: const TextStyle(color: Colors.red),
                                        ),
                                        const SizedBox(height: 8),
                                        TextButton(
                                          onPressed: _loadSubscriptionDetail,
                                          child: Text(tr("error.retry")),
                                        ),
                                      ],
                                    ),
                                  )
                                : _buildCancelSubscriptionButton(),


                        const SizedBox(height: 16),

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

  Widget _buildFailedPaymentNotice(){
    return Text(
      "There is an issue with your payment method. Update your payment information to correct the problem and try again.",
      style: TextStyle(color: Colors.red),
    );
  }

  Widget _buildCancelSubscriptionButton(){
    if(!_hasScheduledPlanChange) {
      return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 0),
          decoration: (_hasScheduledCancellation) ? BoxDecoration(
              color: Colors.black
          ) : null,
          child: TextButton(
            onPressed: (_isProcessing) ? null : () {
              if (_hasScheduledCancellation) {
                // Keep subscription (cancel the cancellation)
                showPopup(
                    context,
                    title: "${tr("subscription.keep.title")}?",
                    message: tr("subscription.keep.confirm"),
                    onConfirm: () => _keepSubscription(),
                    confirmText: tr("subscription.keep.title"),
                );
              } else {
                // Cancel subscription
                showPopup(
                    context,
                    title: "${tr("subscription.cancel.title")}?",
                    message: "${tr("subscription.cancel.confirm")}?",
                    onConfirm: () => _cancelSubscription(),
                    confirmText: tr("confirm")
                );
              }
            },
            child: _isProcessing ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(_hasScheduledCancellation ? Colors.white : Colors.black),
              ),
            )
                : Text(
              _hasScheduledCancellation ? tr("subscription.keep.title") : tr("subscription.cancel.title"),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _hasScheduledCancellation ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          )
      );
    }else return Container();
  }
  Widget _buildCancelSchedulePlanChange(){
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black)
      ),
      child: TextButton(
        onPressed: (_isSchedulingPlanChange) ? null : () {
          if (_hasScheduledPlanChange) {
            // Cancel plan change
            showPopup(
                context,
                title: tr("cancel_plan_change"),
                message: tr("cancel_plan_change_confirm"),
                onConfirm: () => _cancelPlanChange(),
                confirmText: tr("confirm")
            );
          } else {
            // Schedule plan change
            showPopup(
                context,
                title: tr("change_plan"),
                message: tr("change_plan_confirm"),
                onConfirm: () => _cancelPlanChange(),
                confirmText: tr("confirm")
            );
          }
        },
        child: _isSchedulingPlanChange
            ? SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              _hasScheduledPlanChange ? Colors.black : Colors.white,
            ),
          ),
        )
            : Text(
          _hasScheduledPlanChange ? tr("cancel_plan_change") : tr("confirm_plan_change"),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _hasScheduledPlanChange ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

}
