import 'package:dio/dio.dart';

import '../../models/entitlement_models.dart';
import '../index.dart';

class EntitlementApi extends ApiEndpoint {
  EntitlementApi(super.api);

  /// List entitlements for authenticated customer
  Future<EntitlementListEnvelope> listEntitlements() async {
    try {
      final response = await http.get('/entitlements');
      print("--entitlement list: ");
      print(response.data);
      return EntitlementListEnvelope.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleEntitlementError(e);
    }
  }

  Exception _handleEntitlementError(DioException e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      try {
        final parsed = EntitlementErrorBody.fromJson(data);
        return EntitlementException(
          code: parsed.code,
          message: parsed.userMessage ??
              parsed.debugMessage ??
              'Failed to fetch entitlements',
          httpStatus: parsed.httpStatus,
          debugMessage: parsed.debugMessage,
        );
      } catch (_) {
        // fall through if parsing fails
      }
    }

    return EntitlementException(
      code: e.type.name,
      message: e.message ?? 'Network error occurred',
      httpStatus: e.response?.statusCode ?? 0,
      debugMessage: e.message,
    );
  }
}

class EntitlementException implements Exception {
  final String code;
  final String message;
  final int httpStatus;
  final String? debugMessage;

  const EntitlementException({
    required this.code,
    required this.message,
    required this.httpStatus,
    this.debugMessage,
  });

  @override
  String toString() =>
      'EntitlementException: $message (Code: $code, Status: $httpStatus)';
}

