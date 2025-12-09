import 'package:flutter/material.dart';
import 'package:user_app/components/subscription/features.dart';
import 'package:user_app/components/subscription/preview.dart';
import '../../../api/index.dart';
import '../../../api/endpoints/subscription_api.dart';
import '../../../models/subscription_models.dart';
import '../../../style.dart';
import '../../../utils/pop_up.dart';
import '../../../utils/snack.dart';

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
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadPreview();
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


  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
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

  String _getRenewalText() {
    if (_previewData == null) return 'Loading...';
    return _formatDate(_previewData!.periodEnd);
  }

  String _getAmountText() {
    if (_previewData == null) return 'Loading...';
    if (!_previewData!.requirePayment) {
      return '${_formatAmount(_previewData!.amount, _previewData!.currency)} | pay nothing until ${_formatDate(_previewData!.periodEnd)}, then \$${widget.plan.priceDecimal}/Month';
    }
    return _formatAmount(_previewData!.amount, _previewData!.currency);
  }

  String _getAutoRenewText() {
    final cycle = widget.plan.billingCycle == BillingCycle.monthly ? '1 month' : '1 year';
    return 'Auto-renews every $cycle, cancel anytime.';
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
        await showForcePopup(
          context,
          title: '成功',
          message: '計劃變更已成功排程！',
        );

        // Navigate back
        if (mounted) {
          Navigator.pop(context);
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
                                color: Color(0xFFfafafa),
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
                                'Error loading preview: $_previewError',
                                style: const TextStyle(color: Colors.red),
                              ),
                            )
                                : SubscriptionPreviewCard(
                                billingRecycleType: _getBillingCycleText(),
                                renewalText: _getRenewalText(),
                                amountText: _getAmountText(),
                                autoRenewText: _getAutoRenewText())
                        ),

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
