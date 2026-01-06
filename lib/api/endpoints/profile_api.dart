import 'package:dio/dio.dart';
import '../../models/profile_models.dart';
import '../index.dart';

class ProfileApi extends ApiEndpoint {
  ProfileApi(super.api);

  /// Get current profile
  Future<ProfileEnvelope> getProfile() async {
    try {
      final response = await http.get('/profile',);
      return ProfileEnvelope.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleProfileDioError(e);
    }
  }

  /// Update profile
  Future<void> updateProfile({
    // required String accessToken,
    required ProfilePatchRequest request,
  }) async {
    try {
      await http.post('/onboarding/complete-profile', data: request.toJson());
    } on DioException catch (e) {
      throw _handleProfileDioError(e);
    }
  }

  Future<void> deleteAccount() async {
    try {
      await http.post('/me/deletion');
    } on DioException catch (e) {
      throw _handleProfileDioError(e);
    }
  }

  Future<void> patchProfile({
    // required String accessToken,
    required ProfilePatchRequest request,
  }) async {
    try {
      await http.patch('/profile', data: request.toJson());
    } on DioException catch (e) {
      throw _handleProfileDioError(e);
    }
  }

  /// Handle Dio errors for profile
  Exception _handleProfileDioError(DioException e) {
    if (e.response?.data != null) {
      try {
        final errorBody = ProfileErrorBody.fromJson(e.response!.data);
        return ProfileException(
          code: errorBody.code,
          userMessage: errorBody.userMessage,
          httpStatus: errorBody.httpStatus,
          fields: errorBody.fields,
        );
      } catch (parseError) {
        print('Error parsing response: $parseError');
      }
    }

    return ProfileException(
      code: 'unknown_error',
      userMessage: e.message ?? 'An unknown error occurred',
      httpStatus: e.response?.statusCode ?? 0,
    );
  }
}


/// Profile exception
class ProfileException implements Exception {
  final String code;
  final String? userMessage;
  final String? debugMessage;
  final int httpStatus;
  final Map<String, List<FieldError>>? fields;

  const ProfileException({
    required this.code,
    this.userMessage,
    this.debugMessage,
    required this.httpStatus,
    this.fields,
  });

  @override
  String toString() => 'ProfileException: $userMessage (Code: $code, Status: $httpStatus)';
}


