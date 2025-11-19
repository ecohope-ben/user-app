import 'package:json_annotation/json_annotation.dart';

import 'registration_models.dart'
    show ChannelState, Tokens, Session, ErrorBody;

part 'login_models.g.dart';

enum LoginStage {
  @JsonValue('email_input')
  emailInput,
  @JsonValue('email_verification')
  emailVerification,
  @JsonValue('completed')
  completed,
  @JsonValue('failed')
  failed,
}

@JsonSerializable()
class LoginSnapshot {
  final String id;
  final Tokens tokens;
  final LoginStage stage;
  final ChannelState email;

  const LoginSnapshot({
    required this.id,
    required this.tokens,
    required this.stage,
    required this.email,
  });

  factory LoginSnapshot.fromJson(Map<String, dynamic> json) =>
      _$LoginSnapshotFromJson(json);

  Map<String, dynamic> toJson() => _$LoginSnapshotToJson(this);
}

@JsonSerializable()
class LoginSuccessResponse {
  final LoginSnapshot login;
  final Session? session;
  final ErrorBody? error;

  const LoginSuccessResponse({
    required this.login,
    this.session,
    this.error,
  });

  factory LoginSuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginSuccessResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginSuccessResponseToJson(this);
}

@JsonSerializable()
class LoginUpdateRequest {
  final String? email;

  const LoginUpdateRequest({this.email});

  factory LoginUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginUpdateRequestToJson(this);
}


