// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanDiscount _$PlanDiscountFromJson(Map<String, dynamic> json) => PlanDiscount(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  discountType: $enumDecode(_$DiscountTypeEnumMap, json['discount_type']),
  discountValue: (json['discount_value'] as num).toInt(),
  endedAt: json['ended_at'] == null
      ? null
      : DateTime.parse(json['ended_at'] as String),
);

Map<String, dynamic> _$PlanDiscountToJson(PlanDiscount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'discount_type': _$DiscountTypeEnumMap[instance.discountType]!,
      'discount_value': instance.discountValue,
      'ended_at': instance.endedAt?.toIso8601String(),
    };

const _$DiscountTypeEnumMap = {
  DiscountType.percentage: 'percentage',
  DiscountType.fixedAmount: 'fixed_amount',
  DiscountType.freeCycles: 'free_cycles',
};

PlanListItem _$PlanListItemFromJson(Map<String, dynamic> json) => PlanListItem(
  id: json['id'] as String,
  versionId: json['version_id'] as String,
  familyId: json['family_id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  billingCycle: $enumDecode(_$BillingCycleEnumMap, json['billing_cycle']),
  price: (json['price'] as num).toInt(),
  priceDecimal: json['price_decimal'] as String,
  currency: json['currency'] as String,
  discount: json['discount'] == null
      ? null
      : PlanDiscount.fromJson(json['discount'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PlanListItemToJson(PlanListItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'version_id': instance.versionId,
      'family_id': instance.familyId,
      'name': instance.name,
      'description': instance.description,
      'billing_cycle': _$BillingCycleEnumMap[instance.billingCycle]!,
      'price': instance.price,
      'price_decimal': instance.priceDecimal,
      'currency': instance.currency,
      'discount': instance.discount?.toJson(),
    };

const _$BillingCycleEnumMap = {
  BillingCycle.monthly: 'monthly',
  BillingCycle.yearly: 'yearly',
};

PlanDetail _$PlanDetailFromJson(Map<String, dynamic> json) => PlanDetail(
  id: json['id'] as String,
  versionId: json['version_id'] as String,
  familyId: json['family_id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  billingCycle: $enumDecode(_$BillingCycleEnumMap, json['billing_cycle']),
  price: (json['price'] as num).toInt(),
  priceDecimal: json['price_decimal'] as String,
  currency: json['currency'] as String,
  discount: json['discount'] == null
      ? null
      : PlanDiscount.fromJson(json['discount'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PlanDetailToJson(PlanDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'version_id': instance.versionId,
      'family_id': instance.familyId,
      'name': instance.name,
      'description': instance.description,
      'billing_cycle': _$BillingCycleEnumMap[instance.billingCycle]!,
      'price': instance.price,
      'price_decimal': instance.priceDecimal,
      'currency': instance.currency,
      'discount': instance.discount?.toJson(),
    };

PlanListEnvelope _$PlanListEnvelopeFromJson(Map<String, dynamic> json) =>
    PlanListEnvelope(
      data: (json['data'] as List<dynamic>)
          .map((e) => PlanListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PlanListEnvelopeToJson(PlanListEnvelope instance) =>
    <String, dynamic>{'data': instance.data.map((e) => e.toJson()).toList()};

DeliveryAddress _$DeliveryAddressFromJson(Map<String, dynamic> json) =>
    DeliveryAddress(
      districtId: json['district_id'] as String,
      subDistrictId: json['sub_district_id'] as String,
      address: json['address'] as String,
      fullAddress: json['full_address'] as String?,
      districtName: json['district_name'] as String?,
      subDistrictName: json['sub_district_name'] as String?,
    );

Map<String, dynamic> _$DeliveryAddressToJson(DeliveryAddress instance) =>
    <String, dynamic>{
      'district_id': instance.districtId,
      'sub_district_id': instance.subDistrictId,
      'address': instance.address,
      'district_name': instance.districtName,
      'sub_district_name': instance.subDistrictName,
      'full_address': instance.fullAddress,
    };

SubscriptionPlanInfo _$SubscriptionPlanInfoFromJson(
  Map<String, dynamic> json,
) => SubscriptionPlanInfo(
  id: json['id'] as String,
  familyId: json['family_id'] as String,
  versionId: json['version_id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  billingCycle: $enumDecode(_$BillingCycleEnumMap, json['billing_cycle']),
  price: (json['price'] as num).toInt(),
  priceDecimal: json['price_decimal'] as String,
  currency: json['currency'] as String,
);

Map<String, dynamic> _$SubscriptionPlanInfoToJson(
  SubscriptionPlanInfo instance,
) => <String, dynamic>{
  'id': instance.id,
  'family_id': instance.familyId,
  'version_id': instance.versionId,
  'name': instance.name,
  'description': instance.description,
  'billing_cycle': _$BillingCycleEnumMap[instance.billingCycle]!,
  'price': instance.price,
  'price_decimal': instance.priceDecimal,
  'currency': instance.currency,
};

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) =>
    PaymentMethod(
      brand: json['brand'] as String,
      expMonth: (json['exp_month'] as num).toInt(),
      expYear: (json['exp_year'] as num).toInt(),
      last4: json['last4'] as String,
    );

Map<String, dynamic> _$PaymentMethodToJson(PaymentMethod instance) =>
    <String, dynamic>{
      'brand': instance.brand,
      'exp_month': instance.expMonth,
      'exp_year': instance.expYear,
      'last4': instance.last4,
    };

ScheduledCancellation _$ScheduledCancellationFromJson(
  Map<String, dynamic> json,
) => ScheduledCancellation(
  cancelAt: DateTime.parse(json['cancel_at'] as String),
);

Map<String, dynamic> _$ScheduledCancellationToJson(
  ScheduledCancellation instance,
) => <String, dynamic>{'cancel_at': instance.cancelAt.toIso8601String()};

ScheduledPlanChange _$ScheduledPlanChangeFromJson(Map<String, dynamic> json) =>
    ScheduledPlanChange(
      plan: SubscriptionPlanInfo.fromJson(json['plan'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ScheduledPlanChangeToJson(
  ScheduledPlanChange instance,
) => <String, dynamic>{'plan': instance.plan.toJson()};

SubscriptionDiscount _$SubscriptionDiscountFromJson(
  Map<String, dynamic> json,
) => SubscriptionDiscount(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  discountType: $enumDecode(_$DiscountTypeEnumMap, json['discount_type']),
  discountValue: (json['discount_value'] as num).toInt(),
);

Map<String, dynamic> _$SubscriptionDiscountToJson(
  SubscriptionDiscount instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'discount_type': _$DiscountTypeEnumMap[instance.discountType]!,
  'discount_value': instance.discountValue,
};

RecyclingProfile _$RecyclingProfileFromJson(Map<String, dynamic> json) =>
    RecyclingProfile(
      type: json['type'] as String,
      initialBagStatus: json['initial_bag_status'] as String,
      initialBagDeliveryTrackingNo:
          json['initial_bag_delivery_tracking_no'] as String?,
    );

Map<String, dynamic> _$RecyclingProfileToJson(RecyclingProfile instance) =>
    <String, dynamic>{
      'type': instance.type,
      'initial_bag_status': instance.initialBagStatus,
      'initial_bag_delivery_tracking_no': instance.initialBagDeliveryTrackingNo,
    };

SubscriptionPlanListInfo _$SubscriptionPlanListInfoFromJson(
  Map<String, dynamic> json,
) => SubscriptionPlanListInfo(
  id: json['id'] as String,
  familyId: json['family_id'] as String,
  versionId: json['version_id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  billingCycle: $enumDecode(_$BillingCycleEnumMap, json['billing_cycle']),
);

Map<String, dynamic> _$SubscriptionPlanListInfoToJson(
  SubscriptionPlanListInfo instance,
) => <String, dynamic>{
  'id': instance.id,
  'family_id': instance.familyId,
  'version_id': instance.versionId,
  'name': instance.name,
  'description': instance.description,
  'billing_cycle': _$BillingCycleEnumMap[instance.billingCycle]!,
};

SubscriptionListItem _$SubscriptionListItemFromJson(
  Map<String, dynamic> json,
) => SubscriptionListItem(
  id: json['id'] as String,
  plan: SubscriptionPlanListInfo.fromJson(json['plan'] as Map<String, dynamic>),
  deliveryAddress: DeliveryAddress.fromJson(
    json['delivery_address'] as Map<String, dynamic>,
  ),
  lifecycleState: $enumDecode(
    _$SubscriptionLifecycleStateEnumMap,
    json['lifecycle_state'],
  ),
  currentPeriodStart: json['current_period_start'] == null
      ? null
      : DateTime.parse(json['current_period_start'] as String),
  currentPeriodEnd: json['current_period_end'] == null
      ? null
      : DateTime.parse(json['current_period_end'] as String),
  startDate: json['start_date'] == null
      ? null
      : DateTime.parse(json['start_date'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$SubscriptionListItemToJson(
  SubscriptionListItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'plan': instance.plan.toJson(),
  'delivery_address': instance.deliveryAddress.toJson(),
  'lifecycle_state':
      _$SubscriptionLifecycleStateEnumMap[instance.lifecycleState]!,
  'current_period_start': instance.currentPeriodStart?.toIso8601String(),
  'current_period_end': instance.currentPeriodEnd?.toIso8601String(),
  'start_date': instance.startDate?.toIso8601String(),
  'created_at': instance.createdAt.toIso8601String(),
};

const _$SubscriptionLifecycleStateEnumMap = {
  SubscriptionLifecycleState.initializing: 'initializing',
  SubscriptionLifecycleState.initializationFailed: 'initialization_failed',
  SubscriptionLifecycleState.pendingActivation: 'pending_activation',
  SubscriptionLifecycleState.active: 'active',
  SubscriptionLifecycleState.pastDue: 'past_due',
  SubscriptionLifecycleState.renewalFailed: 'renewal_failed',
  SubscriptionLifecycleState.cancelled: 'cancelled',
  SubscriptionLifecycleState.activationFailed: 'activation_failed',
};

SubscriptionDetail _$SubscriptionDetailFromJson(Map<String, dynamic> json) =>
    SubscriptionDetail(
      id: json['id'] as String,
      plan: SubscriptionPlanInfo.fromJson(json['plan'] as Map<String, dynamic>),
      deliveryAddress: DeliveryAddress.fromJson(
        json['delivery_address'] as Map<String, dynamic>,
      ),
      lifecycleState: $enumDecode(
        _$SubscriptionLifecycleStateEnumMap,
        json['lifecycle_state'],
      ),
      currentPeriodStart: json['current_period_start'] == null
          ? null
          : DateTime.parse(json['current_period_start'] as String),
      currentPeriodEnd: json['current_period_end'] == null
          ? null
          : DateTime.parse(json['current_period_end'] as String),
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      defaultPaymentMethod: json['default_payment_method'] == null
          ? null
          : PaymentMethod.fromJson(
              json['default_payment_method'] as Map<String, dynamic>,
            ),
      scheduledCancellation: json['scheduled_cancellation'] == null
          ? null
          : ScheduledCancellation.fromJson(
              json['scheduled_cancellation'] as Map<String, dynamic>,
            ),
      scheduledPlanChange: json['scheduled_plan_change'] == null
          ? null
          : ScheduledPlanChange.fromJson(
              json['scheduled_plan_change'] as Map<String, dynamic>,
            ),
      discount: json['discount'] == null
          ? null
          : SubscriptionDiscount.fromJson(
              json['discount'] as Map<String, dynamic>,
            ),
      recyclingProfile: json['recycling_profile'] == null
          ? null
          : RecyclingProfile.fromJson(
              json['recycling_profile'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$SubscriptionDetailToJson(SubscriptionDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'plan': instance.plan.toJson(),
      'delivery_address': instance.deliveryAddress.toJson(),
      'lifecycle_state':
          _$SubscriptionLifecycleStateEnumMap[instance.lifecycleState]!,
      'current_period_start': instance.currentPeriodStart?.toIso8601String(),
      'current_period_end': instance.currentPeriodEnd?.toIso8601String(),
      'start_date': instance.startDate?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'default_payment_method': instance.defaultPaymentMethod?.toJson(),
      'scheduled_cancellation': instance.scheduledCancellation?.toJson(),
      'scheduled_plan_change': instance.scheduledPlanChange?.toJson(),
      'discount': instance.discount?.toJson(),
      'recycling_profile': instance.recyclingProfile?.toJson(),
    };

SubscriptionListEnvelope _$SubscriptionListEnvelopeFromJson(
  Map<String, dynamic> json,
) => SubscriptionListEnvelope(
  subscriptions: (json['subscriptions'] as List<dynamic>)
      .map((e) => SubscriptionListItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SubscriptionListEnvelopeToJson(
  SubscriptionListEnvelope instance,
) => <String, dynamic>{
  'subscriptions': instance.subscriptions.map((e) => e.toJson()).toList(),
};

PreviewSubscriptionCreationRequest _$PreviewSubscriptionCreationRequestFromJson(
  Map<String, dynamic> json,
) => PreviewSubscriptionCreationRequest(
  planId: json['plan_id'] as String,
  planVersionId: json['plan_version_id'] as String,
  discountId: json['discount_id'] as String?,
);

Map<String, dynamic> _$PreviewSubscriptionCreationRequestToJson(
  PreviewSubscriptionCreationRequest instance,
) => <String, dynamic>{
  'plan_id': instance.planId,
  'plan_version_id': instance.planVersionId,
  'discount_id': instance.discountId,
};

PreviewSubscriptionResponse _$PreviewSubscriptionResponseFromJson(
  Map<String, dynamic> json,
) => PreviewSubscriptionResponse(
  amount: (json['amount'] as num).toInt(),
  currency: json['currency'] as String,
  requirePayment: json['require_payment'] as bool,
  periodStart: DateTime.parse(json['period_start'] as String),
  periodEnd: DateTime.parse(json['period_end'] as String),
);

Map<String, dynamic> _$PreviewSubscriptionResponseToJson(
  PreviewSubscriptionResponse instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'currency': instance.currency,
  'require_payment': instance.requirePayment,
  'period_start': instance.periodStart.toIso8601String(),
  'period_end': instance.periodEnd.toIso8601String(),
};

CreateSubscriptionRequest _$CreateSubscriptionRequestFromJson(
  Map<String, dynamic> json,
) => CreateSubscriptionRequest(
  planId: json['plan_id'] as String,
  planVersionId: json['plan_version_id'] as String,
  districtId: json['district_id'] as String,
  subDistrictId: json['sub_district_id'] as String,
  address: json['address'] as String,
  discountId: json['discount_id'] as String?,
  amount: (json['amount'] as num).toInt(),
  currency: json['currency'] as String,
);

Map<String, dynamic> _$CreateSubscriptionRequestToJson(
  CreateSubscriptionRequest instance,
) => <String, dynamic>{
  'plan_id': instance.planId,
  'plan_version_id': instance.planVersionId,
  'district_id': instance.districtId,
  'sub_district_id': instance.subDistrictId,
  'address': instance.address,
  'discount_id': instance.discountId,
  'amount': instance.amount,
  'currency': instance.currency,
};

CreateSubscriptionResponse _$CreateSubscriptionResponseFromJson(
  Map<String, dynamic> json,
) => CreateSubscriptionResponse(
  subscriptionId: json['subscription_id'] as String,
  clientSecret: json['client_secret'] as String,
  nextAction: $enumDecode(_$PaymentNextActionEnumMap, json['next_action']),
);

Map<String, dynamic> _$CreateSubscriptionResponseToJson(
  CreateSubscriptionResponse instance,
) => <String, dynamic>{
  'subscription_id': instance.subscriptionId,
  'client_secret': instance.clientSecret,
  'next_action': _$PaymentNextActionEnumMap[instance.nextAction]!,
};

const _$PaymentNextActionEnumMap = {
  PaymentNextAction.pay: 'pay',
  PaymentNextAction.setup: 'setup',
};

ActivateSubscriptionResponse _$ActivateSubscriptionResponseFromJson(
  Map<String, dynamic> json,
) => ActivateSubscriptionResponse(
  subscriptionId: json['subscription_id'] as String,
  result: $enumDecode(_$ActivateSubscriptionResultEnumMap, json['result']),
);

Map<String, dynamic> _$ActivateSubscriptionResponseToJson(
  ActivateSubscriptionResponse instance,
) => <String, dynamic>{
  'subscription_id': instance.subscriptionId,
  'result': _$ActivateSubscriptionResultEnumMap[instance.result]!,
};

const _$ActivateSubscriptionResultEnumMap = {
  ActivateSubscriptionResult.activated: 'activated',
  ActivateSubscriptionResult.pending: 'pending',
  ActivateSubscriptionResult.failed: 'failed',
};

UpdateAddressRequest _$UpdateAddressRequestFromJson(
  Map<String, dynamic> json,
) => UpdateAddressRequest(
  districtId: json['district_id'] as String,
  subDistrictId: json['sub_district_id'] as String,
  address: json['address'] as String,
);

Map<String, dynamic> _$UpdateAddressRequestToJson(
  UpdateAddressRequest instance,
) => <String, dynamic>{
  'district_id': instance.districtId,
  'sub_district_id': instance.subDistrictId,
  'address': instance.address,
};

SchedulePlanChangeRequest _$SchedulePlanChangeRequestFromJson(
  Map<String, dynamic> json,
) => SchedulePlanChangeRequest(
  newPlanVersionId: json['new_plan_version_id'] as String,
);

Map<String, dynamic> _$SchedulePlanChangeRequestToJson(
  SchedulePlanChangeRequest instance,
) => <String, dynamic>{'new_plan_version_id': instance.newPlanVersionId};

RequestPaymentMethodUpdateResponse _$RequestPaymentMethodUpdateResponseFromJson(
  Map<String, dynamic> json,
) => RequestPaymentMethodUpdateResponse(
  setupIntentId: json['setup_intent_id'] as String,
  setupIntentClientSecret: json['setup_intent_client_secret'] as String,
);

Map<String, dynamic> _$RequestPaymentMethodUpdateResponseToJson(
  RequestPaymentMethodUpdateResponse instance,
) => <String, dynamic>{
  'setup_intent_id': instance.setupIntentId,
  'setup_intent_client_secret': instance.setupIntentClientSecret,
};

CompletePaymentMethodUpdateRequest _$CompletePaymentMethodUpdateRequestFromJson(
  Map<String, dynamic> json,
) => CompletePaymentMethodUpdateRequest(
  setupIntentId: json['setup_intent_id'] as String,
);

Map<String, dynamic> _$CompletePaymentMethodUpdateRequestToJson(
  CompletePaymentMethodUpdateRequest instance,
) => <String, dynamic>{'setup_intent_id': instance.setupIntentId};

SubscriptionErrorBody _$SubscriptionErrorBodyFromJson(
  Map<String, dynamic> json,
) => SubscriptionErrorBody(
  code: json['code'] as String,
  httpStatus: (json['http_status'] as num).toInt(),
  userMessage: json['user_message'] as String?,
  debugMessage: json['debug_message'] as String?,
  fieldErrors: (json['fieldErrors'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(
      k,
      (e as List<dynamic>)
          .map((e) => FieldViolation.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  ),
);

Map<String, dynamic> _$SubscriptionErrorBodyToJson(
  SubscriptionErrorBody instance,
) => <String, dynamic>{
  'code': instance.code,
  'http_status': instance.httpStatus,
  'user_message': instance.userMessage,
  'debug_message': instance.debugMessage,
  'fieldErrors': instance.fieldErrors?.map(
    (k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()),
  ),
};

FieldViolation _$FieldViolationFromJson(Map<String, dynamic> json) =>
    FieldViolation(
      code: json['code'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$FieldViolationToJson(FieldViolation instance) =>
    <String, dynamic>{'code': instance.code, 'message': instance.message};
