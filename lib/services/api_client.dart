import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_constants.dart';
import 'api_interceptors.dart';

class ApiClient {
  late final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  ApiClient({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  void initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        contentType: 'application/json',
        responseType: ResponseType.json,
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    _addInterceptors();
  }

  void _addInterceptors() {
    _dio.interceptors.add(AuthInterceptor(secureStorage: _secureStorage));
    _dio.interceptors.add(LoggingInterceptor());
    _dio.interceptors.add(
      RetryInterceptor(
        maxRetries: ApiConstants.maxRetries,
        retryDelay: ApiConstants.retryDelay,
      ),
    );
  }

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  Future<Response<T>> upload<T>(
    String path, {
    required List<MultipartFile> files,
    Map<String, dynamic>? fields,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final formData = FormData();

      for (final file in files) {
        formData.files.add(MapEntry('images', file));
      }

      if (fields != null) {
        fields.forEach((key, value) {
          formData.fields.add(MapEntry(key, value.toString()));
        });
      }

      final response = await _dio.post<T>(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  Future<void> setAuthToken(String token) async {
    await _secureStorage.write(key: 'access_token', value: token);
  }

  Future<void> setRefreshToken(String token) async {
    await _secureStorage.write(key: 'refresh_token', value: token);
  }

  Future<String?> getAuthToken() async {
    return await _secureStorage.read(key: 'access_token');
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: 'refresh_token');
  }

  Future<void> clearTokens() async {
    await _secureStorage.delete(key: 'access_token');
    await _secureStorage.delete(key: 'refresh_token');
  }

  /// Saves user data to secure storage
  /// Note: Errors are logged but not thrown to prevent login failures
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      await _secureStorage.write(
        key: 'user_data',
        value: jsonEncode(userData),
      );
      print('ApiClient: User data saved successfully');
    } catch (e) {
      print('ApiClient: Error saving user data: $e');
      // Don't throw - allow login to continue even if user data save fails
    }
  }

  /// Retrieves user data from secure storage
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final data = await _secureStorage.read(key: 'user_data');
      if (data != null) {
        return jsonDecode(data) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('ApiClient: Error reading user data: $e');
      return null;
    }
  }

  /// Clears user data from secure storage
  Future<void> clearUserData() async {
    try {
      await _secureStorage.delete(key: 'user_data');
    } catch (e) {
      print('ApiClient: Error clearing user data: $e');
    }
  }

  /// Validates JWT token expiry (supports JWT and Laravel Sanctum tokens)
  bool isTokenValid(String token) {
    try {
      // Check if token is empty
      if (token.isEmpty) {
        print('ApiClient: Empty token');
        return false;
      }

      // Laravel Sanctum format: id|hash (no expiry in token itself)
      // Accept as valid since server handles expiry
      // Check this BEFORE JWT to avoid splitting by wrong separator
      if (token.contains('|')) {
        final parts = token.split('|');
        if (parts.length == 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
          print('ApiClient: Sanctum token accepted (server-side expiry)');
          return true;
        }
      }

      final parts = token.split('.');

      // JWT format: header.payload.signature (3 parts)
      if (parts.length == 3) {
        // Decode JWT payload
        final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
        final decoded = jsonDecode(payload) as Map<String, dynamic>;

        if (decoded['exp'] == null) {
          print('ApiClient: JWT token has no expiry');
          return false;
        }

        final expiryDate = DateTime.fromMillisecondsSinceEpoch(
          (decoded['exp'] as int) * 1000,
        );
        final isValid = expiryDate.isAfter(DateTime.now());

        if (!isValid) {
          print('ApiClient: JWT token expired at $expiryDate');
        }

        return isValid;
      }

      print('ApiClient: Invalid token format');
      return false;
    } catch (e) {
      print('ApiClient: Error validating token: $e');
      return false;
    }
  }

  /// Gets token expiry time
  DateTime? getTokenExpiryTime(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final decoded = jsonDecode(payload) as Map<String, dynamic>;

      if (decoded['exp'] == null) return null;

      return DateTime.fromMillisecondsSinceEpoch(
        (decoded['exp'] as int) * 1000,
      );
    } catch (e) {
      print('ApiClient: Error getting token expiry: $e');
      return null;
    }
  }

  /// Checks if token is about to expire (within 5 minutes)
  bool isTokenExpiringSoon(String token) {
    final expiryTime = getTokenExpiryTime(token);
    if (expiryTime == null) return false;

    final now = DateTime.now();
    final fiveMinutesLater = now.add(const Duration(minutes: 5));

    return expiryTime.isBefore(fiveMinutesLater) && expiryTime.isAfter(now);
  }
}
