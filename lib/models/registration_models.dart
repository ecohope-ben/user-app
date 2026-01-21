import 'package:json_annotation/json_annotation.dart';

part 'registration_models.g.dart';

enum RegistrationStage {
  @JsonValue('email_input')
  emailInput,
  @JsonValue('email_verification')
  emailVerification,
  @JsonValue('phone_input')
  phoneInput,
  @JsonValue('phone_verification')
  phoneVerification,
  @JsonValue('completed')
  completed,
}

/// Channel State（email or phone）
@JsonSerializable(fieldRename: FieldRename.snake)
class ChannelState {
  final String? value;
  final bool isVerified;
  final DateTime? otpSentAt;
  final DateTime? otpCooldownUntil;

  const ChannelState({
    this.value,
    required this.isVerified,
    this.otpSentAt,
    this.otpCooldownUntil,
  });

  factory ChannelState.fromJson(Map<String, dynamic> json) =>
      _$ChannelStateFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelStateToJson(this);
}

/// Token info
@JsonSerializable()
class Tokens {
  final String step;
  final String? resume;

  const Tokens({
    required this.step,
    this.resume,
  });

  factory Tokens.fromJson(Map<String, dynamic> json) => _$TokensFromJson(json);

  Map<String, dynamic> toJson() => _$TokensToJson(this);
}

@JsonSerializable()
class RegistrationSnapshot {
  final String id;
  final Tokens tokens;
  final RegistrationStage stage;
  final ChannelState email;
  final ChannelState phone;

  const RegistrationSnapshot({
    required this.id,
    required this.tokens,
    required this.stage,
    required this.email,
    required this.phone,
  });

  factory RegistrationSnapshot.fromJson(Map<String, dynamic> json) =>
      _$RegistrationSnapshotFromJson(json);

  Map<String, dynamic> toJson() => _$RegistrationSnapshotToJson(this);
}

/// user info
@JsonSerializable(fieldRename: FieldRename.snake)
class Session {
  final String id;
  final String accessToken;
  final DateTime accessTokenExpiresAt;
  final String refreshToken;
  final DateTime refreshTokenExpiresAt;

  const Session({
    required this.id,
    required this.accessToken,
    required this.accessTokenExpiresAt,
    required this.refreshToken,
    required this.refreshTokenExpiresAt,
  });

  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);

  Map<String, dynamic> toJson() => _$SessionToJson(this);
}

/// Error body
@JsonSerializable(fieldRename: FieldRename.snake)
class ErrorBody {
  final String code;
  final int httpStatus;
  final String? userMessage;
  final String? debugMessage;
  final Map<String, List<FieldError>>? fields;

  const ErrorBody({
    required this.code,
    required this.httpStatus,
    required this.userMessage,
    required this.debugMessage,
    this.fields,
  });

  factory ErrorBody.fromJson(Map<String, dynamic> json) =>
      _$ErrorBodyFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorBodyToJson(this);
}


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
class RegistrationResponse {
  const RegistrationResponse();
}

@JsonSerializable()
class RegistrationExistingAccountResponse extends RegistrationResponse{
  final Session session;
  final ErrorBody? error;

  const RegistrationExistingAccountResponse({
    required this.session,
    this.error,
  });

  factory RegistrationExistingAccountResponse.fromJson(Map<String, dynamic> json) =>
      _$RegistrationExistingAccountResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegistrationExistingAccountResponseToJson(this);
}

@JsonSerializable()
class RegistrationSuccessResponse extends RegistrationResponse{
  final RegistrationSnapshot registration;
  final Session? session;
  final ErrorBody? error;

  const RegistrationSuccessResponse({
    required this.registration,
    this.session,
    this.error,
  });

  factory RegistrationSuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$RegistrationSuccessResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegistrationSuccessResponseToJson(this);
}

@JsonSerializable()
class RegistrationCompletedResponse {
  final RegistrationSnapshot registration;
  final Session session;
  final ErrorBody? error;

  const RegistrationCompletedResponse({
    required this.registration,
    required this.session,
    this.error,
  });

  factory RegistrationCompletedResponse.fromJson(Map<String, dynamic> json) =>
      _$RegistrationCompletedResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegistrationCompletedResponseToJson(this);
}

@JsonSerializable()
class RegistrationUpdateRequest {
  final String? email;
  final String? phone;

  @JsonKey(name: 'marketing_opt_in')
  final bool? marketingOptIn;

  const RegistrationUpdateRequest({
    this.email,
    this.phone,
    this.marketingOptIn
  });

  factory RegistrationUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$RegistrationUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegistrationUpdateRequestToJson(this);
}


@JsonSerializable()
class OtpVerifyRequest {
  final String code;

  const OtpVerifyRequest({
    required this.code,
  });

  factory OtpVerifyRequest.fromJson(Map<String, dynamic> json) =>
      _$OtpVerifyRequestFromJson(json);

  Map<String, dynamic> toJson() => _$OtpVerifyRequestToJson(this);
}
