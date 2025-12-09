import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../models/registration_models.dart';
import '../index.dart';

/// Registration API endpoint
class RegisterApi extends ApiEndpoint {
  RegisterApi(super.api);

  /// Start registration
  Future<RegistrationSuccessResponse> startRegistration() async {
    try {
      final response = await http.post('/auth/registration/start');
      return RegistrationSuccessResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleRegistrationDioError(e);
    }
  }

  /// Get register session
  Future<RegistrationSuccessResponse> getRegistrationSession({
    required String registrationId,
    required String stepToken,
  }) async {
    try {
      final response = await http.get(
        '/auth/registration/$registrationId/session',
        options: Options(
          headers: {
            'Authorization': 'Step $stepToken',
          },
        ),
      );
      return RegistrationSuccessResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleRegistrationDioError(e);
    }
  }

  /// Update register info
  Future<RegistrationSuccessResponse> updateRegistration({
    required String registrationId,
    required String stepToken,
    required RegistrationUpdateRequest request,
  }) async {
    try {
      print("--update patch");

      Map<String, dynamic> requestMap = request.toJson();
      requestMap.removeWhere((key, value) => value == null);

      final response = await http.patch(
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
      throw _handleRegistrationDioError(e);
    }
  }

  /// Request email OTP
  Future<RegistrationSuccessResponse> requestEmailOtp({
    required String registrationId,
    required String stepToken,
  }) async {
    print("--requestEmailOtp");
    try {
      final response = await http.post(
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
      throw _handleRegistrationDioError(e);
    }
  }

  /// Verify email OTP
  Future<RegistrationSuccessResponse> verifyEmailOtp({
    required String registrationId,
    required String stepToken,
    required String code,
  }) async {
    try {
      final response = await http.post(
        '/auth/registration/$registrationId/email/verify',
        data: OtpVerifyRequest(code: code).toJson(),
        options: Options(
          headers: {
            'Authorization': 'Step $stepToken',
          },
        ),
      );
      if(response.data["session"] != null){
        print("--have session");

      }

      return RegistrationSuccessResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleRegistrationDioError(e);
    }
  }

  /// Request phone OTP
  Future<RegistrationSuccessResponse> requestPhoneOtp({
    required String registrationId,
    required String stepToken,
  }) async {
    try {
      final response = await http.post(
        '/auth/registration/$registrationId/phone/request',
        options: Options(
          headers: {
            'Authorization': 'Step $stepToken',
          },
        ),
      );

      return RegistrationSuccessResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleRegistrationDioError(e);
    }
  }

  /// Verify phone OTP
  Future<RegistrationCompletedResponse> verifyPhoneOtp({
    required String registrationId,
    required String stepToken,
    required String code,
  }) async {
    try {
      final response = await http.post(
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
      throw _handleRegistrationDioError(e);
    }
  }

  /// Recover register
  Future<RegistrationSuccessResponse> recoverRegistration({
    required String registrationId,
    required String resumeToken,
  }) async {
    try {
      final response = await http.post(
        '/auth/registration/$registrationId/recover',
        options: Options(
          headers: {
            'Authorization': 'Resume $resumeToken',
          },
        ),
      );
      return RegistrationSuccessResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleRegistrationDioError(e);
    }
  }

  /// Handle Dio errors for registration
  Exception _handleRegistrationDioError(DioException e) {
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
        return RegistrationException(
            message: tr("error.network_error"), code: '', httpStatus: 500,
        );
      }
    }

    return RegistrationException(
        code: e.type.toString(),
        message: e.message ?? 'Network error occurred',
        httpStatus: e.response?.statusCode ?? 0
    );
  }
}

/// Registration exception
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
