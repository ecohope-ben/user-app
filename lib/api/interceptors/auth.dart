import 'package:dio/dio.dart';

import '../../auth/index.dart';

class AuthorizationInterceptor extends Interceptor {
  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
      String? token = Auth.instance().accessToken;

      print("--AuthorizationInterceptor ");
      if (token != null) {
        print("--AuthorizationInterceptor token: ");
        print(token);
        options.headers["Authorization"] = "Bearer $token";
      }

      return super.onRequest(options, handler);
  }
}
