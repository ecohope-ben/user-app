import 'package:dio/dio.dart';
import '../models/registration_models.dart';

class RegistrationApiService {
  // static const String baseUrl = 'http://192.168.50.237:3001';
  static const String baseUrl = 'http://172.19.44.17:3001';

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

      print("--update patch");

      Map<String, dynamic> requestMap = request.toJson();
      requestMap.removeWhere((key, value) => value == null);

      final response = await _dio.patch(
        '/auth/registration/$registrationId',
        data: requestMap,
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
    print("--requestEmailOtp");
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
      print(e.response);
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
    print('--Dio Error: ${e.message}');
    print('--Response: ${e.response?.data}');
    print('--Response error: ${e.response?.data["error"]}');
    if(e.response?.statusCode == 401){
      print("--401 error");
    }else if(e.response?.statusCode == 422){
      print("--422 error");
    }
    if (e.response?.data != null) {
      try {
        final errorBody = ErrorBody.fromJson(e.response!.data["error"]);

        RegistrationSnapshot? registration;
        if(e.response!.data["registration"] != null){
          registration = RegistrationSnapshot.fromJson(e.response!.data["registration"]);
        }

        return RegistrationException(
          code: errorBody.code,
          message: errorBody.userMessage ?? "",
          httpStatus: errorBody.httpStatus,
          fields: errorBody.fields,
          registration: registration
        );
      } catch (parseError, t) {
        print('Error parsing response: $parseError');
        print(t);
      }
    }
    
    return RegistrationException(
      code: e.type.toString(),
      message: e.message ?? 'Network error occurred',
      httpStatus: e.response?.statusCode ?? 0
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
  final RegistrationSnapshot? registration;
  final Map<String, List<FieldError>>? fields;

  const RegistrationException({
    required this.code,
    required this.message,
    required this.httpStatus,
    this.registration,
    this.fields,
  });

  @override
  String toString() => 'RegistrationException: $message (Code: $code, Status: $httpStatus)';
}
