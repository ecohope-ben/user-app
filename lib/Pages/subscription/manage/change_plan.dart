import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/components/subscription/features.dart';
import 'package:user_app/components/subscription/preview.dart';
import '../../../api/index.dart';
import '../../../api/endpoints/subscription_api.dart';
import '../../../models/subscription_models.dart';
import '../../../routes.dart';
import '../../../style.dart';
import '../../../utils/pop_up.dart';
import '../../../utils/snack.dart';
import '../../../utils/time.dart';

class SubscriptionPlanChange extends StatefulWidget {
  final PlanListItem plan;
  final List<String> features;
  final String subscriptionId;
  const SubscriptionPlanChange({super.key, required this.plan, required this.features, required this.subscriptionId});

  @override
  State<SubscriptionPlanChange> createState() => _SubscriptionPlanChangeState();
}

class _SubscriptionPlanChangeState extends State<SubscriptionPlanChange> {

  // API instances
  final _subscriptionApi = Api.instance().subscription();

  // Loading states
  bool _isLoadingPreview = true;
  bool _isSchedulingPlanChange = false;
  String? _previewError;


  // Loading states
  bool _isLoadingDetail = true;
  bool _isProcessing = false;

  // Subscription detail
  SubscriptionDetail? _subscriptionDetail;
  String? _errorMessage;

  // Preview data
  PreviewSubscriptionResponse? _previewData;

  @override
  void initState() {
    super.initState();

    _loadSubscriptionDetail();
  }

  Future<void> _loadSubscriptionDetail() async {
    setState(() {
      _isLoadingDetail = true;
      _subscriptionDetail = null;
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

  String _formatAmount(int amount, String currency) {
    final formatted = (amount / 100).toStringAsFixed(2);
    return '$currency$formatted';
  }

  String _getBillingCycleText() {
    return widget.plan.billingCycle == BillingCycle.monthly
        ? 'Monthly Plan'
        : 'Yearly Plan';
  }

  String _buildAmountText(){
    return "\$${widget.plan.priceDecimal}";

  }

  String _buildRenewText(){
    if(widget.plan.billingCycle == BillingCycle.monthly){
      return "Auto-renews every 1 month, cancel anytime.";
    }else if(widget.plan.billingCycle == BillingCycle.yearly) {
      return "Auto-renews every 1 year, cancel anytime.";
    }
    return "";
  }

  // Check if subscription has scheduled plan change
  bool get _hasScheduledPlanChange {
    return _subscriptionDetail?.scheduledPlanChange != null;
  }

  Future<void> _schedulePlanChange() async {
    // Validate required fields
    // if (_previewData == null) {
    //   popSnackBar(context, '預覽資料尚未載入，請稍候再試');
    //   return;
    // }

    setState(() {
      _isSchedulingPlanChange = true;
    });

    try {
      final request = SchedulePlanChangeRequest(
        newPlanVersionId: widget.plan.versionId,
      );

      await _subscriptionApi.schedulePlanChange(
        subscriptionId: widget.subscriptionId,
        request: request,
      );

      setState(() {
        _isSchedulingPlanChange = false;
      });

      // Reload subscription detail to update UI
      await _loadSubscriptionDetail();

      // Handle success
      if (mounted) {
        printRouteStack(context);
        await showForcePopup(
          context,
          title: '成功',
          message: '計劃變更已成功排程！',
        );

        // Navigate back
        if (mounted) {
          context.go("/");
        }
      }
    } catch (e) {
      setState(() {
        _isSchedulingPlanChange = false;
      });

      if (mounted) {
        String errorMessage = '排程計劃變更時發生錯誤';
        if (e is SubscriptionException) {
          errorMessage = e.message;
        } else {
          errorMessage = e.toString();
        }

        await showForcePopup(
          context,
          title: '錯誤',
          message: errorMessage,
        );
      }
    }
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
          title: '成功',
          message: '計劃變更已成功取消！',
        );
      }
    } catch (e) {
      setState(() {
        _isSchedulingPlanChange = false;
      });

      if (mounted) {
        String errorMessage = '取消計劃變更時發生錯誤';
        if (e is SubscriptionException) {
          errorMessage = e.message;
        } else {
          errorMessage = e.toString();
        }

        await showForcePopup(
          context,
          title: '錯誤',
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
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                         "Change Plan | ${_getBillingCycleText()}",
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
                                color: Color(0xFFfafafa),
                                border: Border.all(color: const Color(0xFFC7C7C7))
                            ),
                            child: SubscriptionPreviewCard(
                                billingRecycleType: widget.plan.billingCycle.name,
                                renewalText: convertDateTimeToString(_subscriptionDetail?.currentPeriodEnd, "dd MMM y"),
                                amountText: _buildAmountText(),
                                autoRenewText: _buildRenewText()
                            ),
                        ),

                        const SizedBox(height: 20),
                        const Text(
                          "Your Address",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 0),
                        const Text(
                          "This address will be used to deliver your one-time free recycling bag and for future pick up.",
                          style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          color: Colors.black12,
                          child: TextField(
                            readOnly: true,
                            autofocus: false,
                            controller: TextEditingController(text: _subscriptionDetail?.deliveryAddress.fullAddress),

                            maxLines: null,
                            decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent),
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

                        const SizedBox(height: 20),
                        const Text(
                          "Payment Method",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "Your credit or debit card",
                          style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 10),

                        Container(
                          height: 45,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              border: Border.all(
                                  color: Colors.black12
                              )
                          ),
                          child: Row(
                            children: [
                              // SvgPicture.asset("assets/icon/credit_card/visa.svg", fit: BoxFit.contain, alignment: Alignment.centerLeft),
                              Image.asset(
                                "assets/icon/credit_card/${_subscriptionDetail?.defaultPaymentMethod?.brand.toLowerCase()}.png",
                                errorBuilder: (context, o, t){
                                  return Text(_subscriptionDetail?.defaultPaymentMethod?.brand.toUpperCase() ?? "");
                                },
                              ),
                              SizedBox(width: 10),
                              Text("**${_subscriptionDetail?.defaultPaymentMethod?.last4 ?? ""}")
                            ],
                          ),


                        ),
                        Text("Next billing date: ${convertDateTimeToString(_subscriptionDetail?.currentPeriodEnd, "dd MMM y")}"),



                        const SizedBox(height: 20),
                        // Bottom Button
                        _isLoadingDetail
                            ? const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(child: CircularProgressIndicator()),
                              )
                            : _errorMessage != null
                                ? Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          '載入訂閱詳情時發生錯誤: $_errorMessage',
                                          style: const TextStyle(color: Colors.red),
                                        ),
                                        const SizedBox(height: 8),
                                        TextButton(
                                          onPressed: _loadSubscriptionDetail,
                                          child: const Text('重試'),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 0),
                                    decoration: BoxDecoration(
                                      color: _hasScheduledPlanChange ? Colors.white : Colors.black,
                                      border: _hasScheduledPlanChange
                                          ? Border.all(color: Colors.black)
                                          : const Border(
                                              bottom: BorderSide(color: blueTextUnderline, width: 3.0),
                                            ),
                                    ),
                                    child: TextButton(
                                      onPressed: (_isSchedulingPlanChange) ? null : () {
                                        if (_hasScheduledPlanChange) {
                                          // Cancel plan change
                                          showPopup(
                                            context,
                                            title: "取消變更訂閱",
                                            message: "您確定要取消計劃變更嗎？",
                                            onConfirm: () => _cancelPlanChange(),
                                            confirmText: "確認"
                                          );
                                        } else {
                                          // Schedule plan change
                                          showPopup(
                                            context,
                                            title: "變更訂閱",
                                            message: "您確定要變更訂閱？\n您的訂閱將繼續自動續訂。",
                                            onConfirm: () => _schedulePlanChange(),
                                            confirmText: "確認"
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
                                            _hasScheduledPlanChange ? "取消變更訂閱" : "Confirm Plan Change",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: _hasScheduledPlanChange ? Colors.black : Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                    )
                                ),


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

}
