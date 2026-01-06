import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/auth/index.dart';

import '../api/index.dart';
import '../models/discount/index.dart';
import '../models/onboarding_models.dart';
import '../models/subscription_models.dart';
import '../utils/snack.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key});

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  Map<String, dynamic>? _discountData;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async{

    await _fetchDefaultDiscount();
    await _bootstrap();
  }

  Future<void> _bootstrap() async {
    final auth = Auth.instance();
    await auth.initialize();

    final prefs = await SharedPreferences.getInstance();
    bool firstRun = prefs.getBool('first_run') ?? true;
    if (firstRun) {
      auth.removeAllStorage();
    }
    if (!mounted) return;

    final token = auth.accessToken;
    if (token != null && token.isNotEmpty) {
      checkOnboarding(context);
      // context.go('/home');
    } else {
      if(firstRun) {
        context.go('/welcome');
      }else{
        // context.go('/welcome');
        context.go("/get_start");
      }
    }

    prefs.setBool('first_run', false);
  }

  Future<void> checkOnboarding(BuildContext context) async {
    try {
      final result = await Api.instance().onboarding().getStatus();
      if (result.onboarding.status == OnboardingStatus.completed) {
        if(mounted) context.go("/home");
      } else {
        if(mounted) context.push("/onboarding_profile");
      }
    } catch (e) {
      if(mounted) popSnackBar(context, tr("login.error_message"));
      context.go("/get_start");
    }
  }
  /// Fetch discount-int.json from remote URL
  Future<void> _fetchDefaultDiscount() async {
    try {
      final dio = Dio();
      final response = await dio.get('https://assets.eco-hope.org/plan_data/discount-int.json');

      if (response.statusCode == 200 && response.data != null) {
          _discountData = response.data as Map<String, dynamic>;

          final prefs = await SharedPreferences.getInstance();
          if(_discountData?["promotion_code"] != null){
            // save discount detail to prefs
            prefs.setString("promotionCode", json.encode(_discountData));

            Discount.instance().promotionCode = _discountData?["promotion_code"];
            Discount.instance().planId = _discountData?["plan_id"];
            Discount.instance().versionId = _discountData?["version_id"];

            // verify promote code
            try {
              final preview = await Api.instance().subscription().previewSubscription(request: PreviewSubscriptionCreationRequest(
                  promotionCode: Discount.instance().promotionCode,
                  planId: Discount.instance().planId ?? "",
                  planVersionId: Discount.instance().versionId ?? ""
              ));
              Discount.instance().setAmount(preview.amount);
            }catch(e){
              print("--error: $e");
            }
          }
          print("--discount: ${_discountData}");
      }
    } catch (e) {
      print('Error fetching discount.json: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/icon/white_logo.png", width: 180),
            SizedBox(height: 50),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}











