// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  gender: $enumDecode(_$GenderEnumMap, json['gender']),
  birthMonth: (json['birth_month'] as num).toInt(),
  birthDay: (json['birth_day'] as num).toInt(),
  ageGroup: json['age_group'] as String,
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'gender': _$GenderEnumMap[instance.gender]!,
  'birth_month': instance.birthMonth,
  'birth_day': instance.birthDay,
  'age_group': instance.ageGroup,
  'updated_at': instance.updatedAt.toIso8601String(),
};

const _$GenderEnumMap = {Gender.male: 'male', Gender.female: 'female'};

ProfileEnvelope _$ProfileEnvelopeFromJson(Map<String, dynamic> json) =>
    ProfileEnvelope(
      profile: Profile.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProfileEnvelopeToJson(ProfileEnvelope instance) =>
    <String, dynamic>{'profile': instance.profile};

ProfilePatchRequest _$ProfilePatchRequestFromJson(Map<String, dynamic> json) =>
    ProfilePatchRequest(
      name: json['name'] as String?,
      gender: json['gender'] as String?,
      birthMonth: (json['birth_month'] as num?)?.toInt(),
      birthDay: (json['birth_day'] as num?)?.toInt(),
      ageGroup: json['age_group'] as String?,
    );

Map<String, dynamic> _$ProfilePatchRequestToJson(
  ProfilePatchRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'gender': instance.gender,
  'birth_month': instance.birthMonth,
  'birth_day': instance.birthDay,
  'age_group': instance.ageGroup,
};

ProfileErrorBody _$ProfileErrorBodyFromJson(Map<String, dynamic> json) =>
    ProfileErrorBody(
      code: json['code'] as String,
      httpStatus: (json['http_status'] as num).toInt(),
      userMessage: json['userMessage'] as String?,
      debugMessage: json['debugMessage'] as String?,
      fields: (json['fields'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map((e) => FieldError.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ),
    );

Map<String, dynamic> _$ProfileErrorBodyToJson(ProfileErrorBody instance) =>
    <String, dynamic>{
      'code': instance.code,
      'http_status': instance.httpStatus,
      'userMessage': instance.userMessage,
      'debugMessage': instance.debugMessage,
      'fields': instance.fields,
    };

FieldError _$FieldErrorFromJson(Map<String, dynamic> json) => FieldError(
  code: json['code'] as String,
  message: json['message'] as String,
);

Map<String, dynamic> _$FieldErrorToJson(FieldError instance) =>
    <String, dynamic>{'code': instance.code, 'message': instance.message};
