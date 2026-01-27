// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entitlement_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntitlementListItem _$EntitlementListItemFromJson(Map<String, dynamic> json) =>
    EntitlementListItem(
      id: json['id'] as String,
      entitlementType: $enumDecode(
        _$EntitlementTypeEnumMap,
        json['entitlement_type'],
      ),
      quotaLimit: (json['quota_limit'] as num).toInt(),
      quotaUsed: (json['quota_used'] as num).toInt(),
      quotaRemaining: (json['quota_remaining'] as num).toInt(),
      activeFrom: DateTime.parse(json['active_from'] as String),
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
      sourceType: json['source_type'] as String,
      sourceId: json['source_id'] as String,
      status: $enumDecode(_$EntitlementStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$EntitlementListItemToJson(
  EntitlementListItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'entitlement_type': _$EntitlementTypeEnumMap[instance.entitlementType]!,
  'quota_limit': instance.quotaLimit,
  'quota_used': instance.quotaUsed,
  'quota_remaining': instance.quotaRemaining,
  'active_from': instance.activeFrom.toIso8601String(),
  'expires_at': instance.expiresAt?.toIso8601String(),
  'source_type': instance.sourceType,
  'source_id': instance.sourceId,
  'status': _$EntitlementStatusEnumMap[instance.status]!,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

const _$EntitlementTypeEnumMap = {
  EntitlementType.createRecycleOrder: 'create_recycle_order',
};

const _$EntitlementStatusEnumMap = {
  EntitlementStatus.pending: 'pending',
  EntitlementStatus.active: 'active',
  EntitlementStatus.exhausted: 'exhausted',
  EntitlementStatus.expired: 'expired',
};

EntitlementListEnvelope _$EntitlementListEnvelopeFromJson(
  Map<String, dynamic> json,
) => EntitlementListEnvelope(
  data: (json['data'] as List<dynamic>)
      .map((e) => EntitlementListItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$EntitlementListEnvelopeToJson(
  EntitlementListEnvelope instance,
) => <String, dynamic>{'data': instance.data.map((e) => e.toJson()).toList()};

EntitlementErrorBody _$EntitlementErrorBodyFromJson(
  Map<String, dynamic> json,
) => EntitlementErrorBody(
  code: json['code'] as String,
  httpStatus: (json['http_status'] as num).toInt(),
  userMessage: json['user_message'] as String?,
  debugMessage: json['debug_message'] as String?,
);

Map<String, dynamic> _$EntitlementErrorBodyToJson(
  EntitlementErrorBody instance,
) => <String, dynamic>{
  'code': instance.code,
  'http_status': instance.httpStatus,
  'user_message': instance.userMessage,
  'debug_message': instance.debugMessage,
};
