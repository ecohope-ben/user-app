
import 'package:easy_localization/easy_localization.dart';
import 'package:el_tooltip/el_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:user_app/components/home/promotion_banner.dart';
import 'package:user_app/components/home/recycle_info_card.dart';
import 'package:user_app/components/register/action_button.dart';
import 'package:user_app/models/discount/index.dart';
import 'package:user_app/utils/time.dart';
import '../blocs/entitlement_cubit.dart';
import '../blocs/profile_cubit.dart';
import '../blocs/recycle_order_cubit.dart';
import '../blocs/subscription_cubit.dart';
import '../components/home/bottom_nav_bar.dart';
import '../components/home/home_skeleton.dart';
import '../components/card/notification_card.dart';
import '../components/home/order_card.dart';
import '../components/home/silver.dart';
import '../components/home/welcome_popup.dart';
import '../models/recycle_models.dart';
import '../models/subscription_models.dart';
import '../style.dart';
import '../utils/data.dart';
import '../utils/refresh_notifier.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProfileCubit()..loadProfile()),
        BlocProvider(create: (_) => EntitlementCubit()..loadEntitlements()),
        BlocProvider(create: (_) => SubscriptionCubit()..getCurrentSubscription()),
        BlocProvider(create: (_) => PreviewSubscriptionCubit()..previewSubscription()),
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
  SubscriptionState? _lastPreviewSubscriptionState;
  RecycleOrderState? _lastRecycleOrderState;

  void init() async{
    // await fetchDefaultDiscount();
  }

  void _onProfileRefresh() {
    if (mounted) context.read<ProfileCubit>().loadProfile();
  }

  void _onSubscriptionRefresh() {
    if (mounted) context.read<SubscriptionCubit>().getCurrentSubscription();
  }

  @override
  void initState() {
    super.initState();
    init();
    profileRefreshNotifier.addListener(_onProfileRefresh);
    subscriptionRefreshNotifier.addListener(_onSubscriptionRefresh);
  }

  @override
  void dispose() {
    profileRefreshNotifier.removeListener(_onProfileRefresh);
    subscriptionRefreshNotifier.removeListener(_onSubscriptionRefresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = context.watch<ProfileCubit>().state;
    final entitlementState = context.watch<EntitlementCubit>().state;
    final subscriptionState = context.watch<SubscriptionCubit>().state;
    final previewSubscriptionState = context.watch<PreviewSubscriptionCubit>().state;
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
    if (previewSubscriptionState is SubscriptionPreviewReady || previewSubscriptionState is SubscriptionPreviewUnavailable) {
      _lastPreviewSubscriptionState = previewSubscriptionState;
    }
    if (recycleOrderState is RecycleOrderListLoaded) {
      _lastRecycleOrderState = recycleOrderState;
    }

    // Check if we have initial data loaded
    if (!_hasInitialData) {
      final hasData = profileState is ProfileLoaded &&
          entitlementState is EntitlementLoaded &&
          subscriptionState is SubscriptionListLoaded &&
          (previewSubscriptionState is SubscriptionPreviewReady || previewSubscriptionState is SubscriptionPreviewUnavailable) &&
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

    final effectivePreviewSubscriptionState = (previewSubscriptionState is SubscriptionPreviewReady || previewSubscriptionState is SubscriptionPreviewUnavailable)
        ? _lastPreviewSubscriptionState!
        : previewSubscriptionState;

    final effectiveRecycleOrderState = (recycleOrderState is RecycleOrderLoading && _lastRecycleOrderState != null)
        ? _lastRecycleOrderState!
        : recycleOrderState;

    final String? errorMessage = _resolveErrorMessage(
      effectiveProfileState,
      effectiveEntitlementState,
      effectiveSubscriptionState,
      effectiveRecycleOrderState
    );

    if (errorMessage != null) {

      return _HomeErrorView(
        message: errorMessage,
        onRetry: () {
          context.read<ProfileCubit>().loadProfile();
          context.read<EntitlementCubit>().loadEntitlements();
          context.read<SubscriptionCubit>().getCurrentSubscription();
          context.read<PreviewSubscriptionCubit>().previewSubscription();
          context.read<RecycleOrderCubit>().listOrders();
        },
      );
    }

    final bool isReady =
        effectiveProfileState is ProfileLoaded &&
        effectiveEntitlementState is EntitlementLoaded &&
        effectiveSubscriptionState is SubscriptionListLoaded &&
        (effectivePreviewSubscriptionState is SubscriptionPreviewReady || effectivePreviewSubscriptionState is SubscriptionPreviewUnavailable) &&
        effectiveRecycleOrderState is RecycleOrderListLoaded;
    print("--ready: $isReady | $_hasInitialData");
    print("--ready: $effectiveProfileState");
    print("--ready: $effectiveEntitlementState");
    print("--ready: $effectiveSubscriptionState");
    print("--ready: $effectiveRecycleOrderState");

    // Only show skeleton on initial load, not during refresh
    if (!isReady && !_hasInitialData) {
      return const HomeSkeleton();
    }

    // If we have initial data but current state is not ready, show last data
    if (!isReady && _hasInitialData) {
      return _HomeContent(
        profileState: _lastProfileState as ProfileLoaded,
        entitlementState: _lastEntitlementState as EntitlementLoaded,
        subscriptionState: _lastSubscriptionState as SubscriptionListLoaded,
        previewSubscriptionState: _lastPreviewSubscriptionState as SubscriptionState,
        recycleOrderState: _lastRecycleOrderState as RecycleOrderListLoaded,
      );
    }

    return _HomeContent(
      profileState: effectiveProfileState as ProfileLoaded,
      entitlementState: effectiveEntitlementState as EntitlementLoaded,
      subscriptionState: effectiveSubscriptionState as SubscriptionListLoaded,
      previewSubscriptionState: effectivePreviewSubscriptionState,
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
      if(profileState.code == "http_guard.customer_pending_deletion"){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) context.go("/login/pending_deletion");
        });
        return "";
        // return tr("error.pending_account_deletion");
      }
      return tr("error.home_page_error");
      // return profileState.message;
    }
    if (entitlementState is EntitlementError) {
      print("--EntitlementError");
      return tr("error.home_page_error");
      // return entitlementState.message;
    }
    if (subscriptionState is SubscriptionError) {
      print("--SubscriptionError");
      return tr("error.home_page_error");
      // return subscriptionState.message;
    }
    if (recycleOrderState is RecycleOrderError) {
      print("--RecycleOrderError");
      return tr("error.home_page_error");
      // return recycleOrderState.message;
    }

    return null;
  }
}

class _HomeContent extends StatefulWidget {
  final ProfileLoaded profileState;
  final EntitlementLoaded entitlementState;
  final SubscriptionListLoaded subscriptionState;
  final SubscriptionState previewSubscriptionState;
  final RecycleOrderListLoaded recycleOrderState;

  const _HomeContent({
    required this.profileState,
    required this.entitlementState,
    required this.subscriptionState,
    required this.previewSubscriptionState,
    required this.recycleOrderState,
  });

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  final ElTooltipController tooltipController = ElTooltipController();
  int _refreshKey = 0; // Key to force RecycleOrderCard rebuild on refresh

  Future<void> _refreshData(BuildContext context) async {
    final profileCubit = context.read<ProfileCubit>();
    final entitlementCubit = context.read<EntitlementCubit>();
    final subscriptionCubit = context.read<SubscriptionCubit>();
    final previewSubscriptionCubit = context.read<PreviewSubscriptionCubit>();
    final recycleOrderCubit = context.read<RecycleOrderCubit>();

    await Future.wait([
      profileCubit.loadProfile(),
      entitlementCubit.loadEntitlements(),
      subscriptionCubit.getCurrentSubscription(),
      previewSubscriptionCubit.previewSubscription(),
      recycleOrderCubit.listOrders(),
    ]);

    // Increment refresh key to force RecycleOrderCard to rebuild and reload order detail
    setState(() {
      _refreshKey++;
    });
  }


  Future<void> popWelcomeGift() async {
    final prefs = await SharedPreferences.getInstance();
    bool hasShowedWelcomeGift = prefs.getBool('has_showed_welcome_gift') ?? false;
    if (!hasShowedWelcomeGift) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) => const WelcomeGiftPopup(),
        );
      });
    }
    prefs.setBool('has_showed_welcome_gift', true);
  }



  @override
  void initState() {
    super.initState();
    // popWelcomeGift();
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
                  recycleOrderState: widget.recycleOrderState,
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => _refreshData(context),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      child: Column(
                        children: [
                          if(widget.subscriptionState is SubscriptionDetailAndListLoaded && (widget.subscriptionState as SubscriptionDetailAndListLoaded).detail.lifecycleState == SubscriptionLifecycleState.pastDue) PaymentFailedNotificationCard((widget.subscriptionState as SubscriptionDetailAndListLoaded).detail.id),
                          if(widget.subscriptionState is SubscriptionDetailAndListLoaded && (widget.subscriptionState as SubscriptionDetailAndListLoaded).detail.scheduledCancellation != null) SubscriptionCanceledNotificationCard(convertDateTimeToString(context, (widget.subscriptionState as SubscriptionDetailAndListLoaded).detail.currentPeriodEnd)),
                          if(widget.subscriptionState is SubscriptionDetailAndListLoaded && (widget.subscriptionState as SubscriptionDetailAndListLoaded).detail.scheduledPlanChange != null) SubscriptionChangedNotificationCard((widget.subscriptionState as SubscriptionDetailAndListLoaded).detail.scheduledPlanChange?.plan.name, convertDateTimeToString(context, (widget.subscriptionState as SubscriptionDetailAndListLoaded).detail.currentPeriodEnd)),


                          // if(widget.subscriptionState is SubscriptionDetailAndListLoaded &&
                          //     (widget.subscriptionState as SubscriptionDetailAndListLoaded).detail.scheduledCancellation == null &&
                          //     widget.recycleOrderState.orders.isNotEmpty &&
                          //     widget.recycleOrderState.orders.first.status == RecycleOrderStatus.completed && widget.entitlementState.entitlements.isEmpty
                          // ) FinishedRecycleOrderNotificationCard(widget.subscriptionState as SubscriptionDetailAndListLoaded),


                          BlocBuilder<SubscriptionCubit, SubscriptionState>(
                            builder: (context, state) {
                              // Use effective state for display
                              final displayState = widget.subscriptionState;

                              if (displayState is SubscriptionDetailAndListLoaded && displayState.subscriptions.isNotEmpty) {
                                if(widget.recycleOrderState.orders.isNotEmpty && !availableOrderStatus.contains(widget.recycleOrderState.orders.first.status)){
                                  return RecycleOrderCard(
                                    widget.recycleOrderState.orders.first,
                                    displayState.detail,
                                    key: ValueKey('recycle_order_${widget.recycleOrderState.orders.first.id}_$_refreshKey'),
                                  );
                                }

                                // if(widget.recycleOrderState.orders.isNotEmpty && widget.entitlementState.entitlements.isNotEmpty ){
                                if(widget.recycleOrderState.orders.isNotEmpty){
                                  return RecycleOrderCard(
                                    widget.recycleOrderState.orders.first,
                                    displayState.detail,
                                    key: ValueKey('recycle_order_${widget.recycleOrderState.orders.first.id}_$_refreshKey'),
                                  );
                                }
                                if (displayState.detail.recyclingProfile != null && displayState.detail.recyclingProfile?.initialBagStatus == "delivered") {

                                  // check is first time to order
                                  if(widget.recycleOrderState.orders.isEmpty) {
                                    return ScheduleRecycleOrderCard(displayState.detail);
                                  } else {
                                    /// then may show tooltips
                                    return Container();
                                  }
                                } else {
                                  return InitialBagDeliveryCard(displayState.detail.recyclingProfile?.initialBagDeliveryTrackingNo);
                                }
                              } else {
                                if(widget.previewSubscriptionState is SubscriptionPreviewReady && Discount.instance().promotionCode != null) {
                                  return PromotionBanner(() => context.push("/subscription/list"));
                                }else{
                                  return Container();
                                }
                              }

                            },
                          ),
                          const SizedBox(height: verticalCardGapPadding),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: horizontalOuterPadding),
                            child: Column(
                              children: [
                                RecycleInfoCard(
                                  title: tr("how_it_works.title"),
                                  description: tr("how_it_works.description"),
                                  imagePath: "assets/widget/how_it_work.png",
                                  icon: Icons.change_circle_outlined,
                                  onTap: () => context.push("/how_it_works", extra: widget.subscriptionState),
                                ),
                                const SizedBox(height: verticalCardGapPadding),
                                RecycleInfoCard(
                                  title: tr("recycling_guide"),
                                  description: tr("recycling_guide_description"),
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
                  // tr("error.home_page_error"),
                  message,
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