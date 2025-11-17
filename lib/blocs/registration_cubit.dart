import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../api/endpoints/registration_api.dart';
import '../api/index.dart';
import '../auth/index.dart';
import '../models/registration_models.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object?> get props => [];
}

/// init state
class RegistrationInitial extends RegistrationState {}

/// loading state
class RegistrationLoading extends RegistrationState {}

/// loading state
class RegistrationInProgressLoading extends RegistrationInProgress {
  const RegistrationInProgressLoading({required super.registration, required super.stepToken});
}

/// in progress
class RegistrationInProgress extends RegistrationState {
  final RegistrationSnapshot registration;
  final String stepToken;
  final String? resumeToken;

  const RegistrationInProgress({
    required this.registration,
    required this.stepToken,
    this.resumeToken,
  });

  RegistrationInProgress copyWith({
    RegistrationSnapshot? registration,
    String? stepToken,
    String? resumeToken,
  }) {
    return RegistrationInProgress(
      registration: registration ?? this.registration,
      stepToken: stepToken ?? this.stepToken,
      resumeToken: resumeToken ?? this.resumeToken,
    );
  }

  @override
  List<Object?> get props => [registration, stepToken, resumeToken];
}

/// register complete state
class RegistrationCompleted extends RegistrationState {
  final Session session;

  const RegistrationCompleted({required this.session});

  @override
  List<Object> get props => [session];
}

/// error state
class RegistrationError extends RegistrationState {
  final RegistrationSnapshot? registration;
  final String message;
  final String? code;
  final int? httpCode;
  final Map<String, List<FieldError>>? fieldErrors;

  const RegistrationError({
    this.registration,
    required this.message,
    this.code,
    this.httpCode,
    this.fieldErrors,
  });

  @override
  List<Object?> get props => [registration, message, code, httpCode, fieldErrors];
}


class RegistrationCubit extends Cubit<RegistrationState> {
  final RegisterApi _apiService;

  RegistrationCubit({RegisterApi? apiService}) : _apiService = Api.instance().register(), super(RegistrationInitial());

  /// Start register
  Future<void> startRegistration() async {
    try {
      emit(RegistrationLoading());
      print("--start reg");
      final response = await _apiService.startRegistration();
      print("--reg id: ${response.registration.id}");

      if (response.error != null) {
        print(response.error.toString());
        emit(RegistrationError(
          registration: response.registration,
          message: response.error!.userMessage ?? "",
          code: response.error!.code,
          httpCode: response.error!.httpStatus,
          fieldErrors: response.error!.fields,
        ));
        return;
      }

      emit(RegistrationInProgress(
        registration: response.registration,
        stepToken: response.registration.tokens.step,
        resumeToken: response.registration.tokens.resume,
      ));
    } catch (e, t) {
      if (e is RegistrationException) {

        print("--1");
        print(e.message);
        emit(RegistrationError(
          registration: e.registration,
          message: e.message,
          code: e.code,
          httpCode: e.httpStatus,
          fieldErrors: e.fields,
        ));

      } else {
        print("--2");
        print(e.toString());
        print(t.toString());
        emit(RegistrationError(message: e.toString()));
      }
    }
  }

  /// update register（email or phone）
  Future<void> updateRegistration({
    String? email,
    String? phone,
  }) async {
    final currentState = state;
    if (currentState is! RegistrationInProgress) return;

    try {
      emit(RegistrationInProgressLoading(registration: currentState.registration, stepToken: currentState.stepToken));
      
      final response = await _apiService.updateRegistration(
        registrationId: currentState.registration.id,
        stepToken: currentState.stepToken,
        request: RegistrationUpdateRequest(
          email: email,
          phone: phone,
        ),
      );

      if (response.error != null) {
        emit(RegistrationError(
          registration: response.registration,
          message: response.error!.userMessage ?? "",
          code: response.error!.code,
          httpCode: response.error!.httpStatus,
          fieldErrors: response.error!.fields,
        ));
        return;
      }

      emit(RegistrationInProgress(
        registration: response.registration,
        stepToken: response.registration.tokens.step,
        resumeToken: response.registration.tokens.resume,
      ));
      return;
    } catch (e) {
      if (e is RegistrationException) {
        emit(RegistrationError(
          registration: e.registration,
          message: e.message,
          code: e.code,
          httpCode: e.httpStatus,
          fieldErrors: e.fields,
        ));
      } else {
        emit(RegistrationError(message: e.toString()));
      }
    }
    return;
  }

  /// Request email OTP
  Future<void> requestEmailOtp() async {
    final currentState = state;
    if (currentState is! RegistrationInProgress) return;

    try {
      emit(RegistrationInProgressLoading(registration: currentState.registration, stepToken: currentState.stepToken));

      final response = await _apiService.requestEmailOtp(
        registrationId: currentState.registration.id,
        stepToken: currentState.stepToken,
      );

      if (response.error != null) {
        emit(RegistrationError(
          registration: response.registration,
          message: response.error!.userMessage ?? "",
          code: response.error!.code,
          httpCode: response.error!.httpStatus,
          fieldErrors: response.error!.fields,
        ));
        return;
      }
      print("--requestEmailOtp response");
      print(response.registration.email.value);
      print(response.registration.email.otpSentAt);
      print(response.registration.tokens.step);
      emit(RegistrationInProgress(
        registration: response.registration,
        stepToken: response.registration.tokens.step,
        resumeToken: response.registration.tokens.resume,
      ));
    } catch (e) {
      if (e is RegistrationException) {
        emit(RegistrationError(
          registration: e.registration,
          message: e.message,
          code: e.code,
          httpCode: e.httpStatus,
          fieldErrors: e.fields,
        ));
      } else {
        emit(RegistrationError(message: e.toString()));
      }
    }
  }

  /// Verify email OTP
  Future<void> verifyEmailOtp(String code) async {
    final currentState = state;
    if (currentState is! RegistrationInProgress) return;

    try {
      emit(RegistrationInProgressLoading(registration: currentState.registration, stepToken: currentState.stepToken));

      final response = await _apiService.verifyEmailOtp(
        registrationId: currentState.registration.id,
        stepToken: currentState.stepToken,
        code: code,
      );

      if (response.error != null) {
        emit(RegistrationError(
          registration: response.registration,
          message: response.error!.userMessage ?? "",
          code: response.error!.code,
          httpCode: response.error!.httpStatus,
          fieldErrors: response.error!.fields,
        ));
        return;
      }

      emit(RegistrationInProgress(
        registration: response.registration,
        stepToken: response.registration.tokens.step,
        resumeToken: response.registration.tokens.resume,
      ));
    } catch (e, t) {
      print(t);
      if (e is RegistrationException) {
        emit(RegistrationError(
          registration: e.registration,
          message: e.message,
          code: e.code,
          httpCode: e.httpStatus,
          fieldErrors: e.fields,
        ));
      } else {
        emit(RegistrationError(message: e.toString()));
      }
    }
  }

  /// Request phone OTP
  Future<void> requestPhoneOtp() async {
    final currentState = state;
    if (currentState is! RegistrationInProgress) return;

    try {
      // emit(RegistrationLoading());
      
      final response = await _apiService.requestPhoneOtp(
        registrationId: currentState.registration.id,
        stepToken: currentState.stepToken,
      );

      if (response.error != null) {
        emit(RegistrationError(
          registration: response.registration,
          message: response.error!.userMessage ?? "",
          code: response.error!.code,
          httpCode: response.error!.httpStatus,
          fieldErrors: response.error!.fields,
        ));
        return;
      }

      emit(RegistrationInProgress(
        registration: response.registration,
        stepToken: response.registration.tokens.step,
        resumeToken: response.registration.tokens.resume,
      ));
    } catch (e) {
      if (e is RegistrationException) {
        emit(RegistrationError(
          registration: e.registration,
          message: e.message,
          code: e.code,
          httpCode: e.httpStatus,
          fieldErrors: e.fields,
        ));
      } else {
        emit(RegistrationError(message: e.toString()));
      }
    }
  }

  /// Verify phone OTP
  Future<void> verifyPhoneOtp(String code) async {
    final currentState = state;
    if (currentState is! RegistrationInProgress) return;

    try {
      emit(RegistrationLoading());
      
      final response = await _apiService.verifyPhoneOtp(
        registrationId: currentState.registration.id,
        stepToken: currentState.stepToken,
        code: code,
      );

      if (response.error != null) {
        emit(RegistrationError(
          registration: response.registration,
          message: response.error!.userMessage ?? "",
          code: response.error!.code,
          httpCode: response.error!.httpStatus,
          fieldErrors: response.error!.fields,
        ));
        return;
      }
      // Save tokens to Auth
      final auth = Auth.instance();
      await auth.saveAccessToken(response.session.accessToken);
      await auth.saveRefreshToken(response.session.refreshToken);

      emit(RegistrationCompleted(session: response.session));
    } catch (e) {
      if (e is RegistrationException) {
        emit(RegistrationError(
          registration: e.registration,
          message: e.message,
          code: e.code,
          httpCode: e.httpStatus,
          fieldErrors: e.fields,
        ));
      } else {
        emit(RegistrationError(message: e.toString()));
      }
    }
  }

  /// recover register
  Future<void> recoverRegistration() async {
    final currentState = state;
    if (currentState is! RegistrationInProgress || currentState.resumeToken == null) return;

    try {
      emit(RegistrationLoading());
      
      final response = await _apiService.recoverRegistration(
        registrationId: currentState.registration.id,
        resumeToken: currentState.resumeToken!,
      );

      if (response.error != null) {
        emit(RegistrationError(
          registration: response.registration,
          message: response.error!.userMessage ?? "",
          code: response.error!.code,
          httpCode: response.error!.httpStatus,
          fieldErrors: response.error!.fields,
        ));
        return;
      }

      emit(RegistrationInProgress(
        registration: response.registration,
        stepToken: response.registration.tokens.step,
        resumeToken: response.registration.tokens.resume,
      ));
    } catch (e) {
      if (e is RegistrationException) {
        emit(RegistrationError(
          registration: e.registration,
          message: e.message,
          code: e.code,
          httpCode: e.httpStatus,
          fieldErrors: e.fields,
        ));
      } else {
        emit(RegistrationError(message: e.toString()));
      }
    }
  }

  void reset() {
    emit(RegistrationInitial());
  }

  void update(RegistrationState state) {
    emit(state);
  }

  void changeStage(RegistrationStage stage) {
    if(state is RegistrationInProgress){
      final currentState = state as RegistrationInProgress;

      // Create a new RegistrationSnapshot with updated stage
      final updatedRegistration = RegistrationSnapshot(
        id: currentState.registration.id,
        tokens: currentState.registration.tokens,
        stage: stage,
        email: currentState.registration.email,
        phone: currentState.registration.phone,
      );

      // Emit new state with updated registration
      emit(RegistrationInProgress(
        registration: updatedRegistration,
        stepToken: currentState.stepToken,
        resumeToken: currentState.resumeToken,
      ));
    }
  }
}
