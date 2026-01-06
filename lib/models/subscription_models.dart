import 'package:json_annotation/json_annotation.dart';

part 'subscription_models.g.dart';

/// Billing frequency for subscription plans
enum BillingCycle {
  @JsonValue('monthly')
  monthly,
  @JsonValue('yearly')
  yearly,
  @JsonValue('quarterly')
  quarterly,
}

/// Current lifecycle state for a subscription
enum SubscriptionLifecycleState {
  @JsonValue('initializing')
  initializing,
  @JsonValue('initialization_failed')
  initializationFailed,
  @JsonValue('pending_activation')
  pendingActivation,
  @JsonValue('active')
  active,
  @JsonValue('past_due')
  pastDue,
  @JsonValue('renewal_failed')
  renewalFailed,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('activation_failed')
  activationFailed,
}

/// Discount type definition
enum DiscountType {
  @JsonValue('percentage')
  percentage,
  @JsonValue('fixed_amount')
  fixedAmount,
  @JsonValue('free_cycles')
  freeCycles,
}

/// Discount information for plans
@JsonSerializable()
class PromotionCode {

  final String code;
  final String name;
  final String description;
  @JsonKey(name: 'discount_type')
  final DiscountType discountType;
  @JsonKey(name: 'discount_value')
  final int discountValue;
  @JsonKey(name: 'ended_at')
  final DateTime? endedAt;

  const PromotionCode({
    required this.code,
    required this.name,
    required this.description,
    required this.discountType,
    required this.discountValue,
    this.endedAt,
  });

  factory PromotionCode.fromJson(Map<String, dynamic> json) =>
      _$PromotionCodeFromJson(json);

  Map<String, dynamic> toJson() => _$PromotionCodeToJson(this);
}

/// Plan list item for subscription plan list
@JsonSerializable(explicitToJson: true)
class PlanListItem {
  final String id;
  @JsonKey(name: 'version_id')
  final String versionId;
  @JsonKey(name: 'family_id')
  final String familyId;
  final String name;
  final String description;
  @JsonKey(name: 'billing_cycle')
  final BillingCycle billingCycle;
  final int price;
  @JsonKey(name: 'price_decimal')
  final String priceDecimal;
  final String currency;

  const PlanListItem({
    required this.id,
    required this.versionId,
    required this.familyId,
    required this.name,
    required this.description,
    required this.billingCycle,
    required this.price,
    required this.priceDecimal,
    required this.currency
  });

  factory PlanListItem.fromJson(Map<String, dynamic> json) =>
      _$PlanListItemFromJson(json);

  Map<String, dynamic> toJson() => _$PlanListItemToJson(this);
}

/// Detailed plan model
@JsonSerializable(explicitToJson: true)
class PlanDetail {
  final String id;
  @JsonKey(name: 'version_id')
  final String versionId;
  @JsonKey(name: 'family_id')
  final String familyId;
  final String name;
  final String description;
  @JsonKey(name: 'billing_cycle')
  final BillingCycle billingCycle;
  final int price;
  @JsonKey(name: 'price_decimal')
  final String priceDecimal;
  final String currency;

  const PlanDetail({
    required this.id,
    required this.versionId,
    required this.familyId,
    required this.name,
    required this.description,
    required this.billingCycle,
    required this.price,
    required this.priceDecimal,
    required this.currency
  });

  factory PlanDetail.fromJson(Map<String, dynamic> json) =>
      _$PlanDetailFromJson(json);

  Map<String, dynamic> toJson() => _$PlanDetailToJson(this);
}

/// Envelope containing plan list response
@JsonSerializable(explicitToJson: true)
class PlanListEnvelope {
  final List<PlanListItem> data;

  const PlanListEnvelope({required this.data});

  factory PlanListEnvelope.fromJson(Map<String, dynamic> json) =>
      _$PlanListEnvelopeFromJson(json);

  Map<String, dynamic> toJson() => _$PlanListEnvelopeToJson(this);
}

/// Delivery address details
@JsonSerializable()
class DeliveryAddress {
  @JsonKey(name: 'district_id')
  final String districtId;
  @JsonKey(name: 'sub_district_id')
  final String subDistrictId;
  final String address;

  @JsonKey(name: 'district_name')
  final String? districtName;

  @JsonKey(name: 'sub_district_name')
  final String? subDistrictName;

  @JsonKey(name: 'full_address')
  final String? fullAddress;

  const DeliveryAddress({
    required this.districtId,
    required this.subDistrictId,
    required this.address,
    required this.fullAddress,
    required this.districtName,
    required this.subDistrictName
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) =>
      _$DeliveryAddressFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryAddressToJson(this);
}

/// Embedded plan information for subscriptions
@JsonSerializable()
class SubscriptionPlanInfo {
  final String id;
  @JsonKey(name: 'family_id')
  final String familyId;
  @JsonKey(name: 'version_id')
  final String versionId;
  final String name;
  final String description;
  @JsonKey(name: 'billing_cycle')
  final BillingCycle billingCycle;
  final int price;
  @JsonKey(name: 'price_decimal')
  final String priceDecimal;
  final String currency;

  const SubscriptionPlanInfo({
    required this.id,
    required this.familyId,
    required this.versionId,
    required this.name,
    required this.description,
    required this.billingCycle,
    required this.price,
    required this.priceDecimal,
    required this.currency,
  });

  factory SubscriptionPlanInfo.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionPlanInfoFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionPlanInfoToJson(this);
}

/// Payment method information
@JsonSerializable()
class PaymentMethod {
  final String brand;
  @JsonKey(name: 'exp_month')
  final int expMonth;
  @JsonKey(name: 'exp_year')
  final int expYear;
  final String last4;

  const PaymentMethod({
    required this.brand,
    required this.expMonth,
    required this.expYear,
    required this.last4,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);
}

/// Scheduled cancellation details
@JsonSerializable()
class ScheduledCancellation {
  @JsonKey(name: 'cancel_at')
  final DateTime cancelAt;

  const ScheduledCancellation({required this.cancelAt});

  factory ScheduledCancellation.fromJson(Map<String, dynamic> json) =>
      _$ScheduledCancellationFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduledCancellationToJson(this);
}

/// Scheduled plan change information
@JsonSerializable(explicitToJson: true)
class ScheduledPlanChange {
  final SubscriptionPlanInfo plan;

  const ScheduledPlanChange({required this.plan});

  factory ScheduledPlanChange.fromJson(Map<String, dynamic> json) =>
      _$ScheduledPlanChangeFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduledPlanChangeToJson(this);
}

/// Discount applied to a subscription
@JsonSerializable()
class SubscriptionDiscount {
  final String id;
  final String name;
  final String description;
  @JsonKey(name: 'discount_type')
  final DiscountType discountType;
  @JsonKey(name: 'discount_value')
  final int discountValue;

  const SubscriptionDiscount({
    required this.id,
    required this.name,
    required this.description,
    required this.discountType,
    required this.discountValue,
  });

  factory SubscriptionDiscount.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionDiscountFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionDiscountToJson(this);
}

/// Recycling profile information for subscription
@JsonSerializable()
class RecyclingProfile {
  final String type;
  @JsonKey(name: 'initial_bag_status')
  final String initialBagStatus;
  @JsonKey(name: 'initial_bag_delivery_tracking_no')
  final String? initialBagDeliveryTrackingNo;

  const RecyclingProfile({
    required this.type,
    required this.initialBagStatus,
    required this.initialBagDeliveryTrackingNo,
  });

  factory RecyclingProfile.fromJson(Map<String, dynamic> json) =>
      _$RecyclingProfileFromJson(json);

  Map<String, dynamic> toJson() => _$RecyclingProfileToJson(this);
}

/// Plan info shown in subscription list (without pricing)
@JsonSerializable()
class SubscriptionPlanListInfo {
  final String id;
  @JsonKey(name: 'family_id')
  final String familyId;
  @JsonKey(name: 'version_id')
  final String versionId;
  final String name;
  final String description;
  @JsonKey(name: 'billing_cycle')
  final BillingCycle billingCycle;

  const SubscriptionPlanListInfo({
    required this.id,
    required this.familyId,
    required this.versionId,
    required this.name,
    required this.description,
    required this.billingCycle,
  });

  factory SubscriptionPlanListInfo.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionPlanListInfoFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionPlanListInfoToJson(this);
}

/// Subscription item for list endpoint
@JsonSerializable(explicitToJson: true)
class SubscriptionListItem {
  final String id;
  final SubscriptionPlanListInfo plan;
  @JsonKey(name: 'delivery_address')
  final DeliveryAddress deliveryAddress;
  @JsonKey(name: 'lifecycle_state')
  final SubscriptionLifecycleState lifecycleState;
  @JsonKey(name: 'current_period_start')
  final DateTime? currentPeriodStart;
  @JsonKey(name: 'current_period_end')
  final DateTime? currentPeriodEnd;
  @JsonKey(name: 'start_date')
  final DateTime? startDate;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  const SubscriptionListItem({
    required this.id,
    required this.plan,
    required this.deliveryAddress,
    required this.lifecycleState,
    required this.currentPeriodStart,
    required this.currentPeriodEnd,
    required this.startDate,
    required this.createdAt,
  });

  factory SubscriptionListItem.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionListItemFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionListItemToJson(this);
}

/// Detailed subscription response
@JsonSerializable(explicitToJson: true)
class SubscriptionDetail {
  final String id;
  final SubscriptionPlanInfo plan;
  @JsonKey(name: 'delivery_address')
  final DeliveryAddress deliveryAddress;
  @JsonKey(name: 'lifecycle_state')
  final SubscriptionLifecycleState lifecycleState;
  @JsonKey(name: 'current_period_start')
  final DateTime? currentPeriodStart;
  @JsonKey(name: 'current_period_end')
  final DateTime? currentPeriodEnd;
  @JsonKey(name: 'start_date')
  final DateTime? startDate;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'default_payment_method')
  final PaymentMethod? defaultPaymentMethod;
  @JsonKey(name: 'scheduled_cancellation')
  final ScheduledCancellation? scheduledCancellation;
  @JsonKey(name: 'scheduled_plan_change')
  final ScheduledPlanChange? scheduledPlanChange;
  final SubscriptionDiscount? discount;
  @JsonKey(name: 'recycling_profile')
  final RecyclingProfile? recyclingProfile;

  const SubscriptionDetail({
    required this.id,
    required this.plan,
    required this.deliveryAddress,
    required this.lifecycleState,
    required this.currentPeriodStart,
    required this.currentPeriodEnd,
    required this.startDate,
    required this.createdAt,
    required this.defaultPaymentMethod,
    required this.scheduledCancellation,
    required this.scheduledPlanChange,
    required this.discount,
    this.recyclingProfile,
  });

  factory SubscriptionDetail.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionDetailFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionDetailToJson(this);
}

/// Envelope for subscription list response
@JsonSerializable(explicitToJson: true)
class SubscriptionListEnvelope {
  final List<SubscriptionListItem> subscriptions;

  const SubscriptionListEnvelope({required this.subscriptions});

  factory SubscriptionListEnvelope.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionListEnvelopeFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionListEnvelopeToJson(this);
}

/// Preview subscription creation request payload
@JsonSerializable()
class PreviewSubscriptionCreationRequest {
  @JsonKey(name: 'plan_id')
  final String planId;
  @JsonKey(name: 'plan_version_id')
  final String planVersionId;
  // @JsonKey(name: 'district_id')
  // final String districtId;
  // @JsonKey(name: 'sub_district_id')
  // final String subDistrictId;
  // final String address;
  @JsonKey(name: 'promotion_code')
  final String? promotionCode;

  const PreviewSubscriptionCreationRequest({
    required this.planId,
    required this.planVersionId,
    this.promotionCode,
  });

  factory PreviewSubscriptionCreationRequest.fromJson(
          Map<String, dynamic> json) =>
      _$PreviewSubscriptionCreationRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PreviewSubscriptionCreationRequestToJson(this);
}

/// Response for subscription preview
@JsonSerializable()
class PreviewSubscriptionResponse {
  final int amount;
  final String currency;
  @JsonKey(name: 'require_payment')
  final bool requirePayment;

  @JsonKey(name: 'period_start')
  final DateTime periodStart;

  @JsonKey(name: 'period_end')
  final DateTime periodEnd;

  @JsonKey(name: 'promotion_code')
  final PromotionCode? promotionCode;

  const PreviewSubscriptionResponse({
    required this.amount,
    required this.currency,
    required this.requirePayment,
    required this.periodStart,
    required this.periodEnd,
    this.promotionCode
  });

  factory PreviewSubscriptionResponse.fromJson(Map<String, dynamic> json) =>
      _$PreviewSubscriptionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PreviewSubscriptionResponseToJson(this);
}

/// Create subscription request payload
@JsonSerializable()
class CreateSubscriptionRequest {
  @JsonKey(name: 'plan_id')
  final String planId;
  @JsonKey(name: 'plan_version_id')
  final String planVersionId;
  @JsonKey(name: 'district_id')
  final String districtId;
  @JsonKey(name: 'sub_district_id')
  final String subDistrictId;
  final String address;
  @JsonKey(name: 'discount_id')
  final String? discountId;
  final int amount;
  final String currency;

  @JsonKey(name: 'promotion_code')
  final String? promotionCode;

  const CreateSubscriptionRequest({
    required this.planId,
    required this.planVersionId,
    required this.districtId,
    required this.subDistrictId,
    required this.address,
    this.discountId,
    required this.amount,
    required this.currency,
    this.promotionCode
  });

  factory CreateSubscriptionRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateSubscriptionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateSubscriptionRequestToJson(this);
}
enum PaymentNextAction {
  @JsonValue('pay')
  pay,
  @JsonValue('setup')
  setup,
}
/// Response after creating subscription
@JsonSerializable()
class CreateSubscriptionResponse {
  @JsonKey(name: 'subscription_id')
  final String subscriptionId;
  @JsonKey(name: 'client_secret')
  final String clientSecret;
  @JsonKey(name: 'next_action')
  final PaymentNextAction nextAction;

  const CreateSubscriptionResponse({
    required this.subscriptionId,
    required this.clientSecret,
    required this.nextAction,
  });

  factory CreateSubscriptionResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateSubscriptionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateSubscriptionResponseToJson(this);
}

enum ActivateSubscriptionResult{
  @JsonValue('activated')
  activated,
  @JsonValue('pending')
  pending,
  @JsonValue('failed')
  failed
}

/// Activate subscription response
@JsonSerializable()
class ActivateSubscriptionResponse {
  @JsonKey(name: 'subscription_id')
  final String subscriptionId;
  final ActivateSubscriptionResult result;

  const ActivateSubscriptionResponse({
    required this.subscriptionId,
    required this.result,
  });

  factory ActivateSubscriptionResponse.fromJson(Map<String, dynamic> json) =>
      _$ActivateSubscriptionResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ActivateSubscriptionResponseToJson(this);
}

/// Update address request payload
@JsonSerializable()
class UpdateAddressRequest {
  @JsonKey(name: 'district_id')
  final String districtId;
  @JsonKey(name: 'sub_district_id')
  final String subDistrictId;
  final String address;

  const UpdateAddressRequest({
    required this.districtId,
    required this.subDistrictId,
    required this.address,
  });

  factory UpdateAddressRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateAddressRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateAddressRequestToJson(this);
}

/// Schedule plan change request payload
@JsonSerializable()
class SchedulePlanChangeRequest {
  @JsonKey(name: 'new_plan_version_id')
  final String newPlanVersionId;

  const SchedulePlanChangeRequest({required this.newPlanVersionId});

  factory SchedulePlanChangeRequest.fromJson(Map<String, dynamic> json) =>
      _$SchedulePlanChangeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SchedulePlanChangeRequestToJson(this);
}

/// Request payment method update response
@JsonSerializable()
class RequestPaymentMethodUpdateResponse {
  @JsonKey(name: 'setup_intent_id')
  final String setupIntentId;
  @JsonKey(name: 'setup_intent_client_secret')
  final String setupIntentClientSecret;

  const RequestPaymentMethodUpdateResponse({
    required this.setupIntentId,
    required this.setupIntentClientSecret,
  });

  factory RequestPaymentMethodUpdateResponse.fromJson(
          Map<String, dynamic> json) =>
      _$RequestPaymentMethodUpdateResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$RequestPaymentMethodUpdateResponseToJson(this);
}

/// Complete payment method update request
@JsonSerializable()
class CompletePaymentMethodUpdateRequest {
  @JsonKey(name: 'setup_intent_id')
  final String setupIntentId;

  const CompletePaymentMethodUpdateRequest({required this.setupIntentId});

  factory CompletePaymentMethodUpdateRequest.fromJson(
          Map<String, dynamic> json) =>
      _$CompletePaymentMethodUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CompletePaymentMethodUpdateRequestToJson(this);
}

/// Subscription error response body
@JsonSerializable(explicitToJson: true)
class SubscriptionErrorBody {
  final String code;
  @JsonKey(name: 'http_status')
  final int httpStatus;
  @JsonKey(name: 'user_message')
  final String? userMessage;
  @JsonKey(name: 'debug_message')
  final String? debugMessage;
  @JsonKey(name: 'fieldErrors')
  final Map<String, List<FieldViolation>>? fieldErrors;

  const SubscriptionErrorBody({
    required this.code,
    required this.httpStatus,
    this.userMessage,
    this.debugMessage,
    this.fieldErrors,
  });

  factory SubscriptionErrorBody.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionErrorBodyFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionErrorBodyToJson(this);
}

/// Field-level violation structure
@JsonSerializable()
class FieldViolation {
  final String code;
  final String message;

  const FieldViolation({
    required this.code,
    required this.message,
  });

  factory FieldViolation.fromJson(Map<String, dynamic> json) =>
      _$FieldViolationFromJson(json);

  Map<String, dynamic> toJson() => _$FieldViolationToJson(this);
}

