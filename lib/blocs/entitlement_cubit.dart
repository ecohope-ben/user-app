import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/endpoints/entitlement_api.dart';
import '../api/index.dart';
import '../models/entitlement_models.dart';

abstract class EntitlementState extends Equatable {
  const EntitlementState();

  @override
  List<Object?> get props => [];
}

class EntitlementInitial extends EntitlementState {
  const EntitlementInitial();
}

class EntitlementLoading extends EntitlementState {
  const EntitlementLoading();
}

class EntitlementLoaded extends EntitlementState {
  final List<EntitlementListItem> entitlements;

  const EntitlementLoaded({required this.entitlements});

  @override
  List<Object?> get props => [entitlements];
}

class EntitlementError extends EntitlementState {
  final String message;
  final String? code;
  final int? status;

  const EntitlementError({
    required this.message,
    this.code,
    this.status,
  });

  @override
  List<Object?> get props => [message, code, status];
}

class EntitlementCubit extends Cubit<EntitlementState> {
  final EntitlementApi _api;

  EntitlementCubit({EntitlementApi? api})
      : _api = api ?? Api.instance().entitlements(),
        super(const EntitlementInitial());

  Future<void> loadEntitlements() async {
    emit(const EntitlementLoading());
    try {
      final envelope = await _api.listEntitlements();
      emit(EntitlementLoaded(entitlements: envelope.data));
    } catch (error) {
      if (error is EntitlementException) {
        emit(EntitlementError(
          message: error.message,
          code: error.code,
          status: error.httpStatus,
        ));
      } else {
        emit(EntitlementError(message: error.toString()));
      }
    }
  }
}


