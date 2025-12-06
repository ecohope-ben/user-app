import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/endpoints/login_api.dart';
import '../api/index.dart';
import '../auth/index.dart';
import '../models/login_models.dart';
import '../models/registration_models.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginInProgress extends LoginState {
  final LoginSnapshot login;
  final String stepToken;
  final String? resumeToken;

  const LoginInProgress({
    required this.login,
    required this.stepToken,
    this.resumeToken,
  });

  LoginInProgress copyWith({
    LoginSnapshot? login,
    String? stepToken,
    String? resumeToken,
  }) {
    return LoginInProgress(
      login: login ?? this.login,
      stepToken: stepToken ?? this.stepToken,
      resumeToken: resumeToken ?? this.resumeToken,
    );
  }

  @override
  List<Object?> get props => [login, stepToken, resumeToken];
}

class LoginInProgressLoading extends LoginInProgress {
  const LoginInProgressLoading({
    required super.login,
    required super.stepToken,
    super.resumeToken,
  });
}

class LoginCompleted extends LoginState {
  final Session session;

  const LoginCompleted({required this.session});

  @override
  List<Object?> get props => [session];
}

class LoginError extends LoginState {
  final LoginSnapshot? login;
  final String message;
  final String? code;
  final int? httpCode;
  final Map<String, List<FieldError>>? fieldErrors;
  final String? resumeToken;

  const LoginError({
    this.login,
    required this.message,
    this.code,
    this.httpCode,
    this.fieldErrors,
    this.resumeToken
  });

  @override
  List<Object?> get props => [login, message, code, httpCode, fieldErrors, resumeToken];
}

class LoginCubit extends Cubit<LoginState> {
  final LoginApi _apiService;

  LoginCubit({LoginApi? apiService})
      : _apiService = apiService ?? Api.instance().login(),
        super(LoginInitial());

  Future<void> startLogin() async {
    try {
      emit(LoginLoading());
      final response = await _apiService.startLogin();

      if (response.error != null) {
        emit(LoginError(
          login: response.login,
          message: response.error!.userMessage ?? '',
          code: response.error!.code,
          httpCode: response.error!.httpStatus,
          fieldErrors: response.error!.fields
        ));
        return;
      }

      emit(LoginInProgress(
        login: response.login,
        stepToken: response.login.tokens.step,
        resumeToken: response.login.tokens.resume,
      ));
    } catch (e) {
      _handleException(e);
    }
  }

  Future<bool> updateEmail({required String email}) async {
    final currentState = state;
    print(currentState);
    if (currentState is! LoginInProgress) return false;

    try {
      emit(LoginInProgressLoading(
        login: currentState.login,
        stepToken: currentState.stepToken,
        resumeToken: currentState.resumeToken,
      ));

      final response = await _apiService.updateLogin(
        loginId: currentState.login.id,
        stepToken: currentState.stepToken,
        request: LoginUpdateRequest(email: email),
      );

      if (response.error != null) {
        emit(LoginError(
          login: response.login,
          message: response.error!.userMessage ?? '',
          code: response.error!.code,
          httpCode: response.error!.httpStatus,
          fieldErrors: response.error!.fields,
          resumeToken: currentState.resumeToken
        ));
        return false;
      }

      emit(LoginInProgress(
        login: response.login,
        stepToken: response.login.tokens.step,
        resumeToken: response.login.tokens.resume,
      ));
      return true;
    } catch (e) {
      _handleException(e);
      return false;
    }
  }

  Future<void> requestEmailOtp() async {
    final currentState = state;
    if (currentState is! LoginInProgress) return;

    try {
      emit(LoginInProgressLoading(
        login: currentState.login,
        stepToken: currentState.stepToken,
        resumeToken: currentState.resumeToken,
      ));

      final response = await _apiService.requestEmailOtp(
        loginId: currentState.login.id,
        stepToken: currentState.stepToken,
      );

      if (response.error != null) {
        emit(LoginError(
          login: response.login,
          message: response.error!.userMessage ?? '',
          code: response.error!.code,
          httpCode: response.error!.httpStatus,
          fieldErrors: response.error!.fields,
          resumeToken: currentState.resumeToken
        ));
        return;
      }

      emit(LoginInProgress(
        login: response.login,
        stepToken: response.login.tokens.step,
        resumeToken: response.login.tokens.resume,
      ));
    } catch (e) {
      _handleException(e);
    }
  }

  Future<void> verifyEmailOtp(String code) async {
    final currentState = state;
    print("--state");
    print(currentState);
    // Allow retry from LoginError state if login info is available
    LoginSnapshot? login;
    String? stepToken;
    String? resumeToken;

    if (currentState is LoginInProgress) {
      login = currentState.login;
      stepToken = currentState.stepToken;
      resumeToken = currentState.resumeToken;
    } else if (currentState is LoginError && currentState.login != null) {
      // Recover from error state
      login = currentState.login;
      // Need to get stepToken from login tokens
      stepToken = currentState.login!.tokens.step;
      resumeToken = currentState.login!.tokens.resume;
    } else {
      return;
    }

    try {
      print("--submit otp3");
      emit(LoginInProgressLoading(
        login: login!,
        stepToken: stepToken,
        resumeToken: resumeToken,
      ));

      final response = await _apiService.verifyEmailOtp(
        loginId: login.id,
        stepToken: stepToken,
        code: code,
      );

      if (response.error != null) {
        emit(LoginError(
          login: response.login,
          message: response.error!.userMessage ?? '',
          code: response.error!.code,
          httpCode: response.error!.httpStatus,
          fieldErrors: response.error!.fields,
          resumeToken: resumeToken
        ));
        return;
      }

      final session = response.session;
      if (session != null) {
        final auth = Auth.instance();
        await auth.saveAccessToken(session.accessToken);
        await auth.saveRefreshToken(session.refreshToken);
        await auth.saveSessionId(session.id);
        emit(LoginCompleted(session: session));
        return;
      }

      emit(LoginInProgress(
        login: response.login,
        stepToken: response.login.tokens.step,
        resumeToken: response.login.tokens.resume,
      ));
    } catch (e) {
      _handleException(e);
    }
  }

  Future<void> recoverLogin() async {
    final currentState = state;
    if (currentState is! LoginInProgress || currentState.resumeToken == null) {
      return;
    }

    try {
      emit(LoginLoading());
      final response = await _apiService.recoverLogin(
        loginId: currentState.login.id,
        resumeToken: currentState.resumeToken!,
      );

      if (response.error != null) {
        emit(LoginError(
          login: response.login,
          message: response.error!.userMessage ?? '',
          code: response.error!.code,
          httpCode: response.error!.httpStatus,
          fieldErrors: response.error!.fields,
          resumeToken: currentState.resumeToken!,
        ));
        return;
      }

      emit(LoginInProgress(
        login: response.login,
        stepToken: response.login.tokens.step,
        resumeToken: response.login.tokens.resume,
      ));
    } catch (e) {
      _handleException(e);
    }
  }

  void update(LoginInProgress state) {
    emit(state);
  }


  void reset() {
    emit(LoginInitial());
  }

  void _handleException(Object error) {
    if (error is LoginException) {
      emit(LoginError(
        login: error.login,
        message: error.message,
        code: error.code,
        httpCode: error.httpStatus,
        fieldErrors: error.fields
      ));
    } else {
      emit(LoginError(message: error.toString()));
    }
  }
}


