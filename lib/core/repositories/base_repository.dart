abstract class BaseRepository {
  Future<T> handleException<T>(Future<T> Function() call) async {
    try {
      return await call();
    } catch (e) {
      rethrow;
    }
  }
}
