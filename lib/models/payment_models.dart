import 'package:json_annotation/json_annotation.dart';

part 'payment_models.g.dart';

/// Payment status
enum PaymentStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('processing')
  processing,
  @JsonValue('succeeded')
  succeeded,
  @JsonValue('failed')
  failed,
  @JsonValue('canceled')
  canceled,
  @JsonValue('refunded')
  refunded,
}

/// Payment type
enum PaymentType {
  @JsonValue('subscription')
  subscription,
  @JsonValue('order')
  order,
  @JsonValue('refund')
  refund,
}

/// Payment list item for payment history
@JsonSerializable(explicitToJson: true)
class PaymentListItem {
  final String id;
  final String description;
  final int amount;
  @JsonKey(name: 'amount_decimal')
  final String amountDecimal;
  final String currency;
  @JsonKey(name: 'occurred_at')
  final DateTime occurredAt;
  @JsonKey(name: 'subscription_id')
  final String? subscriptionId;
  @JsonKey(name: 'order_id')
  final String? orderId;

  const PaymentListItem({
    required this.id,
    required this.description,
    required this.amount,
    required this.amountDecimal,
    required this.currency,
    required this.occurredAt,
    this.subscriptionId,
    this.orderId,
  });

  factory PaymentListItem.fromJson(Map<String, dynamic> json) =>
      _$PaymentListItemFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentListItemToJson(this);
}

/// Payment detail information
@JsonSerializable(explicitToJson: true)
class PaymentDetail {
  final String id;
  @JsonKey(name: 'payment_no')
  final String paymentNo;
  final String description;
  final int amount;
  @JsonKey(name: 'amount_decimal')
  final String amountDecimal;
  final String currency;
  final PaymentStatus status;
  final PaymentType type;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'subscription_id')
  final String? subscriptionId;
  @JsonKey(name: 'order_id')
  final String? orderId;
  @JsonKey(name: 'payment_method')
  final PaymentMethodInfo? paymentMethod;
  @JsonKey(name: 'failure_reason')
  final String? failureReason;
  @JsonKey(name: 'refunded_amount')
  final int? refundedAmount;
  @JsonKey(name: 'refunded_amount_decimal')
  final String? refundedAmountDecimal;

  const PaymentDetail({
    required this.id,
    required this.paymentNo,
    required this.description,
    required this.amount,
    required this.amountDecimal,
    required this.currency,
    required this.status,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.subscriptionId,
    this.orderId,
    this.paymentMethod,
    this.failureReason,
    this.refundedAmount,
    this.refundedAmountDecimal,
  });

  factory PaymentDetail.fromJson(Map<String, dynamic> json) =>
      _$PaymentDetailFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentDetailToJson(this);
}

/// Payment method information for payment detail
@JsonSerializable()
class PaymentMethodInfo {
  final String brand;
  @JsonKey(name: 'exp_month')
  final int expMonth;
  @JsonKey(name: 'exp_year')
  final int expYear;
  final String last4;

  const PaymentMethodInfo({
    required this.brand,
    required this.expMonth,
    required this.expYear,
    required this.last4,
  });

  factory PaymentMethodInfo.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodInfoToJson(this);
}

/// Envelope containing payment list response
@JsonSerializable(explicitToJson: true)
class PaymentListEnvelope {
  final List<PaymentListItem> data;
  @JsonKey(name: 'total_count')
  final int? totalCount;
  final int? limit;
  final int? offset;

  const PaymentListEnvelope({
    required this.data,
    this.totalCount,
    this.limit,
    this.offset,
  });

  factory PaymentListEnvelope.fromJson(Map<String, dynamic> json) =>
      _$PaymentListEnvelopeFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentListEnvelopeToJson(this);
}

/// Envelope containing single payment detail
@JsonSerializable(explicitToJson: true)
class PaymentDetailEnvelope {
  final PaymentDetail data;

  const PaymentDetailEnvelope({required this.data});

  factory PaymentDetailEnvelope.fromJson(Map<String, dynamic> json) =>
      _$PaymentDetailEnvelopeFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentDetailEnvelopeToJson(this);
}

/// Payment error response body
@JsonSerializable(explicitToJson: true)
class PaymentErrorBody {
  final String code;
  @JsonKey(name: 'http_status')
  final int httpStatus;
  @JsonKey(name: 'user_message')
  final String? userMessage;
  @JsonKey(name: 'debug_message')
  final String? debugMessage;
  @JsonKey(name: 'fieldErrors')
  final Map<String, List<FieldViolation>>? fieldErrors;

  const PaymentErrorBody({
    required this.code,
    required this.httpStatus,
    this.userMessage,
    this.debugMessage,
    this.fieldErrors,
  });

  factory PaymentErrorBody.fromJson(Map<String, dynamic> json) =>
      _$PaymentErrorBodyFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentErrorBodyToJson(this);
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

