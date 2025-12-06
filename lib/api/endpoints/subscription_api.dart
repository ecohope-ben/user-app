import 'package:dio/dio.dart';

import '../../models/subscription_models.dart';
import '../index.dart';

class SubscriptionApi extends ApiEndpoint {
  SubscriptionApi(super.api);

  /// List available subscription plans
  Future<PlanListEnvelope> listPlans() async {
    try {
      final response = await http.get(
        '/subscription-plans'
      );
      return PlanListEnvelope.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleSubscriptionDioError(e);
    }
  }

  /// Get subscription plan detail
  Future<PlanDetail> getPlan({
    required String planId
  }) async {
    try {
      final response = await http.get(
        '/subscription-plans/$planId',
      );
      return PlanDetail.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleSubscriptionDioError(e);
    }
  }

  /// Preview subscription creation
  Future<PreviewSubscriptionResponse> previewSubscription({
    required PreviewSubscriptionCreationRequest request,
  }) async {
    try {
      final response = await http.post(
        '/subscriptions/preview',
        data: request.toJson(),
      );
      return PreviewSubscriptionResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleSubscriptionDioError(e);
    }
  }

  /// Create subscription
  Future<CreateSubscriptionResponse> createSubscription({
    required CreateSubscriptionRequest request,
  }) async {
    try {
      final response = await http.post(
        '/subscriptions',
        data: _clean(request.toJson()),
      );
      return CreateSubscriptionResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleSubscriptionDioError(e);
    }
  }

  /// List existing subscriptions for authenticated customer
  Future<SubscriptionListEnvelope> listSubscriptions() async {
    try {
      final response = await http.get(
        '/subscriptions',
      );
      return SubscriptionListEnvelope.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleSubscriptionDioError(e);
    }
  }

  /// Get subscription detail
  Future<SubscriptionDetail> getSubscriptionDetail({required String subscriptionId}) async {
    try {
      final response = await http.get(
        '/subscriptions/$subscriptionId'
      );
      return SubscriptionDetail.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleSubscriptionDioError(e);
    }
  }

  /// Check activation result for subscription
  Future<ActivateSubscriptionResponse> checkActivation({required String subscriptionId}) async {
    try {
      final response = await http.post(
        '/subscriptions/$subscriptionId/activate'
      );
      return ActivateSubscriptionResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleSubscriptionDioError(e);
    }
  }

  /// Update delivery address for subscription
  Future<void> updateAddress({
    required String subscriptionId,
    required UpdateAddressRequest request,
  }) async {
    try {
      await http.put(
        '/subscriptions/$subscriptionId/address',
        data: request.toJson(),
      );
    } on DioException catch (e) {
      throw _handleSubscriptionDioError(e);
    }
  }

  /// Schedule plan change
  Future<void> schedulePlanChange({
    required String subscriptionId,
    required SchedulePlanChangeRequest request,
  }) async {
    try {
      await http.post(
        '/subscriptions/$subscriptionId/plan-change',
        data: request.toJson(),
      );
    } on DioException catch (e) {
      throw _handleSubscriptionDioError(e);
    }
  }

  /// Cancel scheduled plan change
  Future<void> cancelPlanChange({required String subscriptionId}) async {
    try {
      await http.delete('/subscriptions/$subscriptionId/plan-change');
    } on DioException catch (e) {
      throw _handleSubscriptionDioError(e);
    }
  }

  /// Schedule cancellation at period end
  Future<void> scheduleCancellation({required String subscriptionId}) async {
    try {
      await http.post('/subscriptions/$subscriptionId/cancellation');
    } on DioException catch (e) {
      throw _handleSubscriptionDioError(e);
    }
  }

  /// Cancel previously scheduled cancellation
  Future<void> cancelCancellation({required String subscriptionId}) async {
    try {
      await http.delete('/subscriptions/$subscriptionId/cancellation');
    } on DioException catch (e) {
      throw _handleSubscriptionDioError(e);
    }
  }

  /// Request payment method update
  Future<RequestPaymentMethodUpdateResponse> requestPaymentMethodUpdate({
    required String subscriptionId,
  }) async {
    try {
      final response = await http.post(
        '/subscriptions/$subscriptionId/payment-method/request',
      );
      return RequestPaymentMethodUpdateResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleSubscriptionDioError(e);
    }
  }

  /// Complete payment method update
  Future<void> completePaymentMethodUpdate({
    required String subscriptionId,
    required CompletePaymentMethodUpdateRequest request,
  }) async {
    try {
      await http.post(
        '/subscriptions/$subscriptionId/payment-method/complete',
        data: request.toJson(),
      );
    } on DioException catch (e) {
      throw _handleSubscriptionDioError(e);
    }
  }

  Map<String, dynamic> _clean(Map<String, dynamic> payload) {
    payload.removeWhere((key, value) => value == null);
    return payload;
  }

  Exception _handleSubscriptionDioError(DioException e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      try {
        final errorSource = data.containsKey('error') && data['error'] is Map
            ? Map<String, dynamic>.from(data['error'] as Map)
            : data;
        final errorBody = SubscriptionErrorBody.fromJson(errorSource);

        return SubscriptionException(
          code: errorBody.code,
          message: errorBody.userMessage ??
              errorBody.debugMessage ??
              'Subscription request failed',
          httpStatus: errorBody.httpStatus,
          debugMessage: errorBody.debugMessage,
          fieldErrors: errorBody.fieldErrors,
        );
      } catch (parseError) {
        // fall through to network style error below
      }
    }

    return SubscriptionException(
      code: e.type.name,
      message: e.message ?? 'Network error occurred',
      httpStatus: e.response?.statusCode ?? 0,
      debugMessage: e.message,
    );
  }
}

/// Subscription specific exception
class SubscriptionException implements Exception {
  final String code;
  final String message;
  final int httpStatus;
  final String? debugMessage;
  final Map<String, List<FieldViolation>>? fieldErrors;

  const SubscriptionException({
    required this.code,
    required this.message,
    required this.httpStatus,
    this.debugMessage,
    this.fieldErrors,
  });

  @override
  String toString() =>
      'SubscriptionException: $message (Code: $code, Status: $httpStatus)';
}

