import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/haptic_feedback.dart';
import '../models/search_response.dart';
import '../repositories/search_service.dart';

class SearchControllerImpl extends GetxController {
  final SearchService searchService = SearchService.instance;

  final RxString searchQuery = ''.obs;
  final RxList<SearchResult> searchResults = RxList<SearchResult>([]);
  final RxList<SavedSearch> savedSearches = RxList<SavedSearch>([]);
  final RxList<SearchResult> favorites = RxList<SearchResult>([]);
  final RxList<String> suggestions = RxList<String>([]);

  final RxString selectedCategory = ''.obs;
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 10000.0.obs;
  final RxString selectedLocation = ''.obs;
  final RxDouble searchRadius = 50.0.obs;
  final RxString selectedSort = 'newest'.obs;

  final RxBool isLoading = false.obs;
  final RxBool isSearching = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  final RxInt currentPage = 1.obs;
  final RxBool hasMoreResults = true.obs;
  final RxInt totalResults = 0.obs;

  final RxInt favoritesPage = 1.obs;
  final RxBool hasMoreFavorites = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedSearches();
  }

  Future<void> search({bool refresh = false}) async {
    if (searchQuery.value.isEmpty) {
      hasError.value = true;
      errorMessage.value = 'Please enter a search query';
      return;
    }

    try {
      await HapticFeedback.light();
      isSearching.value = true;
      hasError.value = false;
      errorMessage.value = '';

      if (refresh) {
        currentPage.value = 1;
        searchResults.clear();
        hasMoreResults.value = true;
      }

      final response = await searchService.search(
        query: searchQuery.value,
        page: currentPage.value,
        categoryId: selectedCategory.value.isEmpty ? null : selectedCategory.value,
        minPrice: minPrice.value > 0 ? minPrice.value : null,
        maxPrice: maxPrice.value < 10000 ? maxPrice.value : null,
        location: selectedLocation.value.isEmpty ? null : selectedLocation.value,
        radius: searchRadius.value < 50 ? searchRadius.value : null,
        sortBy: selectedSort.value,
      );

      if (refresh) {
        searchResults.value = response.results;
      } else {
        searchResults.addAll(response.results);
      }

      totalResults.value = response.total;
      hasMoreResults.value = (currentPage.value * 20) < response.total;
      currentPage.value++;

      await HapticFeedback.success();
    } catch (e) {
      await HapticFeedback.error();
      hasError.value = true;
      errorMessage.value = _parseError(e);
      Get.snackbar(
        'Search Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
      );
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> getSuggestions() async {
    if (searchQuery.value.isEmpty) {
      suggestions.clear();
      return;
    }

    try {
      final response = await searchService.getSuggestions(
        query: searchQuery.value,
        limit: 10,
      );
      suggestions.value = response.suggestions;
    } catch (e) {
      suggestions.clear();
    }
  }

  Future<void> applyFilters() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      currentPage.value = 1;
      searchResults.clear();
      hasMoreResults.value = true;

      final response = await searchService.filterAds(
        categoryId: selectedCategory.value.isEmpty ? null : selectedCategory.value,
        minPrice: minPrice.value > 0 ? minPrice.value : null,
        maxPrice: maxPrice.value < 10000 ? maxPrice.value : null,
        location: selectedLocation.value.isEmpty ? null : selectedLocation.value,
        radius: searchRadius.value < 50 ? searchRadius.value : null,
        sortBy: selectedSort.value,
      );

      searchResults.value = response.results;
      totalResults.value = response.total;
      hasMoreResults.value = (currentPage.value * 20) < response.total;
      currentPage.value++;

      Get.snackbar(
        'Filters Applied',
        'Found ${response.total} results',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      hasError.value = true;
      errorMessage.value = _parseError(e);
      Get.snackbar(
        'Filter Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveCurrentSearch(String name) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final filters = {
        'category_id': selectedCategory.value,
        'min_price': minPrice.value,
        'max_price': maxPrice.value,
        'location': selectedLocation.value,
        'radius': searchRadius.value,
        'sort_by': selectedSort.value,
      };

      await searchService.saveSearch(
        name: name,
        query: searchQuery.value,
        filters: filters,
      );

      await _loadSavedSearches();

      Get.snackbar(
        'Success',
        'Search saved successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      hasError.value = true;
      errorMessage.value = _parseError(e);
      Get.snackbar(
        'Save Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadSavedSearches() async {
    try {
      final response = await searchService.getSavedSearches();
      savedSearches.value = response.searches;
    } catch (e) {
      savedSearches.clear();
    }
  }

  Future<void> deleteSavedSearch(String searchId) async {
    try {
      await searchService.deleteSavedSearch(searchId);
      await _loadSavedSearches();

      Get.snackbar(
        'Success',
        'Saved search deleted',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete saved search',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
      );
    }
  }

  Future<void> loadFavorites({bool refresh = false}) async {
    try {
      if (refresh) {
        favoritesPage.value = 1;
        favorites.clear();
        hasMoreFavorites.value = true;
      }

      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final response = await searchService.getFavorites(
        page: favoritesPage.value,
        limit: 20,
      );

      if (refresh) {
        favorites.value = response.favorites;
      } else {
        favorites.addAll(response.favorites);
      }

      hasMoreFavorites.value = (favoritesPage.value * 20) < response.total;
      favoritesPage.value++;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = _parseError(e);
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearchQuery(String value) {
    searchQuery.value = value;
    hasError.value = false;
    errorMessage.value = '';
  }

  void updateCategory(String categoryId) {
    selectedCategory.value = categoryId;
  }

  void updatePriceRange(double min, double max) {
    minPrice.value = min;
    maxPrice.value = max;
  }

  void updateLocation(String location) {
    selectedLocation.value = location;
  }

  void updateRadius(double radius) {
    searchRadius.value = radius;
  }

  void updateSort(String sort) {
    selectedSort.value = sort;
  }

  void clearFilters() {
    selectedCategory.value = '';
    minPrice.value = 0.0;
    maxPrice.value = 10000.0;
    selectedLocation.value = '';
    searchRadius.value = 50.0;
    selectedSort.value = 'newest';
  }

  String _parseError(dynamic error) {
    if (error is Exception) {
      final message = error.toString();
      if (message.contains('Connection timeout')) {
        return 'Connection timeout. Please check your internet connection.';
      } else if (message.contains('No results')) {
        return 'No results found. Try adjusting your filters.';
      } else if (message.contains('Validation error')) {
        return 'Please check your search criteria.';
      } else if (message.contains('Exception:')) {
        return message.replaceAll('Exception: ', '');
      }
    }
    return 'An error occurred. Please try again.';
  }
}
