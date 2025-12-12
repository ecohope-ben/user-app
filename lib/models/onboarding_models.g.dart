// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Onboarding _$OnboardingFromJson(Map<String, dynamic> json) => Onboarding(
  status: $enumDecode(_$OnboardingStatusEnumMap, json['status']),
  required: (json['required'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  completed: (json['completed'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  nextAction: json['next_action'] as String?,
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$OnboardingToJson(Onboarding instance) =>
    <String, dynamic>{
      'status': _$OnboardingStatusEnumMap[instance.status]!,
      'required': instance.required,
      'completed': instance.completed,
      'next_action': instance.nextAction,
      'version': instance.version,
    };

const _$OnboardingStatusEnumMap = {
  OnboardingStatus.pending: 'pending',
  OnboardingStatus.completed: 'completed',
};

OnboardingEnvelope _$OnboardingEnvelopeFromJson(Map<String, dynamic> json) =>
    OnboardingEnvelope(
      onboarding: Onboarding.fromJson(
        json['onboarding'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$OnboardingEnvelopeToJson(OnboardingEnvelope instance) =>
    <String, dynamic>{'onboarding': instance.onboarding};

OnboardingErrorBody _$OnboardingErrorBodyFromJson(Map<String, dynamic> json) =>
    OnboardingErrorBody(
      code: json['code'] as String,
      httpStatus: (json['http_status'] as num).toInt(),
      userMessage: json['user_message'] as String?,
      debugMessage: json['debug_message'] as String,
      fields: (json['fields'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map((e) => FieldError.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ),
    );

Map<String, dynamic> _$OnboardingErrorBodyToJson(
  OnboardingErrorBody instance,
) => <String, dynamic>{
  'code': instance.code,
  'http_status': instance.httpStatus,
  'user_message': instance.userMessage,
  'debug_message': instance.debugMessage,
  'fields': instance.fields,
};
