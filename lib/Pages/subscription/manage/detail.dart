
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../api/index.dart';
import '../../../api/endpoints/subscription_api.dart';
import '../../../components/subscription/features.dart';
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
    return widget.plan.billingCycle == BillingCycle.monthly
        ? 'Monthly Plan'
        : 'Yearly Plan';
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
          title: '成功',
          message: '訂閱已成功取消，將在當前週期結束後生效。',
        );
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });

      if (mounted) {
        String errorMessage = '取消訂閱時發生錯誤';
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
          title: '成功',
          message: '訂閱已成功保留，將繼續自動續訂。',
        );
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });

      if (mounted) {
        String errorMessage = '保留訂閱時發生錯誤';
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

                        // Cancellation Info Box
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Color(0xFFfafafa),
                              border: Border.all(color: const Color(0xFFC7C7C7))
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "取消訂閱說明",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "取消訂閱後，您的訂閱將在當前計費週期結束後停止。在此之前，您仍可繼續使用所有服務。",
                                style: TextStyle(color: Colors.black87, fontSize: 14, height: 1.5),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                        // Change Plan button
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
                                "Change Plan",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            )
                        ),

                        const SizedBox(height: 20),
                        if(_hasScheduledPlanChange)
                          _buildCancelSchedulePlanChange(),

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
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black)
                                    ),
                                    child: TextButton(
                                      onPressed: (_isProcessing) ? null : () {
                                        if (_hasScheduledCancellation) {
                                          // Keep subscription (cancel the cancellation)
                                          showPopup(
                                            context,
                                            title: "保留訂閱？",
                                            message: "您確定要保留訂閱嗎？\n您的訂閱將繼續自動續訂。",
                                            onConfirm: () => _keepSubscription(),
                                            confirmText: "保留訂閱"
                                          );
                                        } else {
                                          // Cancel subscription
                                          showPopup(
                                            context,
                                            title: "取消訂閱？",
                                            message: "您確定要取消您的訂閱計劃嗎？\n此訂閱將在當前計費週期結束後取消。",
                                            onConfirm: () => _cancelSubscription(),
                                            confirmText: "取消訂閱"
                                          );
                                        }
                                      },
                                      child: _isProcessing ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                        ),
                                      )
                                          : Text(
                                        _hasScheduledCancellation ? "保留訂閱" : "取消訂閱",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.black,
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
                onConfirm: () => _cancelPlanChange(),
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
      ),
    );
  }

}
