import 'package:el_tooltip/el_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/components/home/promotion_banner.dart';
import 'package:user_app/components/home/recycle_info_card.dart';
import 'package:user_app/components/register/action_button.dart';
import 'package:user_app/routes.dart';
import 'package:user_app/utils/snack.dart';

import '../blocs/entitlement_cubit.dart';
import '../blocs/login_cubit.dart';
import '../blocs/profile_cubit.dart';
import '../blocs/recycle_order_cubit.dart';
import '../blocs/subscription_cubit.dart';
import '../blocs/subscription_plan_cubit.dart';
import '../components/home/notification_card.dart';
import '../components/home/order_card.dart';
import '../components/home/silver.dart';
import '../models/recycle_models.dart';
import '../models/subscription_models.dart';
import '../style.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProfileCubit()..loadProfile()),
        BlocProvider(create: (_) => EntitlementCubit()..loadEntitlements()),
        BlocProvider(create: (_) => SubscriptionCubit()..getCurrentSubscription()),
        BlocProvider(create: (_) => RecycleOrderCubit()..listOrders()),
      ],
      child: _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  bool _hasInitialData = false;
  ProfileState? _lastProfileState;
  EntitlementState? _lastEntitlementState;
  SubscriptionState? _lastSubscriptionState;
  RecycleOrderState? _lastRecycleOrderState;

  @override
  Widget build(BuildContext context) {
    final profileState = context.watch<ProfileCubit>().state;
    final entitlementState = context.watch<EntitlementCubit>().state;
    final subscriptionState = context.watch<SubscriptionCubit>().state;
    final recycleOrderState = context.watch<RecycleOrderCubit>().state;

    // Save successful states for refresh
    if (profileState is ProfileLoaded) {
      _lastProfileState = profileState;
    }
    if (entitlementState is EntitlementLoaded) {
      _lastEntitlementState = entitlementState;
    }
    if (subscriptionState is SubscriptionListLoaded) {
      _lastSubscriptionState = subscriptionState;
    }
    if (recycleOrderState is RecycleOrderListLoaded) {
      _lastRecycleOrderState = recycleOrderState;
    }

    // Check if we have initial data loaded
    if (!_hasInitialData) {
      final hasData = profileState is ProfileLoaded &&
          entitlementState is EntitlementLoaded &&
          subscriptionState is SubscriptionListLoaded &&
          recycleOrderState is RecycleOrderListLoaded;
      if (hasData) {
        _hasInitialData = true;
      }
    }

    // Use last successful states if current state is loading and we have previous data
    final effectiveProfileState = (profileState is ProfileLoading && _lastProfileState != null)
        ? _lastProfileState!
        : profileState;
    final effectiveEntitlementState = (entitlementState is EntitlementLoading && _lastEntitlementState != null)
        ? _lastEntitlementState!
        : entitlementState;
    final effectiveSubscriptionState = (subscriptionState is SubscriptionLoading && _lastSubscriptionState != null)
        ? _lastSubscriptionState!
        : subscriptionState;

    final effectiveRecycleOrderState = (recycleOrderState is RecycleOrderLoading && _lastRecycleOrderState != null)
        ? _lastRecycleOrderState!
        : recycleOrderState;

    final String? errorMessage = _resolveErrorMessage(
      effectiveProfileState,
      effectiveEntitlementState,
      effectiveSubscriptionState,
      effectiveRecycleOrderState,
    );

    if (errorMessage != null) {
      return _HomeErrorView(
        message: errorMessage,
        onRetry: () {
          context.read<ProfileCubit>().loadProfile();
          context.read<EntitlementCubit>().loadEntitlements();
          context.read<SubscriptionCubit>().getCurrentSubscription();
          context.read<RecycleOrderCubit>().listOrders();
        },
      );
    }

    final bool isReady =
        effectiveProfileState is ProfileLoaded &&
        effectiveEntitlementState is EntitlementLoaded &&
        effectiveSubscriptionState is SubscriptionListLoaded &&
        effectiveRecycleOrderState is RecycleOrderListLoaded;
    print("--ready: $isReady | $_hasInitialData");
    print("--ready: $effectiveProfileState");
    print("--ready: $effectiveEntitlementState");
    print("--ready: $effectiveSubscriptionState");
    print("--ready: $effectiveRecycleOrderState");
    // Only show skeleton on initial load, not during refresh
    if (!isReady && !_hasInitialData) {
      return const _HomeSkeleton();
    }

    // If we have initial data but current state is not ready, show last data
    if (!isReady && _hasInitialData) {
      return _HomeContent(
        profileState: _lastProfileState as ProfileLoaded,
        entitlementState: _lastEntitlementState as EntitlementLoaded,
        subscriptionState: _lastSubscriptionState as SubscriptionListLoaded,
        recycleOrderState: _lastRecycleOrderState as RecycleOrderListLoaded,
      );
    }

    return _HomeContent(
      profileState: effectiveProfileState as ProfileLoaded,
      entitlementState: effectiveEntitlementState as EntitlementLoaded,
      subscriptionState: effectiveSubscriptionState as SubscriptionListLoaded,
      recycleOrderState: effectiveRecycleOrderState as RecycleOrderListLoaded,
    );
  }

  String? _resolveErrorMessage(
    ProfileState profileState,
    EntitlementState entitlementState,
    SubscriptionState subscriptionState,
    RecycleOrderState recycleOrderState,
  ) {
    if (profileState is ProfileError) {
      print("--ProfileError");
      return profileState.message;
    }
    if (entitlementState is EntitlementError) {
      print("--EntitlementError");
      return entitlementState.message;
    }
    if (subscriptionState is SubscriptionError) {
      print("--SubscriptionError");
      return subscriptionState.message;
    }
    if (recycleOrderState is RecycleOrderError) {
      print("--RecycleOrderError");
      return recycleOrderState.message;
    }
    return null;
  }
}

class _HomeContent extends StatefulWidget {
  final ProfileLoaded profileState;
  final EntitlementLoaded entitlementState;
  final SubscriptionListLoaded subscriptionState;
  final RecycleOrderListLoaded recycleOrderState;

  _HomeContent({
    required this.profileState,
    required this.entitlementState,
    required this.subscriptionState,
    required this.recycleOrderState,
  });

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  final ElTooltipController tooltipController = ElTooltipController();

  Future<void> _refreshData(BuildContext context) async {
    final profileCubit = context.read<ProfileCubit>();
    final entitlementCubit = context.read<EntitlementCubit>();
    final subscriptionCubit = context.read<SubscriptionCubit>();
    final recycleOrderCubit = context.read<RecycleOrderCubit>();

    await Future.wait([
      profileCubit.loadProfile(),
      entitlementCubit.loadEntitlements(),
      subscriptionCubit.getCurrentSubscription(),
      recycleOrderCubit.listOrders(),
    ]);
  }

  void _showTooltip(){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) tooltipController.show();
      });
      return;
    });
  }

  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    // Use provided states or watch from context
    // final effectiveSubscriptionState = subscriptionState ?? context.watch<SubscriptionCubit>().state;

    final List<RecycleOrderStatus> availableOrderStatus = [RecycleOrderStatus.completed, RecycleOrderStatus.failed];


    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        maintainBottomViewPadding: true,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/img/home_page_bg.png",
                fit: BoxFit.cover,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SliverBar(
                  profileState: widget.profileState,
                  entitlementState: widget.entitlementState,
                  subscriptionState: widget.subscriptionState,
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => _refreshData(context),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          if(widget.subscriptionState is SubscriptionDetailAndListLoaded) NotificationCard(widget.subscriptionState as SubscriptionDetailAndListLoaded),
                          BlocBuilder<SubscriptionCubit, SubscriptionState>(
                            builder: (context, state) {
                              // Use effective state for display
                              final displayState = widget.subscriptionState;

                              print("--recycleOrderState.orders");

                              if(widget.recycleOrderState.orders.isNotEmpty && !availableOrderStatus.contains(widget.recycleOrderState.orders.first.status)){

                                if(widget.recycleOrderState.orders.first.status == RecycleOrderStatus.completed && widget.entitlementState.entitlements.isNotEmpty){
                                  _showTooltip();
                                }
                                return RecycleOrderCard(widget.recycleOrderState.orders.first);
                              }

                              if (displayState is SubscriptionDetailAndListLoaded && displayState.subscriptions.isNotEmpty) {
                                if (displayState.detail.recyclingProfile != null && displayState.detail.recyclingProfile?.initialBagStatus == "delivered") {
                                  return ScheduleRecycleOrderCard(displayState.detail);
                                } else {
                                  return InitialBagDeliveryCard(displayState.detail.recyclingProfile?.initialBagDeliveryTrackingNo);
                                }
                              } else {
                                return PromotionBanner(() => context.push("/subscription/list"));

                              }

                            },
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                RecycleInfoCard(
                                  title: "How it works?",
                                  description:
                                      "We provide door to door collection Upcycle Your Way to a Greener Tomorrow!",
                                  imagePath: "assets/widget/how_it_work.png",
                                  icon: Icons.change_circle_outlined,
                                  onTap: () => context.push("/how_it_works"),
                                ),
                                const SizedBox(height: 16),
                                RecycleInfoCard(
                                  title: "Recycling Guide",
                                  description:
                                      "Dos and Don'ts we rely on you to apply the recycling guide properly!",
                                  imagePath: "assets/widget/recycle_guide.png",
                                  icon: Icons.list_alt,

                                  onTap: () => context.push("/recycling_guide"),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: widget.subscriptionState is SubscriptionDetailAndListLoaded ?
              CustomBottomNavBar(
                  tooltipController,
                  subscriptionDetail: (widget.subscriptionState as SubscriptionDetailAndListLoaded).detail,
                  hasEntitlement: widget.entitlementState.entitlements.isNotEmpty,
              ) :
              CustomBottomNavBar(tooltipController, hasEntitlement: widget.entitlementState.entitlements.isNotEmpty),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 160,
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _SkeletonBox(width: 120, height: 24),
                      _SkeletonBox(width: 80, height: 16),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: const [
                        _SkeletonBox(height: 140),
                        SizedBox(height: 20),
                        _SkeletonBox(height: 110),
                        SizedBox(height: 16),
                        _SkeletonBox(height: 110),
                      ],
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;

  const _SkeletonBox({
    this.width = double.infinity,
    this.height = 20,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class _HomeErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _HomeErrorView({required this.message, required this.onRetry});

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
                  message.isEmpty ? "Something went wrong." : message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                ActionButton("Retry", onTap: onRetry)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {

  final ElTooltipController tooltipController;
  final SubscriptionDetail? subscriptionDetail;
  final bool hasEntitlement;
  const CustomBottomNavBar(this.tooltipController, {this.subscriptionDetail, required this.hasEntitlement, super.key});

  Widget _buildMainLogo(BuildContext context){

    return InkWell(
      onTap: () {
        if(subscriptionDetail == null){
          popSnackBar(context, "請先訂閱計劃");
        }else if(!hasEntitlement){
          popSnackBar(context, "沒有有效的回收次數");
        }else {
          context.push("/order/create", extra: subscriptionDetail);
        }
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.black, // 黑色背景
          shape: BoxShape.circle,
          // border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Image.asset("assets/icon/nav_main.png", scale: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: SizedBox(
        width: 200, // 控制導航列寬度
        height: 70, // 總高度包含突出的按鈕
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // 底部白色膠囊背景
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.home_filled, color: Colors.black),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 40), // 中間留空給大按鈕
                  IconButton(
                    icon: const Icon(Icons.star_border, color: Colors.black),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Main logo button
            Positioned(
              top: 0,
              child: _buildMainLogo(context)
              // ElTooltip(
              //   controller: tooltipController,
              //   content: Text("Schedule a pickup here", softWrap: true, style: TextStyle(color: Colors.white)),
              //   radius: Radius.zero,
              //   showModal: false,
              //   color: Colors.black,
              //   child: _buildMainLogo()
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
