// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelState _$ChannelStateFromJson(Map<String, dynamic> json) => ChannelState(
  value: json['value'] as String?,
  isVerified: json['is_verified'] as bool,
  otpSentAt: json['otp_sent_at'] == null
      ? null
      : DateTime.parse(json['otp_sent_at'] as String),
  otpCooldownUntil: json['otp_cooldown_until'] == null
      ? null
      : DateTime.parse(json['otp_cooldown_until'] as String),
);

Map<String, dynamic> _$ChannelStateToJson(ChannelState instance) =>
    <String, dynamic>{
      'value': instance.value,
      'is_verified': instance.isVerified,
      'otp_sent_at': instance.otpSentAt?.toIso8601String(),
      'otp_cooldown_until': instance.otpCooldownUntil?.toIso8601String(),
    };

Tokens _$TokensFromJson(Map<String, dynamic> json) =>
    Tokens(step: json['step'] as String, resume: json['resume'] as String?);

Map<String, dynamic> _$TokensToJson(Tokens instance) => <String, dynamic>{
  'step': instance.step,
  'resume': instance.resume,
};


RegistrationSnapshot _$RegistrationSnapshotFromJson(
  Map<String, dynamic> json,
) => RegistrationSnapshot(
  id: json['id'] as String,
  tokens: Tokens.fromJson(json['tokens'] as Map<String, dynamic>),
  stage: $enumDecode(_$RegistrationStageEnumMap, json['stage']),
  email: ChannelState.fromJson(json['email'] as Map<String, dynamic>),
  phone: ChannelState.fromJson(json['phone'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RegistrationSnapshotToJson(
  RegistrationSnapshot instance,
) => <String, dynamic>{
  'id': instance.id,
  'tokens': instance.tokens,
  'stage': _$RegistrationStageEnumMap[instance.stage]!,
  'email': instance.email,
  'phone': instance.phone,
};

const _$RegistrationStageEnumMap = {
  RegistrationStage.emailInput: 'email_input',
  RegistrationStage.emailVerification: 'email_verification',
  RegistrationStage.phoneInput: 'phone_input',
  RegistrationStage.phoneVerification: 'phone_verification',
  RegistrationStage.completed: 'completed',
};

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
  id: json['id'] as String,
  accessToken: json['access_token'] as String,
  accessTokenExpiresAt: DateTime.parse(
    json['access_token_expires_at'] as String,
  ),
  refreshToken: json['refresh_token'] as String,
  refreshTokenExpiresAt: DateTime.parse(
    json['refresh_token_expires_at'] as String,
  ),
);

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
  'id': instance.id,
  'access_token': instance.accessToken,
  'access_token_expires_at': instance.accessTokenExpiresAt.toIso8601String(),
  'refresh_token': instance.refreshToken,
  'refresh_token_expires_at': instance.refreshTokenExpiresAt.toIso8601String(),
};

ErrorBody _$ErrorBodyFromJson(Map<String, dynamic> json) => ErrorBody(
  code: json['code'] as String,
  httpStatus: (json['http_status'] as num).toInt(),
  message: json['message'] as String,
  fields: (json['fields'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(
      k,
      (e as List<dynamic>)
          .map((e) => FieldError.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  ),
);

Map<String, dynamic> _$ErrorBodyToJson(ErrorBody instance) => <String, dynamic>{
  'code': instance.code,
  'http_status': instance.httpStatus,
  'message': instance.message,
  'fields': instance.fields,
};

FieldError _$FieldErrorFromJson(Map<String, dynamic> json) => FieldError(
  code: json['code'] as String,
  message: json['message'] as String,
);

Map<String, dynamic> _$FieldErrorToJson(FieldError instance) =>
    <String, dynamic>{'code': instance.code, 'message': instance.message};

RegistrationSuccessResponse _$RegistrationSuccessResponseFromJson(
  Map<String, dynamic> json,
) => RegistrationSuccessResponse(
  registration: RegistrationSnapshot.fromJson(
    json['registration'] as Map<String, dynamic>,
  ),
  session: json['session'] == null
      ? null
      : Session.fromJson(json['session'] as Map<String, dynamic>),
  error: json['error'] == null
      ? null
      : ErrorBody.fromJson(json['error'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RegistrationSuccessResponseToJson(
  RegistrationSuccessResponse instance,
) => <String, dynamic>{
  'registration': instance.registration,
  'session': instance.session,
  'error': instance.error,
};

RegistrationCompletedResponse _$RegistrationCompletedResponseFromJson(
  Map<String, dynamic> json,
) => RegistrationCompletedResponse(
  registration: RegistrationSnapshot.fromJson(
    json['registration'] as Map<String, dynamic>,
  ),
  session: Session.fromJson(json['session'] as Map<String, dynamic>),
  error: json['error'] == null
      ? null
      : ErrorBody.fromJson(json['error'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RegistrationCompletedResponseToJson(
  RegistrationCompletedResponse instance,
) => <String, dynamic>{
  'registration': instance.registration,
  'session': instance.session,
  'error': instance.error,
};

RegistrationUpdateRequest _$RegistrationUpdateRequestFromJson(
  Map<String, dynamic> json,
) => RegistrationUpdateRequest(
  email: json['email'] as String?,
  phone: json['phone'] as String?,
);

Map<String, dynamic> _$RegistrationUpdateRequestToJson(
  RegistrationUpdateRequest instance,
) => <String, dynamic>{'email': instance.email, 'phone': instance.phone};

OtpVerifyRequest _$OtpVerifyRequestFromJson(Map<String, dynamic> json) =>
    OtpVerifyRequest(code: json['code'] as String);

Map<String, dynamic> _$OtpVerifyRequestToJson(OtpVerifyRequest instance) =>
    <String, dynamic>{'code': instance.code};
