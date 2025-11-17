import 'dart:developer';
import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/profile_models.dart';
import '../models/registration_models.dart';
import 'endpoints/profile_api.dart';
import 'endpoints/registration_api.dart';


class Api {
  static final Api _instance = Api._internal(Dio());
  final Dio dio;

  static Api instance() => _instance;

  Api._internal(this.dio) {

    if (kDebugMode) {
      dio.interceptors
          .add(LogInterceptor(requestBody: true, responseBody: true));
    }
  }

  Api setBaseUrl(String baseUrl) {
    dio.options.baseUrl = baseUrl;
    return this;
  }

  Api addInterceptor(Interceptor interceptor) {
    dio.interceptors.add(interceptor);
    return this;
  }

  Map<Type, ApiEndpoint> map = Map();

  ApiEndpoint? getApi<T extends ApiEndpoint>(T Function() builder) {
    if (!map.containsKey(T)) {
      map[T] = builder();
    }
    return map[T];
  }



  RegisterApi register() => getApi<RegisterApi>(() => RegisterApi(this)) as RegisterApi;
  ProfileApi profile() => getApi<ProfileApi>(() => ProfileApi(this)) as ProfileApi;
}

abstract class ApiEndpoint {
  final Api api;

  ApiEndpoint(this.api);

  Dio get http => api.dio;
  String get deviceModel => Platform.operatingSystem;
}


// T handleRes<T>(Response res, T Function(dynamic) builder, {bool willReLogin = true}) {
//   if (res.data['status'] != ApiResponseCode.SUCCESS) {
//     print("--ApiException error: ${res.data['status']}, ${res.data[""]}");
//     try {
//       if (res.data['status'] == ApiResponseCode.UNAUTHORIZED && willReLogin) {
//
//         String? currentName =
//             ModalRoute.of(GlobalVariable.navState.currentContext!)!
//                 .settings
//                 .name;
//         print("--currentName: $currentName");
//       }
//     } catch (e) {
//       log(e.toString());
//     }
//
//     throw new ApiException.fromJson(res.data);
//   }
//   return builder(res.data);
// }


class ApiResponse {

}

class ApiException extends ApiResponse implements Exception {

}


