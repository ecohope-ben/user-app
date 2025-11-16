import 'package:json_annotation/json_annotation.dart';

part 'profile_models.g.dart';

/// Gender enum
enum Gender {
  @JsonValue('male')
  male,
  @JsonValue('female')
  female,
  @JsonValue('non_binary')
  nonBinary,
  @JsonValue('prefer_not_to_say')
  preferNotToSay,
}

/// Profile model
@JsonSerializable()
class Profile {
  final String name;
  final String email;
  final String phone;
  final Gender gender;
  @JsonKey(name: 'birth_month')
  final int birthMonth;
  @JsonKey(name: 'birth_day')
  final int birthDay;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const Profile({
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.birthMonth,
    required this.birthDay,
    required this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}

/// Profile envelope
@JsonSerializable()
class ProfileEnvelope {
  final Profile profile;

  const ProfileEnvelope({
    required this.profile,
  });

  factory ProfileEnvelope.fromJson(Map<String, dynamic> json) =>
      _$ProfileEnvelopeFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileEnvelopeToJson(this);
}

/// Profile patch request
@JsonSerializable()
class ProfilePatchRequest {
  final String? name;
  final Gender? gender;
  @JsonKey(name: 'birth_month')
  final int? birthMonth;
  @JsonKey(name: 'birth_day')
  final int? birthDay;

  const ProfilePatchRequest({
    this.name,
    this.gender,
    this.birthMonth,
    this.birthDay,
  });

  factory ProfilePatchRequest.fromJson(Map<String, dynamic> json) =>
      _$ProfilePatchRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ProfilePatchRequestToJson(this);
}

/// Profile error body
@JsonSerializable()
class ProfileErrorBody {
  final String code;
  @JsonKey(name: 'http_status')
  final int httpStatus;
  final String message;
  final Map<String, List<FieldError>>? fields;

  const ProfileErrorBody({
    required this.code,
    required this.httpStatus,
    required this.message,
    this.fields,
  });

  factory ProfileErrorBody.fromJson(Map<String, dynamic> json) =>
      _$ProfileErrorBodyFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileErrorBodyToJson(this);
}

/// Field error
@JsonSerializable()
class FieldError {
  final String code;
  final String message;

  const FieldError({
    required this.code,
    required this.message,
  });

  factory FieldError.fromJson(Map<String, dynamic> json) =>
      _$FieldErrorFromJson(json);

  Map<String, dynamic> toJson() => _$FieldErrorToJson(this);
}

