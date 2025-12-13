import 'package:dio/dio.dart';
import '../../models/onboarding_models.dart';
import '../../models/profile_models.dart';
import '../index.dart';

/// Onboarding API endpoint
class OnboardingApi extends ApiEndpoint {
  OnboardingApi(super.api);

  /// Get onboarding state
  /// Returns onboarding progress and next action. No PII.
  Future<OnboardingEnvelope> getStatus() async {
    try {
      final response = await http.get('/onboarding');
      return OnboardingEnvelope.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleOnboardingDioError(e);
    }
  }

  /// Complete profile to finish onboarding
  /// Submits minimal profile and transitions customer to active atomically.
  Future<void> completeProfile({
    required ProfilePatchRequest request,
  }) async {
    try {
      Map<String, dynamic> requestMap = request.toJson();
      requestMap.removeWhere((key, value) => value == null);

      await http.post(
        '/onboarding/complete-profile',
        data: requestMap,
      );
    } on DioException catch (e) {
      throw _handleOnboardingDioError(e);
    }
  }

  /// Handle Dio errors for onboarding
  Exception _handleOnboardingDioError(DioException e) {
    print('Onboarding API Error: ${e.message}');
    print('Response: ${e.response?.data}');

    if (e.response?.data != null) {
      try {
        final errorData = e.response!.data;
        final errorSource = errorData is Map<String, dynamic> &&
                errorData.containsKey('error') &&
                errorData['error'] is Map
            ? Map<String, dynamic>.from(errorData['error'] as Map)
            : errorData;

        final errorBody = OnboardingErrorBody.fromJson(errorSource);
        return OnboardingException(
          code: errorBody.code,
          userMessage: errorBody.userMessage,
          debugMessage: errorBody.debugMessage,
          httpStatus: errorBody.httpStatus,
          fields: errorBody.fields,
        );
      } catch (parseError) {
        print('Error parsing response: $parseError');
      }
    }

    return OnboardingException(
      code: 'unknown_error',
      userMessage: e.message ?? 'An unknown error occurred',
      httpStatus: e.response?.statusCode ?? 0,
    );
  }
}

/// Onboarding exception
class OnboardingException implements Exception {
  final String code;
  final String? userMessage;
  final String? debugMessage;
  final int httpStatus;
  final Map<String, List<FieldError>>? fields;

  const OnboardingException({
    required this.code,
    this.userMessage,
    this.debugMessage,
    required this.httpStatus,
    this.fields,
  });

  @override
  String toString() =>
      'OnboardingException: $userMessage (Code: $code, Status: $httpStatus)';
}

