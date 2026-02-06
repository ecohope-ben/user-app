
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/index.dart';
import '../flavor.dart';
import '../models/discount/index.dart';
import '../models/subscription_models.dart';

Map<String, dynamic> cleanNullValueFromMap(Map<String, dynamic> payload) {
  payload.removeWhere((key, value) => value == null);
  return payload;
}

/// Fetch discount-{int}.json from remote URL
Future<Map<String, dynamic>?> fetchDefaultDiscount() async {
  try {
    final dio = Dio();
    final response = await dio.get('https://assets.eco-hope.org/plan_data/discount-${FlavorConfig.instance.name}.json');
    Map<String, dynamic>? discountData;
    if (response.statusCode == 200 && response.data != null) {
      discountData = response.data as Map<String, dynamic>;

      final prefs = await SharedPreferences.getInstance();
      if(discountData["promotion_code"] != null){
        // save discount detail to prefs
        prefs.setString("promotionCode", json.encode(discountData));

        Discount.instance().promotionCode = discountData?["promotion_code"];
        Discount.instance().planId = discountData?["plan_id"];
        Discount.instance().versionId = discountData?["version_id"];
        return discountData;
        // verify promote code
        // try {
        //   print("--preview");
        //   final preview = await Api.instance().subscription().previewSubscription(request: PreviewSubscriptionCreationRequest(
        //       promotionCode: Discount.instance().promotionCode,
        //       planId: Discount.instance().planId ?? "",
        //       planVersionId: Discount.instance().versionId ?? ""
        //   ));
        //   Discount.instance().setAmount(preview.amount);
        // }catch(e){
        //   print("--error: $e");
        // }
      }
      if(kDebugMode) {
        print("--discount: ${discountData}");
      }
    }
  } catch (e) {
    if(kDebugMode) {
      print('Error fetching discount.json: $e');
    }
  }
  return null;
}
