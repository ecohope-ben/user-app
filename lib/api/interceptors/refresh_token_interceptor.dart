import 'package:dio/dio.dart';
import '../../auth/index.dart';
import '../../models/registration_models.dart';
import '../../routes.dart';

class RefreshTokenInterceptor extends Interceptor {
  final Auth _auth = Auth.instance();
  bool _isRefreshing = false;
  final List<_PendingRequest> _pendingRequests = [];

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {

    print("--401 RefreshTokenInterceptor");
    // Only handle 401 errors
    if (err.response?.statusCode == 401) {
      print("--401 error");

      final requestOptions = err.requestOptions;

      // Skip refresh for the refresh endpoint itself to avoid infinite loop
      if (requestOptions.path == '/auth/session/refresh') {
        return super.onError(err, handler);
      }

      // Skip if no refresh token available
      if (_auth.refreshToken == null || _auth.refreshToken!.isEmpty) {

        print("--401 error2");
        return super.onError(err, handler);
      }

      // If already refreshing, queue this request
      if (_isRefreshing) {

        print("--401 error3");
        return _queueRequest(requestOptions, handler);
      }

      print("--401 error4");
      // Start refreshing token
      _isRefreshing = true;

      try {

        print("--401 error5");
        // Create a new Dio instance without interceptors to avoid recursion
        final dio = Dio(BaseOptions(baseUrl: requestOptions.baseUrl))
          ..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
        
        // Call refresh endpoint with refresh token in header
        final refreshToken = _auth.refreshToken!;
        final sessionId = _auth.sessionId;

        // print("--401 error6: ${refreshToken}, ${sessionId}");
        final refreshResponse = await dio.post(
          '/auth/session/refresh',
          data: {
            "refresh_token": refreshToken,
            "session_id": sessionId,
          }
        );
        // print("--401 error7: ${refreshResponse.toString()}");
        // Parse session from response
        final session = Session.fromJson(refreshResponse.data);

        // Update tokens in Auth
        await _auth.saveAccessToken(session.accessToken);
        await _auth.saveRefreshToken(session.refreshToken);
        await _auth.saveSessionId(session.id);

        // Update the original request with new token
        requestOptions.headers['Authorization'] = 'Bearer ${session.accessToken}';

        // Retry the original request
        final response = await dio.fetch(requestOptions);
        handler.resolve(response);

        // Process all pending requests
        if (_pendingRequests.isNotEmpty) {
          await _processPendingRequests(session.accessToken);
        }
      } catch (e) {
        print("--401 retry error");
        print(e.toString());
        
        // If refresh token endpoint returns 401, logout user
        if (e is DioException && 
            e.response?.statusCode == 401 && 
            e.requestOptions.path == '/auth/session/refresh') {
          print("--Refresh token expired, logging out");
          await _auth.logout();
          router.go("/get_start");
        }
        
        // Refresh failed, reject all pending requests
        if (_pendingRequests.isNotEmpty) {
          _rejectPendingRequests(e);
        }
        handler.reject(err);
      } finally {
        _isRefreshing = false;
      }
    } else {
      return super.onError(err, handler);
    }
  }

  void _queueRequest(RequestOptions options, ErrorInterceptorHandler handler) {
    _pendingRequests.add(_PendingRequest(options, handler));
  }

  Future<void> _processPendingRequests(String newAccessToken) async {
    if (_pendingRequests.isEmpty) return;

    final dio = Dio(BaseOptions(baseUrl: _pendingRequests.first.options.baseUrl));

    for (final pendingRequest in _pendingRequests) {
      try {
        pendingRequest.options.headers['Authorization'] = 'Bearer $newAccessToken';
        final response = await dio.fetch(pendingRequest.options);
        pendingRequest.handler.resolve(response);
      } catch (e) {
        if (e is DioException) {
          pendingRequest.handler.reject(e);
        } else {
          pendingRequest.handler.reject(
            DioException(
              requestOptions: pendingRequest.options,
              error: e,
            ),
          );
        }
      }
    }

    _pendingRequests.clear();
  }

  void _rejectPendingRequests(dynamic error) {
    for (final pendingRequest in _pendingRequests) {
      if (error is DioException) {
        pendingRequest.handler.reject(error);
      } else {
        pendingRequest.handler.reject(
          DioException(
            requestOptions: pendingRequest.options,
            error: error,
          ),
        );
      }
    }
    _pendingRequests.clear();
  }
}

class _PendingRequest {
  final RequestOptions options;
  final ErrorInterceptorHandler handler;

  _PendingRequest(this.options, this.handler);
}

