abstract class LocalDataSource {
  Future<dynamic> get(String key);

  Future<void> save(String key, dynamic value);

  Future<void> delete(String key);

  Future<void> clear();

  Future<bool> exists(String key);
}
