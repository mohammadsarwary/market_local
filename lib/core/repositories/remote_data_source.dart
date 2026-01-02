abstract class RemoteDataSource {
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParameters});

  Future<dynamic> post(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters});

  Future<dynamic> put(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters});

  Future<dynamic> patch(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters});

  Future<dynamic> delete(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters});

  Future<dynamic> upload(String endpoint, {required List<String> filePaths, Map<String, dynamic>? fields});
}
