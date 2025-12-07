import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/endpoints/recycle_api.dart';
import '../api/index.dart';
import '../models/recycle_models.dart';

/// Base state for recycle order cubit
abstract class RecycleOrderState extends Equatable {
  const RecycleOrderState();

  @override
  List<Object?> get props => [];
}

/// Initial placeholder state
class RecycleOrderInitial extends RecycleOrderState {
  const RecycleOrderInitial();
}

/// Generic loading state tagged with operation name
class RecycleOrderLoading extends RecycleOrderState {
  final String operation;

  const RecycleOrderLoading(this.operation);

  @override
  List<Object?> get props => [operation];
}

/// Pickup slots loaded state
class PickupSlotsLoaded extends RecycleOrderState {
  final AvailablePickupSlotsData slots;

  const PickupSlotsLoaded({required this.slots});

  @override
  List<Object?> get props => [slots];
}

/// Recycle order list loaded state
class RecycleOrderListLoaded extends RecycleOrderState {
  final List<RecycleOrderListItem> orders;

  const RecycleOrderListLoaded({required this.orders});

  @override
  List<Object?> get props => [orders];
}

/// Recycle order detail loaded state
class RecycleOrderDetailLoaded extends RecycleOrderState {
  final RecycleOrderDetail order;

  const RecycleOrderDetailLoaded({required this.order});

  @override
  List<Object?> get props => [order];
}

/// Recycle order created successfully
class RecycleOrderCreated extends RecycleOrderState {
  final RecycleOrderDetail order;

  const RecycleOrderCreated({required this.order});

  @override
  List<Object?> get props => [order];
}

/// Error state
class RecycleOrderError extends RecycleOrderState {
  final String message;
  final String? code;
  final int? httpStatus;
  final Map<String, List<FieldViolation>>? fieldErrors;

  const RecycleOrderError({
    required this.message,
    this.code,
    this.httpStatus,
    this.fieldErrors,
  });

  @override
  List<Object?> get props => [message, code, httpStatus, fieldErrors];
}

/// Cubit that manages recycle order workflows
class RecycleOrderCubit extends Cubit<RecycleOrderState> {
  final RecycleApi _api;

  RecycleOrderCubit({RecycleApi? api})
      : _api = api ?? Api.instance().recycle(),
        super(const RecycleOrderInitial());

  /// Load available pickup slots
  Future<void> loadPickupSlots() async {
    emit(const RecycleOrderLoading('pickup_slots'));
    try {
      final envelope = await _api.getPickupSlots();
      emit(PickupSlotsLoaded(slots: envelope.data));
    } catch (error) {
      _handleError(error);
    }
  }

  /// Create a recycle order
  Future<void> createOrder(RecycleOrderCreateRequest request) async {
    emit(const RecycleOrderLoading('create_order'));
    try {
      final envelope = await _api.createOrder(request: request);
      emit(RecycleOrderCreated(order: envelope.data));
    } catch (error) {
      _handleError(error);
    }
  }

  /// Load recycle order detail
  Future<void> loadOrderDetail(String recycleOrderId) async {
    emit(const RecycleOrderLoading('order_detail'));
    try {
      final envelope = await _api.getOrderDetail(recycleOrderId: recycleOrderId);
      emit(RecycleOrderDetailLoaded(order: envelope.data));
    } catch (error, t) {
      print(t);
      _handleError(error);
    }
  }

  /// List recycle orders with optional filters
  Future<void> listOrders({
    RecycleOrderStatus? status,
    int? limit,
    int? offset,
  }) async {
    emit(const RecycleOrderLoading('list_orders'));
    try {
      final envelope = await _api.listOrders(
        status: status,
        limit: limit,
        offset: offset,
      );
      emit(RecycleOrderListLoaded(orders: envelope.data));
    } catch (error) {
      _handleError(error);
    }
  }

  /// Reset state to initial
  void reset() {
    emit(const RecycleOrderInitial());
  }

  /// Handle errors from API calls
  void _handleError(Object error) {
    if (error is RecycleException) {
      emit(RecycleOrderError(
        message: error.message,
        code: error.code,
        httpStatus: error.httpStatus,
        fieldErrors: error.fieldErrors,
      ));
    } else {
      emit(RecycleOrderError(message: error.toString()));
    }
  }
}
