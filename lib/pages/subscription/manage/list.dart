import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/blocs/subscription_cubit.dart';
import 'package:user_app/style.dart';
import 'package:user_app/utils/time.dart';

import '../../../blocs/subscription_plan_cubit.dart';
import '../../../components/subscription/card.dart';
import '../../../components/subscription/notice_banner.dart';
import '../../../models/subscription_models.dart';
import '../../../routes.dart';
import '../../common/error_view.dart';

enum SubscriptionManageTarget{
  normal, manage, change
}
class SubscriptionManageListPage extends StatefulWidget {
  final SubscriptionManageTarget target;
  const SubscriptionManageListPage(this.target, {super.key});

  @override
  State<SubscriptionManageListPage> createState() => _SubscriptionManageListPageState();
}

class _SubscriptionManageListPageState extends State<SubscriptionManageListPage> {
  Map<String, List<String>>? _planFeaturesMap;
  bool _isLoadingFeatures = false;
  Locale? _currentLocale;

  @override
  void initState() {
    super.initState();
    // Load features after first frame to get context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      printRouteStack(context);
      if (mounted) {
        _currentLocale = context.locale;
        _loadPlanFeatures();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload features if locale changed
    final currentLocale = context.locale;
    if (_currentLocale != null && _currentLocale != currentLocale) {
      _currentLocale = currentLocale;
      _loadPlanFeatures();
    } else {
      _currentLocale ??= currentLocale;
    }
  }

  /// Get current language code based on locale
  String _getLanguageCode(BuildContext context) {
    final locale = context.locale;
    switch (locale.countryCode) {
      case 'HK':
        return 'zh-hk';
      case 'US':
      default:
        return 'en';
    }
  }

  Future<void> _loadPlanFeatures() async {
    if (_isLoadingFeatures) return;
    
    setState(() {
      _isLoadingFeatures = true;
    });

    try {
      // final String jsonString = await rootBundle.loadString('assets/data/plans.json');
      final Map<String, dynamic> jsonData;

      final dio = Dio();
      final response = await dio.get('https://assets.eco-hope.org/plan_data/plans.json');
      if (response.statusCode == 200 && response.data != null) {
        jsonData = response.data as Map<String, dynamic>;

        // Get current language code
        final languageCode = _getLanguageCode(context);

        final Map<String, List<String>> featuresMap = {};
        jsonData.forEach((billingCycle, planData) {
          if (planData is Map<String, dynamic> && planData['features'] is Map) {
            final featuresByLang = planData['features'] as Map<String, dynamic>;
            // Get features for current language, fallback to 'en' if not found
            if (featuresByLang.containsKey(languageCode) && featuresByLang[languageCode] is List) {
              featuresMap[billingCycle] = List<String>.from(featuresByLang[languageCode]);
            } else if (featuresByLang.containsKey('en') && featuresByLang['en'] is List) {
              // Fallback to English if current language not found
              featuresMap[billingCycle] = List<String>.from(featuresByLang['en']);
            }
          }
        });


        setState(() {
          _planFeaturesMap = featuresMap;
          _isLoadingFeatures = false;
        });
      }
    } catch (e) {
      // If loading fails, continue without features map (fallback to description)
      setState(() {
        _planFeaturesMap = {};
        _isLoadingFeatures = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => SubscriptionCubit()..getCurrentSubscription()),
          BlocProvider(create: (_) => SubscriptionPlanCubit()..loadPlans()),
        ],
      child: PopScope(
        canPop: context.canPop(),
        onPopInvokedWithResult: (didPop, t){
          if (didPop) {
            return; // If the pop was successful, do nothing additional
          } else{
            context.go("/home");
          }
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: mainPurple,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () {
                  if(context.canPop()){
                    context.pop();
                  }else{
                    context.go("/home");
                  }
                },
              ),
              title: Text(
                tr("subscriptions"),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
            ),
            body: Builder(
              builder: (context) {
                return RefreshIndicator(
                    onRefresh: () async {
                      context.read<SubscriptionCubit>().getCurrentSubscription();
                      context.read<SubscriptionPlanCubit>().loadPlans();
                    },
                    child: _buildBody(context)
                );
              }
            )
        ),
      )
    );
  }
  
  Widget _buildBody(BuildContext context){

    final subscriptionState = context.watch<SubscriptionCubit>().state;
    final planState = context.watch<SubscriptionPlanCubit>().state;
    final bool isReady = subscriptionState is SubscriptionDetailAndListLoaded && planState is SubscriptionPlansLoaded;
    final String? errorMessage = _resolveErrorMessage(subscriptionState, planState);
    if (errorMessage != null) {
      return CommonErrorView(
        message: errorMessage,
        onRetry: () {
          context.read<SubscriptionCubit>().getCurrentSubscription();
          context.read<SubscriptionPlanCubit>().loadPlans();
        },
      );
    }
    if (isReady) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(widget.target == SubscriptionManageTarget.manage) ..._buildMangePlanTitle(),

            // Plan cards
            ..._buildPlanList(planState.plans, subscriptionState.detail)

          ],
        ),
      );
    }else {
      return Center(child: CircularProgressIndicator());
    }
  }

  String? _resolveErrorMessage(
      SubscriptionState subscriptionState,
      SubscriptionPlanState planState
      ) {
    if (subscriptionState is SubscriptionError) {
      print("--SubscriptionError");
      return subscriptionState.message;
    }
    if (planState is SubscriptionPlanError) {
      print("--SubscriptionPlanError");
      return planState.message;
    }
    return null;
  }
  List<Widget> _buildMangePlanTitle(){
    return [
      Text(
        tr("subscription.your_subscription"),
        style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 4),
      Text(
        tr("subscription.your_subscription_mange"),
        style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 4),
    ];
  }

  Widget _buildChangePlanTitle(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr("subscription.your_subscription_may_like"),
          style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text(

          tr("subscription.your_subscription_cancel_anytime"),
          style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w500),
        ),

        const SizedBox(height: 4),
      ],
    );
  }
  List<Widget> _buildPlanList(List<PlanListItem> plans, SubscriptionDetail currentSubscription){
    List<Widget> list = [];
    for (PlanListItem plan in plans) {

      // Get features from plans.json, fallback to description if not found
      List<String> features;
      if (_planFeaturesMap != null && _planFeaturesMap!.containsKey(plan.billingCycle.name)) {
        features = _planFeaturesMap![plan.billingCycle.name]!;
      } else {
        // Fallback to parsing description
        features = plan.description
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .toList();
      }
      if(currentSubscription.plan.id == plan.id){

        if(widget.target == SubscriptionManageTarget.manage) {
          // list.insert(0, SubscriptionCard(
          //     plan: plan,
          //     features: features,
          //     isCurrentPlan: true,
          //     isPaymentFailed: currentSubscription.lifecycleState == SubscriptionLifecycleState.pastDue,
          //     isSubscriptionCanceled: currentSubscription.scheduledCancellation != null,
          //     subscriptionId: currentSubscription.id)
          // );
          // if(currentSubscription.scheduledCancellation != null){
            list.insert(0, Column(
              children: [

                if(currentSubscription.scheduledPlanChange != null) ChangePlanNoticeBanner(currentSubscription.scheduledPlanChange?.plan.name, convertDateTimeToString(context, currentSubscription.currentPeriodEnd)),
                if(currentSubscription.scheduledPlanChange != null) SizedBox(height: 12),
                if(currentSubscription.scheduledCancellation != null) CancelPlanNoticeBanner(convertDateTimeToString(context, currentSubscription.currentPeriodEnd)),
                if(currentSubscription.scheduledCancellation != null) SizedBox(height: 12),
                SubscriptionCard(
                    plan: plan,
                    features: features,
                    isCurrentPlan: true,
                    isPaymentFailed: currentSubscription.lifecycleState == SubscriptionLifecycleState.pastDue,
                    isSubscriptionCanceled: currentSubscription.scheduledCancellation != null,
                    subscriptionId: currentSubscription.id)
              ],
            ));
        }

      }else {
        list.add(SubscriptionCard(plan: plan, features: features, target: SubscriptionManageTarget.change, subscriptionId: currentSubscription.id));
      }

    }

    if(widget.target == SubscriptionManageTarget.manage) {
      list.insert(1, _buildChangePlanTitle());
    }else {
      // for Change Plan
      list.insert(0, _buildChangePlanTitle());
    }


    return list;
  }
}