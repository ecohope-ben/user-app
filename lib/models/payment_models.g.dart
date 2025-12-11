// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentListItem _$PaymentListItemFromJson(Map<String, dynamic> json) =>
    PaymentListItem(
      id: json['id'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toInt(),
      amountDecimal: json['amount_decimal'] as String,
      currency: json['currency'] as String,
      occurredAt: DateTime.parse(json['occurred_at'] as String),
      subscriptionId: json['subscription_id'] as String?,
      orderId: json['order_id'] as String?,
    );

Map<String, dynamic> _$PaymentListItemToJson(PaymentListItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'amount': instance.amount,
      'amount_decimal': instance.amountDecimal,
      'currency': instance.currency,
      'occurred_at': instance.occurredAt.toIso8601String(),
      'subscription_id': instance.subscriptionId,
      'order_id': instance.orderId,
    };

PaymentDetail _$PaymentDetailFromJson(Map<String, dynamic> json) =>
    PaymentDetail(
      id: json['id'] as String,
      paymentNo: json['payment_no'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toInt(),
      amountDecimal: json['amount_decimal'] as String,
      currency: json['currency'] as String,
      status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
      type: $enumDecode(_$PaymentTypeEnumMap, json['type']),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      subscriptionId: json['subscription_id'] as String?,
      orderId: json['order_id'] as String?,
      paymentMethod: json['payment_method'] == null
          ? null
          : PaymentMethodInfo.fromJson(
              json['payment_method'] as Map<String, dynamic>,
            ),
      failureReason: json['failure_reason'] as String?,
      refundedAmount: (json['refunded_amount'] as num?)?.toInt(),
      refundedAmountDecimal: json['refunded_amount_decimal'] as String?,
    );

Map<String, dynamic> _$PaymentDetailToJson(PaymentDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'payment_no': instance.paymentNo,
      'description': instance.description,
      'amount': instance.amount,
      'amount_decimal': instance.amountDecimal,
      'currency': instance.currency,
      'status': _$PaymentStatusEnumMap[instance.status]!,
      'type': _$PaymentTypeEnumMap[instance.type]!,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'subscription_id': instance.subscriptionId,
      'order_id': instance.orderId,
      'payment_method': instance.paymentMethod?.toJson(),
      'failure_reason': instance.failureReason,
      'refunded_amount': instance.refundedAmount,
      'refunded_amount_decimal': instance.refundedAmountDecimal,
    };

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.processing: 'processing',
  PaymentStatus.succeeded: 'succeeded',
  PaymentStatus.failed: 'failed',
  PaymentStatus.canceled: 'canceled',
  PaymentStatus.refunded: 'refunded',
};

const _$PaymentTypeEnumMap = {
  PaymentType.subscription: 'subscription',
  PaymentType.order: 'order',
  PaymentType.refund: 'refund',
};

PaymentMethodInfo _$PaymentMethodInfoFromJson(Map<String, dynamic> json) =>
    PaymentMethodInfo(
      brand: json['brand'] as String,
      expMonth: (json['exp_month'] as num).toInt(),
      expYear: (json['exp_year'] as num).toInt(),
      last4: json['last4'] as String,
    );

Map<String, dynamic> _$PaymentMethodInfoToJson(PaymentMethodInfo instance) =>
    <String, dynamic>{
      'brand': instance.brand,
      'exp_month': instance.expMonth,
      'exp_year': instance.expYear,
      'last4': instance.last4,
    };

PaymentListEnvelope _$PaymentListEnvelopeFromJson(Map<String, dynamic> json) =>
    PaymentListEnvelope(
      data: (json['data'] as List<dynamic>)
          .map((e) => PaymentListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['total_count'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      offset: (json['offset'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PaymentListEnvelopeToJson(
  PaymentListEnvelope instance,
) => <String, dynamic>{
  'data': instance.data.map((e) => e.toJson()).toList(),
  'total_count': instance.totalCount,
  'limit': instance.limit,
  'offset': instance.offset,
};

PaymentDetailEnvelope _$PaymentDetailEnvelopeFromJson(
  Map<String, dynamic> json,
) => PaymentDetailEnvelope(
  data: PaymentDetail.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PaymentDetailEnvelopeToJson(
  PaymentDetailEnvelope instance,
) => <String, dynamic>{'data': instance.data.toJson()};

PaymentErrorBody _$PaymentErrorBodyFromJson(Map<String, dynamic> json) =>
    PaymentErrorBody(
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

Map<String, dynamic> _$PaymentErrorBodyToJson(PaymentErrorBody instance) =>
    <String, dynamic>{
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
