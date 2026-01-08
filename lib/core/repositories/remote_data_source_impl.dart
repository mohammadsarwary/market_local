import 'package:dio/dio.dart';
import 'package:market_local/services/api_client.dart';

import 'remote_data_source.dart';

class RemoteDataSourceImpl implements RemoteDataSource {
  final ApiClient apiClient;

  RemoteDataSourceImpl({required this.apiClient});

  @override
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await apiClient.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<dynamic> post(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await apiClient.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<dynamic> put(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await apiClient.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<dynamic> patch(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await apiClient.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<dynamic> delete(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await apiClient.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<dynamic> upload(String endpoint, {required List<String> filePaths, Map<String, dynamic>? fields}) async {
    try {
      final files = <MultipartFile>[];
      for (final filePath in filePaths) {
        files.add(await MultipartFile.fromFile(filePath));
      }

      final response = await apiClient.upload(
        endpoint,
        files: files,
        fields: fields,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Connection timeout. Please check your internet connection.');
      case DioExceptionType.sendTimeout:
        return Exception('Send timeout. Please try again.');
      case DioExceptionType.receiveTimeout:
        return Exception('Receive timeout. Please try again.');
      case DioExceptionType.badResponse:
        return Exception(_handleStatusCode(e.response?.statusCode));
      case DioExceptionType.cancel:
        return Exception('Request cancelled.');
      case DioExceptionType.unknown:
        return Exception('An unexpected error occurred. Please try again.');
      default:
        return Exception('An error occurred: ${e.message}');
    }
  }

  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please log in again.';
      case 403:
        return 'Forbidden. You do not have permission.';
      case 404:
        return 'Not found. The resource does not exist.';
      case 409:
        return 'Conflict. The resource already exists.';
      case 422:
        return 'Validation error. Please check your input.';
      case 429:
        return 'Too many requests. Please try again later.';
      case 500:
        return 'Server error. Please try again later.';
      case 502:
        return 'Bad gateway. Please try again later.';
      case 503:
        return 'Service unavailable. Please try again later.';
      default:
        return 'An error occurred (Code: $statusCode). Please try again.';
    }
  }
}
