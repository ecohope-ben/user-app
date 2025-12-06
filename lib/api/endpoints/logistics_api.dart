import 'package:dio/dio.dart';

import '../../models/logistics_models.dart';
import '../index.dart';

class LogisticsApi extends ApiEndpoint {
  LogisticsApi(super.api);

  /// Fetch active logistics districts with nested sub-districts
  Future<DistrictListEnvelope> listDistricts({String? locale}) async {
    final headers = <String, String>{};
    if (locale != null && locale.isNotEmpty) {
      headers['Accept-Language'] = locale;
    }

    try {
      final response = await http.get(
        '/logistics/districts',
        options: headers.isEmpty ? null : Options(headers: headers),
      );
      return DistrictListEnvelope.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleLogisticsDioError(e);
    }
  }

  Exception _handleLogisticsDioError(DioException e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      try {
        final errorBody = LogisticsErrorBody.fromJson(data);
        return LogisticsException(
          code: errorBody.code,
          httpStatus: errorBody.httpStatus,
          userMessage: errorBody.userMessage,
          debugMessage: errorBody.debugMessage,
        );
      } catch (_) {}
    }

    return LogisticsException(
      code: 'logistics.unexpected_error',
      httpStatus: e.response?.statusCode ?? 0,
      userMessage: 'Unable to load service districts. Please try again later.',
      debugMessage: e.message,
    );
  }
}

class LogisticsException implements Exception {
  final String code;
  final int httpStatus;
  final String? userMessage;
  final String? debugMessage;

  const LogisticsException({
    required this.code,
    required this.httpStatus,
    this.userMessage,
    this.debugMessage,
  });

  @override
  String toString() =>
      'LogisticsException(code: $code, status: $httpStatus, message: $userMessage)';
}

