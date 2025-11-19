// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginSnapshot _$LoginSnapshotFromJson(Map<String, dynamic> json) =>
    LoginSnapshot(
      id: json['id'] as String,
      tokens: Tokens.fromJson(json['tokens'] as Map<String, dynamic>),
      stage: $enumDecode(_$LoginStageEnumMap, json['stage']),
      email: ChannelState.fromJson(json['email'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginSnapshotToJson(LoginSnapshot instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tokens': instance.tokens,
      'stage': _$LoginStageEnumMap[instance.stage]!,
      'email': instance.email,
    };

const _$LoginStageEnumMap = {
  LoginStage.emailInput: 'email_input',
  LoginStage.emailVerification: 'email_verification',
  LoginStage.completed: 'completed',
  LoginStage.failed: 'failed',
};

LoginSuccessResponse _$LoginSuccessResponseFromJson(
  Map<String, dynamic> json,
) => LoginSuccessResponse(
  login: LoginSnapshot.fromJson(json['login'] as Map<String, dynamic>),
  session: json['session'] == null
      ? null
      : Session.fromJson(json['session'] as Map<String, dynamic>),
  error: json['error'] == null
      ? null
      : ErrorBody.fromJson(json['error'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LoginSuccessResponseToJson(
  LoginSuccessResponse instance,
) => <String, dynamic>{
  'login': instance.login,
  'session': instance.session,
  'error': instance.error,
};

LoginUpdateRequest _$LoginUpdateRequestFromJson(Map<String, dynamic> json) =>
    LoginUpdateRequest(email: json['email'] as String?);

Map<String, dynamic> _$LoginUpdateRequestToJson(LoginUpdateRequest instance) =>
    <String, dynamic>{'email': instance.email};
