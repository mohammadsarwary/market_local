import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;

  AuthInterceptor({required this.secureStorage});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await secureStorage.read(key: 'access_token');
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await secureStorage.read(key: 'refresh_token');
      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          final dio = Dio();
          final response = await dio.post(
            'https://market.bazarino.store/api/auth/refresh',
            data: {'refresh_token': refreshToken},
          );

          if (response.statusCode == 200) {
            final newAccessToken = response.data['access_token'];
            final newRefreshToken = response.data['refresh_token'];

            await secureStorage.write(key: 'access_token', value: newAccessToken);
            await secureStorage.write(
              key: 'refresh_token',
              value: newRefreshToken,
            );

            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $newAccessToken';

            return handler.resolve(await _retry(options));
          }
        } catch (e) {
          await secureStorage.delete(key: 'access_token');
          await secureStorage.delete(key: 'refresh_token');
        }
      }
    }
    return handler.next(err);
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return Dio().request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    print('\n╔═══════════════════════════════════════════════════════════════');
    print('║ API REQUEST');
    print('╠═══════════════════════════════════════════════════════════════');
    print('║ Method: ${options.method.toUpperCase()}');
    print('║ URL: ${options.uri}');
    print('║ Headers: ${options.headers}');
    if (options.data != null) {
      print('║ Body: ${options.data}');
    }
    if (options.queryParameters.isNotEmpty) {
      print('║ Query Params: ${options.queryParameters}');
    }
    print('╚═══════════════════════════════════════════════════════════════\n');
    return handler.next(options);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    print('\n╔═══════════════════════════════════════════════════════════════');
    print('║ API RESPONSE');
    print('╠═══════════════════════════════════════════════════════════════');
    print('║ Status: ${response.statusCode} ${response.statusMessage}');
    print('║ URL: ${response.requestOptions.uri}');
    print('║ Data: ${response.data}');
    print('╚═══════════════════════════════════════════════════════════════\n');
    return handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    print('\n╔═══════════════════════════════════════════════════════════════');
    print('║ API ERROR');
    print('╠═══════════════════════════════════════════════════════════════');
    print('║ Type: ${err.type}');
    print('║ Message: ${err.message}');
    print('║ URL: ${err.requestOptions.uri}');
    if (err.response != null) {
      print('║ Status: ${err.response!.statusCode} ${err.response!.statusMessage}');
      print('║ Data: ${err.response!.data}');
    }
    print('╚═══════════════════════════════════════════════════════════════\n');
    return handler.next(err);
  }
}

class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor({
    required this.maxRetries,
    required this.retryDelay,
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_shouldRetry(err) && _getRetryCount(err) < maxRetries) {
      _incrementRetryCount(err);

      await Future.delayed(retryDelay);

      try {
        final response = await _retry(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        return handler.next(err);
      }
    }
    return handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      return true;
    }

    if (err.response != null) {
      final statusCode = err.response!.statusCode;
      return statusCode == 408 || statusCode == 429 || statusCode == 500;
    }

    return false;
  }

  int _getRetryCount(DioException err) {
    return (err.requestOptions.extra['retryCount'] as int?) ?? 0;
  }

  void _incrementRetryCount(DioException err) {
    err.requestOptions.extra['retryCount'] = _getRetryCount(err) + 1;
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return Dio().request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
