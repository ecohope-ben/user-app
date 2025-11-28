import 'package:json_annotation/json_annotation.dart';

part 'entitlement_models.g.dart';

/// Type of entitlement granted to a customer
enum EntitlementType {
  @JsonValue('create_recycle_order')
  createRecycleOrder,
}

/// Source that granted the entitlement
enum EntitlementSourceType {
  @JsonValue('subscription_order')
  subscriptionOrder,
  @JsonValue('promotion')
  promotion,
  @JsonValue('manual')
  manual,
}

/// Current status for an entitlement
enum EntitlementStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('active')
  active,
  @JsonValue('exhausted')
  exhausted,
  @JsonValue('expired')
  expired,
}

/// Detailed entitlement record returned from API
@JsonSerializable()
class EntitlementListItem {
  final String id;
  @JsonKey(name: 'customer_id')
  final String customerId;
  @JsonKey(name: 'entitlement_type')
  final EntitlementType entitlementType;
  @JsonKey(name: 'quota_limit')
  final int quotaLimit;
  @JsonKey(name: 'quota_used')
  final int quotaUsed;
  @JsonKey(name: 'quota_remaining')
  final int quotaRemaining;
  @JsonKey(name: 'active_from')
  final DateTime activeFrom;
  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;
  @JsonKey(name: 'source_type')
  final EntitlementSourceType sourceType;
  @JsonKey(name: 'source_id')
  final String sourceId;
  final EntitlementStatus status;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const EntitlementListItem({
    required this.id,
    required this.customerId,
    required this.entitlementType,
    required this.quotaLimit,
    required this.quotaUsed,
    required this.quotaRemaining,
    required this.activeFrom,
    required this.expiresAt,
    required this.sourceType,
    required this.sourceId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EntitlementListItem.fromJson(Map<String, dynamic> json) =>
      _$EntitlementListItemFromJson(json);

  Map<String, dynamic> toJson() => _$EntitlementListItemToJson(this);
}

/// Envelope that wraps entitlement list responses
@JsonSerializable(explicitToJson: true)
class EntitlementListEnvelope {
  final List<EntitlementListItem> data;

  const EntitlementListEnvelope({required this.data});

  factory EntitlementListEnvelope.fromJson(Map<String, dynamic> json) =>
      _$EntitlementListEnvelopeFromJson(json);

  Map<String, dynamic> toJson() => _$EntitlementListEnvelopeToJson(this);
}

/// Error body shape returned by entitlement endpoints
@JsonSerializable()
class EntitlementErrorBody {
  final String code;
  @JsonKey(name: 'http_status')
  final int httpStatus;
  @JsonKey(name: 'user_message')
  final String? userMessage;
  @JsonKey(name: 'debug_message')
  final String? debugMessage;

  const EntitlementErrorBody({
    required this.code,
    required this.httpStatus,
    this.userMessage,
    this.debugMessage,
  });

  factory EntitlementErrorBody.fromJson(Map<String, dynamic> json) =>
      _$EntitlementErrorBodyFromJson(json);

  Map<String, dynamic> toJson() => _$EntitlementErrorBodyToJson(this);
}

