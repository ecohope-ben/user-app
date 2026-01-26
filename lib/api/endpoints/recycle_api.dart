import 'package:dio/dio.dart';

import '../../models/recycle_models.dart';
import '../index.dart';

class RecycleApi extends ApiEndpoint {
  RecycleApi(super.api);

  /// Get available pickup dates and timeslots
  Future<AvailablePickupSlotsEnvelope> getPickupSlots() async {
    try {
      final response = await http.get('/recycle/pickup-slots');
      return AvailablePickupSlotsEnvelope.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleRecycleDioError(e);
    }
  }

  Future<RecycleOrderPreflightEnvelope> getRecycleOrderPreflightPickupSlots(String subscriptionId) async {
    try {
      final response = await http.get('/recycle/orders/preflight', queryParameters: {
        "subscription_id": subscriptionId
      });
      return RecycleOrderPreflightEnvelope.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleRecycleDioError(e);
    }
  }


  /// Create a recycle order
  Future<RecycleOrderDetail> createOrder({
    required RecycleOrderCreateRequest request,
  }) async {
    try {
      final response = await http.post(
        '/recycle/orders',
        data: request.toJson(),
      );
      return RecycleOrderDetail.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleRecycleDioError(e);
    }
  }

  Future<RecycleOrderDetail> previewOrder({required RecycleOrderPreviewRequest request}) async {
    try {
      final response = await http.post(
        '/recycle/orders/preview',
        data: request.toJson(),
      );
      return RecycleOrderDetail.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleRecycleDioError(e);
    }
  }

  /// Get recycle order details
  Future<RecycleOrderDetail> getOrderDetail({
    required String recycleOrderId,
  }) async {
    try {
      final response = await http.get(
        '/recycle/orders/$recycleOrderId',
      );
      return RecycleOrderDetail.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleRecycleDioError(e);
    }
  }

  /// List customer recycle orders
  Future<RecycleOrderListEnvelope> listOrders({
    RecycleOrderStatus? status,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (status != null) {
        queryParameters['status'] = _recycleOrderStatusToJsonValue(status);
      }
      if (limit != null) {
        queryParameters['limit'] = limit;
      }
      if (offset != null) {
        queryParameters['offset'] = offset;
      }

      final response = await http.get(
        '/recycle/orders',
        queryParameters: queryParameters.isEmpty ? null : queryParameters,
      );
      return RecycleOrderListEnvelope.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleRecycleDioError(e);
    }
  }

  /// Convert RecycleOrderStatus enum to JSON value string
  String _recycleOrderStatusToJsonValue(RecycleOrderStatus status) {
    switch (status) {
      case RecycleOrderStatus.pending:
        return 'pending';
      case RecycleOrderStatus.processing:
        return 'processing';
      case RecycleOrderStatus.pickedUp:
        return 'picked_up';
      case RecycleOrderStatus.completed:
        return 'completed';
      case RecycleOrderStatus.failed:
        return 'failed';
      case RecycleOrderStatus.cancelled:
        return 'cancelled';
      case RecycleOrderStatus.paymentFailed:
        return 'payment_failed';
      case RecycleOrderStatus.pendingPayment:
        return 'pending_payment';
    }
  }

  Exception _handleRecycleDioError(DioException e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      try {
        final errorSource = data.containsKey('error') && data['error'] is Map
            ? Map<String, dynamic>.from(data['error'] as Map)
            : data;
        final errorBody = RecycleErrorBody.fromJson(errorSource);

        return RecycleException(
          code: errorBody.code,
          message: errorBody.userMessage ??
              errorBody.debugMessage ??
              'Recycle request failed',
          httpStatus: errorBody.httpStatus,
          debugMessage: errorBody.debugMessage,
          fieldErrors: errorBody.fields,
        );
      } catch (parseError) {
        // fall through to network style error below
      }
    }

    return RecycleException(
      code: e.type.name,
      message: e.message ?? 'Network error occurred',
      httpStatus: e.response?.statusCode ?? 0,
      debugMessage: e.message,
    );
  }
}

/// Recycle specific exception
class RecycleException implements Exception {
  final String code;
  final String message;
  final int httpStatus;
  final String? debugMessage;
  final Map<String, List<FieldViolation>>? fieldErrors;

  const RecycleException({
    required this.code,
    required this.message,
    required this.httpStatus,
    this.debugMessage,
    this.fieldErrors,
  });

  @override
  String toString() =>
      'RecycleException: $message (Code: $code, Status: $httpStatus)';
}

