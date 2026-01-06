import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../api/endpoints/profile_api.dart';
import '../api/index.dart';
import '../auth/index.dart';
import '../models/profile_models.dart';

/// Profile state
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ProfileInitial extends ProfileState {}

/// Loading state
class ProfileLoading extends ProfileState {}

class ProfileUpdateSuccess extends ProfileState {}

class ProfileDeleteSuccess extends ProfileState {}

/// Profile loaded state
class ProfileLoaded extends ProfileState {
  final Profile profile;

  const ProfileLoaded({required this.profile});

  @override
  List<Object> get props => [profile];
}

/// Profile updated state
class ProfileUpdated extends ProfileState {
  final Profile profile;

  const ProfileUpdated({required this.profile});

  @override
  List<Object> get props => [profile];
}

/// Error state
class ProfileError extends ProfileState {
  final String message;
  final String? code;
  final Map<String, List<FieldError>>? fieldErrors;

  const ProfileError({
    required this.message,
    this.code,
    this.fieldErrors,
  });

  @override
  List<Object?> get props => [message, code, fieldErrors];
}

/// Profile Cubit
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileApi _apiService;

  ProfileCubit({
    ProfileApi? apiService,
  })  : _apiService = apiService ?? Api.instance().profile(), super(ProfileInitial());

  /// Load profile
  Future<void> loadProfile() async {
    try {
      emit(ProfileLoading());
      final envelope = await _apiService.getProfile();

      // save profile
      Auth.instance().saveProfile(envelope.profile);

      emit(ProfileLoaded(profile: envelope.profile));
    } catch (e) {
      if (e is ProfileException) {
        emit(ProfileError(
          message: e.userMessage ?? "",
          code: e.code,
          fieldErrors: e.fields,
        ));
      } else {
        emit(ProfileError(message: e.toString()));
      }
    }
  }
  /// Update profile
  Future<void> updateProfileOnboarding({
    String? name,
    String? gender,
    int? birthMonth,
    int? birthDay,
    String? ageGroup
  }) async {
    try {
      emit(ProfileLoading());

      final request = ProfilePatchRequest(
          name: name,
          gender: gender,
          birthMonth: birthMonth,
          birthDay: birthDay,
          ageGroup: ageGroup
      );

      await _apiService.updateProfile(
        request: request,
      );

      // refresh token after register
      final auth = Auth.instance();
      final session = await Api.instance().login().refreshSession();

      await auth.saveAccessToken(session.accessToken);
      await auth.saveRefreshToken(session.refreshToken);
      await auth.saveSessionId(session.id);

      emit(ProfileUpdateSuccess());

      // // Reload profile after update
      // await loadProfile();
    } catch (e) {
      if (e is ProfileException) {
        emit(ProfileError(
          message: e.userMessage ?? "",
          code: e.code,
          fieldErrors: e.fields,
        ));
      } else {
        emit(ProfileError(message: e.toString()));
      }
    }
  }

  /// Update profile
  Future<void> updateProfile({
    String? name,
    String? gender,
    int? birthMonth,
    int? birthDay,
    String? ageGroup
  }) async {
    try {
      emit(ProfileLoading());
      
      final request = ProfilePatchRequest(
        name: name,
        gender: gender,
        birthMonth: birthMonth,
        birthDay: birthDay,
        ageGroup: ageGroup
      );

      await _apiService.patchProfile(
        request: request,
      );

      emit(ProfileUpdateSuccess());

      // // Reload profile after update
      // await loadProfile();
    } catch (e) {
      if (e is ProfileException) {
        emit(ProfileError(
          message: e.userMessage ?? "",
          code: e.code,
          fieldErrors: e.fields,
        ));
      } else {
        emit(ProfileError(message: e.toString()));
      }
    }
  }

  /// Delete account
  Future<void> deleteAccount() async {
    try {
      emit(ProfileLoading());
      await _apiService.deleteAccount();
      emit(ProfileDeleteSuccess());
    } catch (e) {
      if (e is ProfileException) {
        emit(ProfileError(
          message: e.userMessage ?? "",
          code: e.code,
          fieldErrors: e.fields,
        ));
      } else {
        emit(ProfileError(message: e.toString()));
      }
    }
  }

  /// Reset state
  void reset() {
    emit(ProfileInitial());
  }
}

