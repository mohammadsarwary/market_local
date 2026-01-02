import 'package:get_storage/get_storage.dart';
import 'local_data_source.dart';

class LocalDataSourceImpl implements LocalDataSource {
  final GetStorage _storage;

  LocalDataSourceImpl({GetStorage? storage}) : _storage = storage ?? GetStorage();

  @override
  Future<dynamic> get(String key) async {
    try {
      return _storage.read(key);
    } catch (e) {
      throw Exception('Failed to read from local storage: $e');
    }
  }

  @override
  Future<void> save(String key, dynamic value) async {
    try {
      await _storage.write(key, value);
    } catch (e) {
      throw Exception('Failed to save to local storage: $e');
    }
  }

  @override
  Future<void> delete(String key) async {
    try {
      await _storage.remove(key);
    } catch (e) {
      throw Exception('Failed to delete from local storage: $e');
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _storage.erase();
    } catch (e) {
      throw Exception('Failed to clear local storage: $e');
    }
  }

  @override
  Future<bool> exists(String key) async {
    try {
      return _storage.hasData(key);
    } catch (e) {
      throw Exception('Failed to check local storage: $e');
    }
  }
}
