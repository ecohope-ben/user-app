// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logistics_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubDistrict _$SubDistrictFromJson(Map<String, dynamic> json) =>
    SubDistrict(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$SubDistrictToJson(SubDistrict instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

District _$DistrictFromJson(Map<String, dynamic> json) => District(
  id: json['id'] as String,
  name: json['name'] as String,
  subDistricts: (json['sub_districts'] as List<dynamic>)
      .map((e) => SubDistrict.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DistrictToJson(District instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'sub_districts': instance.subDistricts.map((e) => e.toJson()).toList(),
};

DistrictListEnvelope _$DistrictListEnvelopeFromJson(
  Map<String, dynamic> json,
) => DistrictListEnvelope(
  data: (json['data'] as List<dynamic>)
      .map((e) => District.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DistrictListEnvelopeToJson(
  DistrictListEnvelope instance,
) => <String, dynamic>{'data': instance.data.map((e) => e.toJson()).toList()};

LogisticsErrorBody _$LogisticsErrorBodyFromJson(Map<String, dynamic> json) =>
    LogisticsErrorBody(
      code: json['code'] as String,
      httpStatus: (json['http_status'] as num).toInt(),
      userMessage: json['user_message'] as String?,
      debugMessage: json['debug_message'] as String?,
    );

Map<String, dynamic> _$LogisticsErrorBodyToJson(LogisticsErrorBody instance) =>
    <String, dynamic>{
      'code': instance.code,
      'http_status': instance.httpStatus,
      'user_message': instance.userMessage,
      'debug_message': instance.debugMessage,
    };
