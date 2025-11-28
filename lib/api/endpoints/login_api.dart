import 'package:dio/dio.dart';

import '../../models/login_models.dart';
import '../../models/registration_models.dart';
import '../index.dart';

class LoginApi extends ApiEndpoint {
  LoginApi(super.api);

  Future<LoginSuccessResponse> startLogin() async {
    try {
      final response = await http.post('/auth/login/start');
      return LoginSuccessResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleLoginDioError(e);
    }
  }

  Future<LoginSuccessResponse> getLoginSession({
    required String loginId,
    required String stepToken,
  }) async {
    try {
      final response = await http.get(
        '/auth/login/$loginId/session',
        options: Options(
          headers: {
            'Authorization': 'Step $stepToken',
          },
        ),
      );
      return LoginSuccessResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleLoginDioError(e);
    }
  }

  Future<LoginSuccessResponse> updateLogin({
    required String loginId,
    required String stepToken,
    required LoginUpdateRequest request,
  }) async {
    try {
      final data = Map<String, dynamic>.from(request.toJson())
        ..removeWhere((key, value) => value == null);

      final response = await http.patch(
        '/auth/login/$loginId',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Step $stepToken',
          },
        ),
      );
      return LoginSuccessResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleLoginDioError(e);
    }
  }

  Future<LoginSuccessResponse> requestEmailOtp({
    required String loginId,
    required String stepToken,
  }) async {
    try {
      final response = await http.post(
        '/auth/login/$loginId/email/request',
        options: Options(
          headers: {
            'Authorization': 'Step $stepToken',
          },
        ),
      );
      return LoginSuccessResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleLoginDioError(e);
    }
  }

  Future<LoginSuccessResponse> verifyEmailOtp({
    required String loginId,
    required String stepToken,
    required String code,
  }) async {
    try {
      print("--verifyEmailOtp");
      final response = await http.post(
        '/auth/login/$loginId/email/verify',
        data: OtpVerifyRequest(code: code).toJson(),
        options: Options(
          headers: {
            'Authorization': 'Step $stepToken',
          },
        ),
      );
      return LoginSuccessResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleLoginDioError(e);
    }
  }

  Future<LoginSuccessResponse> recoverLogin({
    required String loginId,
    required String resumeToken,
  }) async {
    try {
      final response = await http.post(
        '/auth/login/$loginId/recover',
        options: Options(
          headers: {
            'X-Login-Resume-Token': resumeToken,
          },
        ),
      );
      return LoginSuccessResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleLoginDioError(e);
    }
  }

  // Refresh session using refresh token
  // Note: This method should be called with refresh token in Authorization header
  // The interceptor will handle this automatically
  Future<Session> refreshSession() async {
    try {
      final response = await http.post('/auth/session/refresh');
      return Session.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleLoginDioError(e);
    }
  }

  Exception _handleLoginDioError(DioException e) {
    print('--Login Dio Error: ${e.message}');
    print('--Login Response: ${e.response?.data}');
    final data = e.response?.data;
    if (data != null) {
      try {
        final errorBody = ErrorBody.fromJson(data['error']);
        LoginSnapshot? snapshot;
        if (data['login'] != null) {
          snapshot = LoginSnapshot.fromJson(data['login']);
        }
        return LoginException(
          code: errorBody.code,
          message: errorBody.userMessage ?? '',
          httpStatus: errorBody.httpStatus,
          login: snapshot,
          fields: errorBody.fields,
        );
      } catch (parseError, stackTrace) {
        print('Error parsing login response: $parseError');
        print(stackTrace);
      }
    }

    return LoginException(
      code: e.type.name,
      message: e.message ?? 'Network error occurred',
      httpStatus: e.response?.statusCode ?? 0,
    );
  }
}

class LoginException implements Exception {
  final String code;
  final String message;
  final int httpStatus;
  final LoginSnapshot? login;
  final Map<String, List<FieldError>>? fields;

  const LoginException({
    required this.code,
    required this.message,
    required this.httpStatus,
    this.login,
    this.fields,
  });

  @override
  String toString() => 'LoginException: $message (Code: $code, Status: $httpStatus)';
}


