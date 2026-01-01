import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Service for managing local storage operations
/// 
/// Provides a simple interface for persisting app state across sessions.
/// Uses GetStorage internally for key-value storage.
class StorageService extends GetxController {
  late final GetStorage _box;

  /// Storage keys
  static const String _searchFiltersKey = 'search_filters';
  static const String _searchSortKey = 'search_sort';
  static const String _priceRangeMinKey = 'price_range_min';
  static const String _priceRangeMaxKey = 'price_range_max';
  static const String _favoritesKey = 'favorites';

  @override
  void onInit() {
    super.onInit();
    _box = GetStorage();
  }

  /// Save search filters to storage
  /// 
  /// Persists the list of selected filter names to local storage.
  /// These filters will be automatically loaded when the app restarts.
  /// 
  /// Parameters:
  /// - [filters] List of filter names to save (e.g., ['Nearby', 'New'])
  Future<void> saveSearchFilters(List<String> filters) async {
    await _box.write(_searchFiltersKey, filters);
  }

  /// Load search filters from storage
  /// 
  /// Retrieves the previously saved search filters from local storage.
  /// If no filters have been saved, returns a default list containing 'Nearby'.
  /// 
  /// Returns:
  /// A list of filter names
  List<String> loadSearchFilters() {
    return _box.read<List<dynamic>>(_searchFiltersKey)?.cast<String>() ?? ['Nearby'];
  }

  /// Save search sort option to storage
  /// 
  /// Persists the selected sort option (e.g., 'Best Match', 'Newest').
  /// 
  /// Parameters:
  /// - [sort] The sort option string to save
  Future<void> saveSearchSort(String sort) async {
    await _box.write(_searchSortKey, sort);
  }

  /// Load search sort option from storage
  /// 
  /// Retrieves the previously saved sort option from local storage.
  /// If no sort option has been saved, returns 'Best Match' as default.
  /// 
  /// Returns:
  /// The sort option string
  String loadSearchSort() {
    return _box.read<String>(_searchSortKey) ?? 'Best Match';
  }

  /// Save price range to storage
  /// 
  /// Persists the minimum and maximum price values for filtering.
  /// 
  /// Parameters:
  /// - [min] The minimum price value
  /// - [max] The maximum price value
  Future<void> savePriceRange(double min, double max) async {
    await _box.write(_priceRangeMinKey, min);
    await _box.write(_priceRangeMaxKey, max);
  }

  /// Load price range from storage
  /// 
  /// Retrieves the previously saved price range from local storage.
  /// If no price range has been saved, returns default values (50.0, 1200.0).
  /// 
  /// Returns:
  /// A record containing (min, max) price values
  (double min, double max) loadPriceRange() {
    final min = _box.read<double>(_priceRangeMinKey) ?? 50.0;
    final max = _box.read<double>(_priceRangeMaxKey) ?? 1200.0;
    return (min, max);
  }

  /// Save favorite item IDs to storage
  /// 
  /// Persists the list of favorited product IDs to local storage.
  /// These favorites will be available across app sessions.
  /// 
  /// Parameters:
  /// - [favoriteIds] List of product IDs that are favorited
  Future<void> saveFavorites(List<String> favoriteIds) async {
    await _box.write(_favoritesKey, favoriteIds);
  }

  /// Load favorite item IDs from storage
  /// 
  /// Retrieves the previously saved favorite product IDs from local storage.
  /// If no favorites have been saved, returns an empty list.
  /// 
  /// Returns:
  /// A list of favorited product IDs
  List<String> loadFavorites() {
    return _box.read<List<dynamic>>(_favoritesKey)?.cast<String>() ?? [];
  }

  /// Clear all stored data
  /// 
  /// Removes all data from local storage. This is typically used
  /// during logout or when resetting the app state.
  Future<void> clearAll() async {
    await _box.erase();
  }

  /// Clear search-related data
  /// 
  /// Removes only search-related data (filters, sort, price range)
  /// from local storage while preserving other data like favorites.
  Future<void> clearSearchData() async {
    await _box.remove(_searchFiltersKey);
    await _box.remove(_searchSortKey);
    await _box.remove(_priceRangeMinKey);
    await _box.remove(_priceRangeMaxKey);
  }
}
