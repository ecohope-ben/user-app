import 'package:dio/dio.dart';
import '../models/registration_models.dart';

class RegistrationApiService {
  static const String baseUrl = 'http://192.168.50.237:3001';

  final Dio _dio;

  RegistrationApiService({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
    },
  ));


  Future<RegistrationSuccessResponse> startRegistration() async {
    try {
      final response = await _dio.post('/auth/registration/start');
      return RegistrationSuccessResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// get register session
  Future<RegistrationSuccessResponse> getRegistrationSession({
    required String registrationId,
    required String stepToken,
  }) async {
    try {
      final response = await _dio.get(
        '/auth/registration/$registrationId/session',
        options: Options(
          headers: {
            'Authorization': 'Step $stepToken',
          },
        ),
      );
      return RegistrationSuccessResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// update register info
  Future<RegistrationSuccessResponse> updateRegistration({
    required String registrationId,
    required String stepToken,
    required RegistrationUpdateRequest request,
  }) async {
    try {
      final response = await _dio.patch(
        '/auth/registration/$registrationId',
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Step $stepToken',
          },
        ),
      );
      return RegistrationSuccessResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Request email OTP
  Future<RegistrationSuccessResponse> requestEmailOtp({
    required String registrationId,
    required String stepToken,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/registration/$registrationId/email/request',
        options: Options(
          headers: {
            'Authorization': 'Step $stepToken',
          },
        ),
      );
      return RegistrationSuccessResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Verify email OTP
  Future<RegistrationSuccessResponse> verifyEmailOtp({
    required String registrationId,
    required String stepToken,
    required String code,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/registration/$registrationId/email/verify',
        data: OtpVerifyRequest(code: code).toJson(),
        options: Options(
          headers: {
            'Authorization': 'Step $stepToken',
          },
        ),
      );
      return RegistrationSuccessResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Request phone OTP
  Future<RegistrationSuccessResponse> requestPhoneOtp({
    required String registrationId,
    required String stepToken,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/registration/$registrationId/phone/request',
        options: Options(
          headers: {
            'Authorization': 'Step $stepToken',
          },
        ),
      );

      return RegistrationSuccessResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Verify phone OTP
  Future<RegistrationCompletedResponse> verifyPhoneOtp({
    required String registrationId,
    required String stepToken,
    required String code,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/registration/$registrationId/phone/verify',
        data: OtpVerifyRequest(code: code).toJson(),
        options: Options(
          headers: {
            'Authorization': 'Step $stepToken',
          },
        ),
      );
      return RegistrationCompletedResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// recover register
  Future<RegistrationSuccessResponse> recoverRegistration({
    required String registrationId,
    required String resumeToken,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/registration/$registrationId/recover',
        options: Options(
          headers: {
            'Authorization': 'Resume $resumeToken',
          },
        ),
      );
      return RegistrationSuccessResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Handle Dio errors
  Exception _handleDioError(DioException e) {
    print('Dio Error: ${e.message}');
    print('Response: ${e.response?.data}');
    if (e.response?.data != null) {
      try {
        final errorBody = ErrorBody.fromJson(e.response!.data);
        return RegistrationException(
          code: errorBody.code,
          message: errorBody.message,
          httpStatus: errorBody.httpStatus,
          fields: errorBody.fields,
        );
      } catch (parseError) {
        print('Error parsing response: $parseError');
      }
    }
    
    return RegistrationException(
      code: e.type.toString(),
      message: e.message ?? 'Network error occurred',
      httpStatus: e.response?.statusCode ?? 0,
    );
  }

  void dispose() {
    _dio.close();
  }
}

class RegistrationException implements Exception {
  final String code;
  final String message;
  final int httpStatus;
  final Map<String, List<FieldError>>? fields;

  const RegistrationException({
    required this.code,
    required this.message,
    required this.httpStatus,
    this.fields,
  });

  @override
  String toString() => 'RegistrationException: $message (Code: $code, Status: $httpStatus)';
}
