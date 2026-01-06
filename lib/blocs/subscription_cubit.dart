import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/endpoints/subscription_api.dart';
import '../api/index.dart';
import '../models/discount/index.dart';
import '../models/subscription_models.dart';

/// Base state for subscription cubit
abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object?> get props => [];
}

/// Initial placeholder state
class SubscriptionInitial extends SubscriptionState {
  const SubscriptionInitial();
}

/// Generic loading state tagged with operation name
class SubscriptionLoading extends SubscriptionState {
  final String operation;

  const SubscriptionLoading(this.operation);

  @override
  List<Object?> get props => [operation];
}


class SubscriptionPlanDetailLoaded extends SubscriptionState {
  final PlanDetail plan;

  const SubscriptionPlanDetailLoaded({required this.plan});

  @override
  List<Object?> get props => [plan];
}

class SubscriptionPreviewReady extends SubscriptionState {
  final PreviewSubscriptionResponse preview;

  const SubscriptionPreviewReady({required this.preview});

  @override
  List<Object?> get props => [preview];
}

class SubscriptionPreviewUnavailable extends SubscriptionState {
  final String message;
  final String? code;
  final int? httpStatus;
  final Map<String, List<FieldViolation>>? fieldErrors;

  const SubscriptionPreviewUnavailable({
    required this.message,
    this.code,
    this.httpStatus,
    this.fieldErrors,
  });

  @override
  List<Object?> get props => [message, code, httpStatus, fieldErrors];
}

class SubscriptionCreationSuccess extends SubscriptionState {
  final CreateSubscriptionResponse response;

  const SubscriptionCreationSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class SubscriptionListLoaded extends SubscriptionState {
  final List<SubscriptionListItem> subscriptions;

  const SubscriptionListLoaded({required this.subscriptions});

  @override
  List<Object?> get props => [subscriptions];
}

class SubscriptionDetailAndListLoaded extends SubscriptionListLoaded {
  final SubscriptionDetail detail;
  const SubscriptionDetailAndListLoaded({required this.detail, required super.subscriptions});

  @override
  List<Object?> get props => [detail];
}

class SubscriptionDetailLoaded extends SubscriptionState {
  final SubscriptionDetail detail;
  const SubscriptionDetailLoaded({required this.detail});

  @override
  List<Object?> get props => [detail];
}

class SubscriptionActivationChecked extends SubscriptionState {
  final ActivateSubscriptionResponse response;

  const SubscriptionActivationChecked({required this.response});

  @override
  List<Object?> get props => [response];
}

class SubscriptionPaymentMethodUpdateRequested extends SubscriptionState {
  final RequestPaymentMethodUpdateResponse request;

  const SubscriptionPaymentMethodUpdateRequested({required this.request});

  @override
  List<Object?> get props => [request];
}

class SubscriptionActionSuccess extends SubscriptionState {
  final String action;

  const SubscriptionActionSuccess({required this.action});

  @override
  List<Object?> get props => [action];
}

class SubscriptionError extends SubscriptionState {
  final String message;
  final String? code;
  final int? httpStatus;
  final Map<String, List<FieldViolation>>? fieldErrors;

  const SubscriptionError({
    required this.message,
    this.code,
    this.httpStatus,
    this.fieldErrors,
  });

  @override
  List<Object?> get props => [message, code, httpStatus, fieldErrors];
}

/// Cubit that orchestrates subscription workflows
class PreviewSubscriptionCubit extends Cubit<SubscriptionState> {
  final SubscriptionApi _api;

  PreviewSubscriptionCubit({SubscriptionApi? api})
      : _api = api ?? Api.instance().subscription(),
        super(const SubscriptionInitial());

  Future<void> previewSubscription() async {
    emit(const SubscriptionLoading('preview'));


    try {
      final preview = await _api.previewSubscription(request: PreviewSubscriptionCreationRequest(
          promotionCode: Discount.instance().promotionCode,
          planId: Discount.instance().planId ?? "",
          planVersionId: Discount.instance().versionId ?? ""
      ));
      Discount.instance().setAmount(preview.amount);
      emit(SubscriptionPreviewReady(preview: preview));
    } catch (error) {
      _handleError(error);
    }
  }

  void _handleError(Object error) {
    if (error is SubscriptionException) {
      emit(SubscriptionPreviewUnavailable(
        message: error.message,
        code: error.code,
        httpStatus: error.httpStatus,
        fieldErrors: error.fieldErrors,
      ));
    } else {
      emit(SubscriptionPreviewUnavailable(message: error.toString()));
    }
  }

}

/// Cubit that orchestrates subscription workflows
class SubscriptionCubit extends Cubit<SubscriptionState> {
  final SubscriptionApi _api;

  SubscriptionCubit({SubscriptionApi? api})
      : _api = api ?? Api.instance().subscription(),
        super(const SubscriptionInitial());


  Future<void> previewSubscription(
      PreviewSubscriptionCreationRequest request) async {
        emit(const SubscriptionLoading('preview'));
        try {
          final preview = await _api.previewSubscription(request: request);
          emit(SubscriptionPreviewReady(preview: preview));
        } catch (error) {
          _handleError(error);
        }
      }

  Future<void> createSubscription(CreateSubscriptionRequest request) async {
    emit(const SubscriptionLoading('create'));
    try {
      final response = await _api.createSubscription(request: request);
      emit(SubscriptionCreationSuccess(response: response));
    } catch (error) {
      _handleError(error);
    }
  }

  Future<void> getCurrentSubscription() async {
    emit(const SubscriptionLoading('subscriptions'));
    try {
      final envelope = await _api.listSubscriptions();
      if (envelope.subscriptions.isNotEmpty) {
        final firstSubscriptionId = envelope.subscriptions.first.id;
        if(envelope.subscriptions.first.lifecycleState == SubscriptionLifecycleState.active) {
          final detail = await _api.getSubscriptionDetail(
              subscriptionId: firstSubscriptionId
          );
          emit(SubscriptionDetailAndListLoaded(detail: detail, subscriptions: envelope.subscriptions));
        }else {
          emit(SubscriptionListLoaded(subscriptions: []));
        }
      }else{
        emit(SubscriptionListLoaded(subscriptions: envelope.subscriptions));
      }

    } catch (error, t) {
      print(t);
      _handleError(error);
    }
  }

  Future<void> loadSubscriptions() async {
    emit(const SubscriptionLoading('subscriptions'));
    try {
      final envelope = await _api.listSubscriptions();
      emit(SubscriptionListLoaded(subscriptions: envelope.subscriptions));
    } catch (error) {
      _handleError(error);
    }
  }

  Future<void> loadSubscriptionDetail(String subscriptionId) async {
    emit(const SubscriptionLoading('subscription_detail'));
    try {
      final detail = await _api.getSubscriptionDetail(
        subscriptionId: subscriptionId
      );
      emit(SubscriptionDetailLoaded(detail: detail));
    } catch (error) {
      _handleError(error);
    }
  }

  Future<void> checkActivation(String subscriptionId) async {
    emit(const SubscriptionLoading('activation'));
    try {
      final response = await _api.checkActivation(
        subscriptionId: subscriptionId
      );
      emit(SubscriptionActivationChecked(response: response));
    } catch (error) {
      _handleError(error);
    }
  }

  Future<void> updateAddress(
    String subscriptionId,
    UpdateAddressRequest request,
  ) async {
    emit(const SubscriptionLoading('update_address'));
    try {
      await _api.updateAddress(
        subscriptionId: subscriptionId,
        request: request,
      );
      emit(const SubscriptionActionSuccess(action: 'update_address'));
    } catch (error) {
      _handleError(error);
    }
  }

  Future<void> schedulePlanChange(
    String subscriptionId,
    SchedulePlanChangeRequest request,
  ) async {
    emit(const SubscriptionLoading('schedule_plan_change'));
    try {
      await _api.schedulePlanChange(
        subscriptionId: subscriptionId,
        request: request,
      );
      emit(
        const SubscriptionActionSuccess(action: 'schedule_plan_change'),
      );
    } catch (error) {
      _handleError(error);
    }
  }

  Future<void> cancelPlanChange(String subscriptionId) async {
    emit(const SubscriptionLoading('cancel_plan_change'));
    try {
      await _api.cancelPlanChange(subscriptionId: subscriptionId);
      emit(
        const SubscriptionActionSuccess(action: 'cancel_plan_change'),
      );
    } catch (error) {
      _handleError(error);
    }
  }

  Future<void> scheduleCancellation(String subscriptionId) async {
    emit(const SubscriptionLoading('schedule_cancellation'));
    try {
      await _api.scheduleCancellation(subscriptionId: subscriptionId);
      emit(
        const SubscriptionActionSuccess(action: 'schedule_cancellation'),
      );
    } catch (error) {
      _handleError(error);
    }
  }

  Future<void> cancelCancellation(String subscriptionId) async {
    emit(const SubscriptionLoading('cancel_cancellation'));
    try {
      await _api.cancelCancellation(subscriptionId: subscriptionId);
      emit(
        const SubscriptionActionSuccess(action: 'cancel_cancellation'),
      );
    } catch (error) {
      _handleError(error);
    }
  }

  Future<void> requestPaymentMethodUpdate(String subscriptionId) async {
    emit(const SubscriptionLoading('request_payment_method_update'));
    try {
      final response = await _api.requestPaymentMethodUpdate(
        subscriptionId: subscriptionId,
      );
      emit(
        SubscriptionPaymentMethodUpdateRequested(request: response),
      );
    } catch (error) {
      _handleError(error);
    }
  }

  Future<void> completePaymentMethodUpdate(
    String subscriptionId,
    CompletePaymentMethodUpdateRequest request,
  ) async {
    emit(const SubscriptionLoading('complete_payment_method_update'));
    try {
      await _api.completePaymentMethodUpdate(
        subscriptionId: subscriptionId,
        request: request,
      );
      emit(
        const SubscriptionActionSuccess(
            action: 'complete_payment_method_update'),
      );
    } catch (error) {
      _handleError(error);
    }
  }

  void reset() {
    emit(const SubscriptionInitial());
  }

  void _handleError(Object error) {
    if (error is SubscriptionException) {
      emit(SubscriptionError(
        message: error.message,
        code: error.code,
        httpStatus: error.httpStatus,
        fieldErrors: error.fieldErrors,
      ));
    } else {
      emit(SubscriptionError(message: error.toString()));
    }
  }
}

