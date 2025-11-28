import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/components/home/promotion_banner.dart';
import 'package:user_app/components/home/recycle_info_card.dart';
import 'package:user_app/routes.dart';

import '../blocs/entitlement_cubit.dart';
import '../blocs/login_cubit.dart';
import '../blocs/profile_cubit.dart';
import '../blocs/subscription_cubit.dart';
import '../components/home/silver.dart';
import '../style.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProfileCubit()..loadProfile()),
        BlocProvider(create: (_) => EntitlementCubit()..loadEntitlements()),
        BlocProvider(create: (_) => SubscriptionCubit()..loadSubscriptions()),
      ],
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final profileState = context.watch<ProfileCubit>().state;
    final entitlementState = context.watch<EntitlementCubit>().state;
    final subscriptionState = context.watch<SubscriptionCubit>().state;

    final String? errorMessage = _resolveErrorMessage(
      profileState,
      entitlementState,
      subscriptionState,
    );

    if (errorMessage != null) {
      return _HomeErrorView(
        message: errorMessage,
        onRetry: () {
          context.read<ProfileCubit>().loadProfile();
          context.read<EntitlementCubit>().loadEntitlements();
          context.read<SubscriptionCubit>().loadSubscriptions();
        },
      );
    }

    final bool isReady =
        profileState is ProfileLoaded &&
        entitlementState is EntitlementLoaded &&
        subscriptionState is SubscriptionListLoaded;

    if (!isReady) {
      return const _HomeSkeleton();
    }

    return const _HomeContent();
  }

  String? _resolveErrorMessage(
    ProfileState profileState,
    EntitlementState entitlementState,
    SubscriptionState subscriptionState,
  ) {
    if (profileState is ProfileError) {
      return profileState.message;
    }
    if (entitlementState is EntitlementError) {
      return entitlementState.message;
    }
    if (subscriptionState is SubscriptionError) {
      return subscriptionState.message;
    }
    return null;
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

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
                SliverBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        PromotionBanner(
                          () => context.push("/subscription/list"),
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
                              ),
                              const SizedBox(height: 16),
                              RecycleInfoCard(
                                title: "Recycling Guide",
                                description:
                                    "Dos and Don’ts we rely on you to apply the recycling guide properly!",
                                imagePath: "assets/widget/recycle_guide.png",
                                icon: Icons.list_alt,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: CustomBottomNavBar(),
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
            const Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: CustomBottomNavBar(),
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onRetry,
                    child: const Text("Retry"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

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

            // 中間突出的大圓按鈕
            Positioned(
              top: 0,
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
            ),
          ],
        ),
      ),
    );
  }
}
