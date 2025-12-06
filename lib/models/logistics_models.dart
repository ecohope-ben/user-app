import 'package:json_annotation/json_annotation.dart';

part 'logistics_models.g.dart';

/// Sub-district within a logistics district
@JsonSerializable()
class SubDistrict {
  final String id;
  final String name;

  const SubDistrict({
    required this.id,
    required this.name,
  });

  factory SubDistrict.fromJson(Map<String, dynamic> json) =>
      _$SubDistrictFromJson(json);

  Map<String, dynamic> toJson() => _$SubDistrictToJson(this);
}

/// District that contains active sub-districts
@JsonSerializable(explicitToJson: true)
class District {
  final String id;
  final String name;
  @JsonKey(name: 'sub_districts')
  final List<SubDistrict> subDistricts;

  const District({
    required this.id,
    required this.name,
    required this.subDistricts,
  });

  factory District.fromJson(Map<String, dynamic> json) =>
      _$DistrictFromJson(json);

  Map<String, dynamic> toJson() => _$DistrictToJson(this);
}

/// Envelope returned by /logistics/districts
@JsonSerializable(explicitToJson: true)
class DistrictListEnvelope {
  final List<District> data;

  const DistrictListEnvelope({
    required this.data,
  });

  factory DistrictListEnvelope.fromJson(Map<String, dynamic> json) =>
      _$DistrictListEnvelopeFromJson(json);

  Map<String, dynamic> toJson() => _$DistrictListEnvelopeToJson(this);
}

/// Error body shape for logistics endpoints
@JsonSerializable()
class LogisticsErrorBody {
  final String code;
  @JsonKey(name: 'http_status')
  final int httpStatus;
  @JsonKey(name: 'user_message')
  final String? userMessage;
  @JsonKey(name: 'debug_message')
  final String? debugMessage;

  const LogisticsErrorBody({
    required this.code,
    required this.httpStatus,
    this.userMessage,
    this.debugMessage,
  });

  factory LogisticsErrorBody.fromJson(Map<String, dynamic> json) =>
      _$LogisticsErrorBodyFromJson(json);

  Map<String, dynamic> toJson() => _$LogisticsErrorBodyToJson(this);
}

