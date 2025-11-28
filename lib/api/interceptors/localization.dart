import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../index.dart';

const _apiUserAgent = "com.epods.epodsDriver/";

class ApiLocalizationInterceptor extends Interceptor {
  final BuildContext context;

  ApiLocalizationInterceptor(this.context);

  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers["Accept-Language"] = setAcceptLanguage();
    return super.onRequest(options, handler);
  }

  String? setAcceptLanguage() {
    String? acceptLanguage;
    switch (context.locale.countryCode) {
      case 'US':
        acceptLanguage = 'en';
        break;
      case 'HK':
        acceptLanguage = 'zh-hk';
        break;
    }

    return acceptLanguage;
  }
}
