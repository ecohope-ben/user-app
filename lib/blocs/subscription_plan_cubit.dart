// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../api/endpoints/subscription_api.dart';
// import '../api/index.dart';
// import '../models/subscription_models.dart';
//
// abstract class SubscriptionPlanState extends Equatable {
//   const SubscriptionPlanState();
//
//   @override
//   List<Object?> get props => [];
// }
//
// /// Initial placeholder state
// class SubscriptionPlanInitial extends SubscriptionPlanState {
//   const SubscriptionPlanInitial();
// }
//
// class SubscriptionPlanLoading extends SubscriptionPlanState {
//   final String operation;
//
//   const SubscriptionPlanLoading(this.operation);
//
//   @override
//   List<Object?> get props => [operation];
// }
//
// class SubscriptionPlansLoaded extends SubscriptionPlanState {
//   final List<PlanListItem> plans;
//
//   const SubscriptionPlansLoaded({required this.plans});
//
//   @override
//   List<Object?> get props => [plans];
// }
//
// class SubscriptionPlanDetailLoaded extends SubscriptionPlanState {
//   final PlanDetail plan;
//
//   const SubscriptionPlanDetailLoaded({required this.plan});
//
//   @override
//   List<Object?> get props => [plan];
// }
//
// class SubscriptionPlanError extends SubscriptionPlanState {
//   final String message;
//   final String? code;
//   final int? httpStatus;
//   final Map<String, List<FieldViolation>>? fieldErrors;
//
//   const SubscriptionPlanError({
//     required this.message,
//     this.code,
//     this.httpStatus,
//     this.fieldErrors,
//   });
//
//   @override
//   List<Object?> get props => [message, code, httpStatus, fieldErrors];
// }
//
// /// Cubit that orchestrates subscription workflows
// class SubscriptionPlanCubit extends Cubit<SubscriptionPlanState> {
//   final SubscriptionApi _api;
//
//   SubscriptionPlanCubit({SubscriptionApi? api})
//       : _api = api ?? Api.instance().subscription(),
//         super(const SubscriptionPlanInitial());
//
//
//   Future<void> loadPlans() async {
//     emit(const SubscriptionPlanLoading('plans'));
//     try {
//       final envelope = await _api.listPlans();
//       emit(SubscriptionPlansLoaded(plans: envelope.data));
//     } catch (error) {
//       _handleError(error);
//     }
//   }
//
//   Future<void> loadPlanDetail(String planId) async {
//     emit(const SubscriptionPlanLoading('plan_detail'));
//     try {
//       final plan = await _api.getPlan(planId: planId);
//       emit(SubscriptionPlanDetailLoaded(plan: plan));
//     } catch (error) {
//       _handleError(error);
//     }
//   }
//
//   void _handleError(Object error) {
//     if (error is SubscriptionException) {
//       emit(SubscriptionPlanError(
//         message: error.message,
//         code: error.code,
//         httpStatus: error.httpStatus,
//         fieldErrors: error.fieldErrors,
//       ));
//     } else {
//       emit(SubscriptionPlanError(message: error.toString()));
//     }
//   }
// }
//
