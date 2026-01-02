import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_client.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  late ApiClient _apiClient;

  ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  static ApiService get instance => _instance;

  void initialize() {
    const secureStorage = FlutterSecureStorage();
    _apiClient = ApiClient(secureStorage: secureStorage);
    _apiClient.initialize();
  }

  ApiClient get apiClient => _apiClient;

  Future<void> setAuthToken(String token) async {
    await _apiClient.setAuthToken(token);
  }

  Future<void> setRefreshToken(String token) async {
    await _apiClient.setRefreshToken(token);
  }

  Future<String?> getAuthToken() async {
    return await _apiClient.getAuthToken();
  }

  Future<void> clearTokens() async {
    await _apiClient.clearTokens();
  }
}
