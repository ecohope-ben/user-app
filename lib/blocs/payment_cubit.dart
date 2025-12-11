import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/endpoints/payment_api.dart';
import '../api/index.dart';
import '../models/payment_models.dart';

/// Base state for payment cubit
abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

/// Initial placeholder state
class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

/// Generic loading state tagged with operation name
class PaymentLoading extends PaymentState {
  final String operation;

  const PaymentLoading(this.operation);

  @override
  List<Object?> get props => [operation];
}

/// Payment list loaded state
class PaymentListLoaded extends PaymentState {
  final List<PaymentListItem> payments;
  final int? totalCount;
  final int? limit;
  final int? offset;

  const PaymentListLoaded({
    required this.payments,
    this.totalCount,
    this.limit,
    this.offset,
  });

  @override
  List<Object?> get props => [payments, totalCount, limit, offset];
}

/// Payment detail loaded state
class PaymentDetailLoaded extends PaymentState {
  final PaymentDetail payment;

  const PaymentDetailLoaded({required this.payment});

  @override
  List<Object?> get props => [payment];
}

/// Error state
class PaymentError extends PaymentState {
  final String message;
  final String? code;
  final int? httpStatus;
  final Map<String, List<FieldViolation>>? fieldErrors;

  const PaymentError({
    required this.message,
    this.code,
    this.httpStatus,
    this.fieldErrors,
  });

  @override
  List<Object?> get props => [message, code, httpStatus, fieldErrors];
}

/// Cubit that manages payment workflows
class PaymentCubit extends Cubit<PaymentState> {
  final PaymentApi _api;

  PaymentCubit({PaymentApi? api})
      : _api = api ?? Api.instance().payment(),
        super(const PaymentInitial());

  /// List payments with optional filters
  Future<void> listPayments({
    PaymentStatus? status,
    PaymentType? type,
    int? limit,
    int? offset,
  }) async {
    emit(const PaymentLoading('list_payments'));
    try {
      final envelope = await _api.listPayments(
        status: status,
        type: type,
        limit: limit,
        offset: offset,
      );
      emit(PaymentListLoaded(
        payments: envelope.data,
        totalCount: envelope.totalCount,
        limit: envelope.limit,
        offset: envelope.offset,
      ));
    } catch (error, t) {
      print('Payment list error: $t');
      _handleError(error);
    }
  }

  /// Load payment detail by payment ID
  Future<void> loadPaymentDetail(String paymentId) async {
    emit(const PaymentLoading('payment_detail'));
    try {
      final envelope = await _api.getPaymentDetail(paymentId: paymentId);
      emit(PaymentDetailLoaded(payment: envelope.data));
    } catch (error, t) {
      print('Payment detail error: $t');
      _handleError(error);
    }
  }

  /// Reset state to initial
  void reset() {
    emit(const PaymentInitial());
  }

  /// Handle errors from API calls
  void _handleError(Object error) {
    if (error is PaymentException) {
      emit(PaymentError(
        message: error.message,
        code: error.code,
        httpStatus: error.httpStatus,
        fieldErrors: error.fieldErrors,
      ));
    } else {
      emit(PaymentError(message: error.toString()));
    }
  }
}

