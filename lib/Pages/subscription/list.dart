import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/blocs/subscription_cubit.dart';
import 'package:user_app/routes.dart';
import 'package:user_app/style.dart';

import '../../blocs/subscription_plan_cubit.dart';
import '../../components/subscription/card.dart';
import '../../models/subscription_models.dart';


class SubscriptionListPage extends StatefulWidget {
  const SubscriptionListPage({super.key});

  @override
  State<SubscriptionListPage> createState() => _SubscriptionListPageState();
}

class _SubscriptionListPageState extends State<SubscriptionListPage> {
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
      final String jsonString = await rootBundle.loadString('assets/data/plans.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
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
    return BlocProvider(
      create: (context) => SubscriptionPlanCubit()..loadPlans(),
      child: BlocBuilder<SubscriptionPlanCubit, SubscriptionPlanState>(
        builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: mainPurple,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    context.pop();
                  },
                ),
                title: const Text(
                  "Subscriptions Plan",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                centerTitle: true,
              ),
              body: _buildBody(state)
            );
         
        },
      ),
    );
  }
  
  Widget _buildBody(SubscriptionPlanState state){
    if (state is SubscriptionPlansLoaded) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Join a plan to start recycling",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 4),
            const Text(
              "You can cancel anytime.",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 24),

            // Plan cards
            ..._buildPlanList(state.plans)

          ],
        ),
      );
    }else {
      return Center(child: CircularProgressIndicator());
    }
  }
  List<Widget> _buildPlanList(List<PlanListItem> plans){
    return plans.map((plan) {

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
      
      return SubscriptionCard(plan: plan, features: features);
    }).toList();
  }
}