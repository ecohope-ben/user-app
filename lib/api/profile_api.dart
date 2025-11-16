import 'package:dio/dio.dart';
import '../models/profile_models.dart';
import 'index.dart';

class ProfileApi extends ApiEndpoint {
  ProfileApi(super.api);

  /// Get current profile
  Future<ProfileEnvelope> getProfile({
    required String accessToken,
  }) async {
    try {
      final response = await http.get(
        '/api/v1/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      return ProfileEnvelope.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleProfileDioError(e);
    }
  }

  /// Update profile
  Future<void> updateProfile({
    required String accessToken,
    required ProfilePatchRequest request,
  }) async {
    try {
      await http.patch(
        '/api/v1/profile',
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
    } on DioException catch (e) {
      throw _handleProfileDioError(e);
    }
  }

  /// Handle Dio errors for profile
  Exception _handleProfileDioError(DioException e) {
    print('Profile API Error: ${e.message}');
    print('Response: ${e.response?.data}');

    if (e.response?.data != null) {
      try {
        final errorBody = ProfileErrorBody.fromJson(e.response!.data);
        return ProfileException(
          code: errorBody.code,
          message: errorBody.message,
          httpStatus: errorBody.httpStatus,
          fields: errorBody.fields,
        );
      } catch (parseError) {
        print('Error parsing response: $parseError');
      }
    }

    return ProfileException(
      code: 'unknown_error',
      message: e.message ?? 'An unknown error occurred',
      httpStatus: e.response?.statusCode ?? 0,
    );
  }
}


/// Profile exception
class ProfileException implements Exception {
  final String code;
  final String message;
  final int httpStatus;
  final Map<String, List<FieldError>>? fields;

  const ProfileException({
    required this.code,
    required this.message,
    required this.httpStatus,
    this.fields,
  });

  @override
  String toString() => 'ProfileException: $message (Code: $code, Status: $httpStatus)';
}


