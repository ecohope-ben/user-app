import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/endpoints/logistics_api.dart';
import '../api/index.dart';
import '../models/logistics_models.dart';

/// Base state for district cubit
abstract class DistrictState extends Equatable {
  const DistrictState();

  @override
  List<Object?> get props => [];
}

/// Initial placeholder state
class DistrictInitial extends DistrictState {
  const DistrictInitial();
}

/// Loading districts
class DistrictLoading extends DistrictState {
  const DistrictLoading();
}

/// Districts loaded successfully
class DistrictLoaded extends DistrictState {
  final List<District> districts;

  const DistrictLoaded({required this.districts});

  @override
  List<Object?> get props => [districts];
}

/// Error loading districts
class DistrictError extends DistrictState {
  final String message;

  const DistrictError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Cubit that manages district data loading
class DistrictCubit extends Cubit<DistrictState> {
  final LogisticsApi _api;

  DistrictCubit({LogisticsApi? api})
      : _api = api ?? Api.instance().logistics(),
        super(const DistrictInitial());

  /// Load districts from API
  Future<void> loadDistricts({String? locale}) async {
    emit(const DistrictLoading());
    try {
      final envelope = await _api.listDistricts(locale: locale);
      emit(DistrictLoaded(districts: envelope.data));
    } catch (error) {
      if (error is LogisticsException) {
        emit(DistrictError(message: error.userMessage ?? error.toString()));
      } else {
        emit(DistrictError(message: error.toString()));
      }
    }
  }
}
