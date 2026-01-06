import 'package:dio/dio.dart';

import '../../models/payment_models.dart';
import '../index.dart';

class PaymentApi extends ApiEndpoint {
  PaymentApi(super.api);

  /// List payment history for authenticated customer
  Future<PaymentListEnvelope> listPayments({
    PaymentStatus? status,
    PaymentType? type,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (status != null) {
        queryParameters['status'] = _paymentStatusToJsonValue(status);
      }
      if (type != null) {
        queryParameters['type'] = _paymentTypeToJsonValue(type);
      }
      if (limit != null) {
        queryParameters['limit'] = limit;
      }
      if (offset != null) {
        queryParameters['offset'] = offset;
      }

      final response = await http.get(
        '/payment/payment_record',
        queryParameters: queryParameters.isEmpty ? null : queryParameters,
      );
      return PaymentListEnvelope.fromJson(response.data);
    } on DioException catch (e) {
      throw _handlePaymentDioError(e);
    }
  }

  /// Get payment detail by payment ID
  Future<PaymentDetailEnvelope> getPaymentDetail({
    required String paymentId,
  }) async {
    try {
      final response = await http.get(
        '/payments/$paymentId',
      );
      return PaymentDetailEnvelope.fromJson(response.data);
    } on DioException catch (e) {
      throw _handlePaymentDioError(e);
    }
  }

  /// Convert PaymentStatus enum to JSON value string
  String _paymentStatusToJsonValue(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return 'pending';
      case PaymentStatus.processing:
        return 'processing';
      case PaymentStatus.succeeded:
        return 'succeeded';
      case PaymentStatus.failed:
        return 'failed';
      case PaymentStatus.canceled:
        return 'canceled';
      case PaymentStatus.refunded:
        return 'refunded';
    }
  }

  /// Convert PaymentType enum to JSON value string
  String _paymentTypeToJsonValue(PaymentType type) {
    switch (type) {
      case PaymentType.subscription:
        return 'subscription';
      case PaymentType.order:
        return 'order';
      case PaymentType.refund:
        return 'refund';
    }
  }

  Exception _handlePaymentDioError(DioException e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      try {
        final errorSource = data.containsKey('error') && data['error'] is Map
            ? Map<String, dynamic>.from(data['error'] as Map)
            : data;
        final errorBody = PaymentErrorBody.fromJson(errorSource);

        return PaymentException(
          code: errorBody.code,
          message: errorBody.userMessage ??
              errorBody.debugMessage ??
              'Payment request failed',
          httpStatus: errorBody.httpStatus,
          debugMessage: errorBody.debugMessage,
          fieldErrors: errorBody.fieldErrors,
        );
      } catch (parseError) {
        // fall through to network style error below
      }
    }

    return PaymentException(
      code: e.type.name,
      message: e.message ?? 'Network error occurred',
      httpStatus: e.response?.statusCode ?? 0,
      debugMessage: e.message,
    );
  }
}

/// Payment specific exception
class PaymentException implements Exception {
  final String code;
  final String message;
  final int httpStatus;
  final String? debugMessage;
  final Map<String, List<FieldViolation>>? fieldErrors;

  const PaymentException({
    required this.code,
    required this.message,
    required this.httpStatus,
    this.debugMessage,
    this.fieldErrors,
  });

  @override
  String toString() =>
      'PaymentException: $message (Code: $code, Status: $httpStatus)';
}





