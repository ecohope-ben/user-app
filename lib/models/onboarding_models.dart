import 'package:json_annotation/json_annotation.dart';
import 'profile_models.dart';

part 'onboarding_models.g.dart';

/// Onboarding status enum
enum OnboardingStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('completed')
  completed,
}

/// Onboarding model
@JsonSerializable()
class Onboarding {
  final OnboardingStatus status;
  final List<String> required;
  final List<String> completed;
  @JsonKey(name: 'next_action')
  final String? nextAction;
  final int version;

  const Onboarding({
    required this.status,
    required this.required,
    required this.completed,
    this.nextAction,
    required this.version,
  });

  factory Onboarding.fromJson(Map<String, dynamic> json) =>
      _$OnboardingFromJson(json);

  Map<String, dynamic> toJson() => _$OnboardingToJson(this);
}

/// Onboarding envelope
@JsonSerializable()
class OnboardingEnvelope {
  final Onboarding onboarding;

  const OnboardingEnvelope({
    required this.onboarding,
  });

  factory OnboardingEnvelope.fromJson(Map<String, dynamic> json) =>
      _$OnboardingEnvelopeFromJson(json);

  Map<String, dynamic> toJson() => _$OnboardingEnvelopeToJson(this);
}

/// Onboarding error body base
@JsonSerializable()
class OnboardingErrorBody {
  final String code;
  @JsonKey(name: 'http_status')
  final int httpStatus;
  @JsonKey(name: 'user_message')
  final String? userMessage;
  @JsonKey(name: 'debug_message')
  final String debugMessage;
  final Map<String, List<FieldError>>? fields;

  const OnboardingErrorBody({
    required this.code,
    required this.httpStatus,
    this.userMessage,
    required this.debugMessage,
    this.fields,
  });

  factory OnboardingErrorBody.fromJson(Map<String, dynamic> json) =>
      _$OnboardingErrorBodyFromJson(json);

  Map<String, dynamic> toJson() => _$OnboardingErrorBodyToJson(this);
}
