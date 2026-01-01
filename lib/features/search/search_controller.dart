import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/category_model.dart';
import '../../core/utils/haptic_feedback.dart';
import '../../core/services/storage_service.dart';
import 'data/mock_data.dart';

/// Controller for managing search functionality and filters
/// 
/// This controller handles all search-related state including:
/// - Search query input
/// - Price range filtering
/// - Category selection
/// - Sort options
/// - Filter toggles
/// 
/// The controller provides a comprehensive search experience with multiple
/// filtering options and maintains all state reactively using GetX observables.
/// 
/// Usage:
/// ```dart
/// final controller = Get.put(SearchController());
/// 
/// // Search for items
/// controller.searchController.text = "laptop";
/// 
/// // Update price range
/// controller.updatePriceRange(RangeValues(100, 500));
/// 
/// // Toggle filters
/// controller.toggleFilter("Nearby", true);
/// ```
class SearchController extends GetxController {
  /// Loading state for search operations
  final RxBool isLoading = false.obs;

  /// Error state for search operations
  final RxBool hasError = false.obs;

  /// Error message to display
  final RxString errorMessage = ''.obs;

  /// Storage service for persisting filter state
  late final StorageService _storageService;

  /// Controller for the search text input field
  /// 
  /// Use this to get or set the current search query.
  /// The UI should listen to changes on this controller to update search results.
  final TextEditingController searchController = TextEditingController();

  /// Currently selected sort option
  /// 
  /// Defaults to 'Best Match'. Use [updateSort] to change the sorting.
  /// Available options typically include: 'Best Match', 'Newest', 'Lowest Price'
  final RxString selectedSort = 'Best Match'.obs;

  /// Current price range selection
  /// 
  /// Represents the min and max price values selected by the user.
  /// Use [updatePriceRange] to modify this value.
  final Rx<RangeValues> currentRangeValues = const RangeValues(50, 1200).obs;
  
  /// Controller for the minimum price input field
  /// 
  /// Automatically synchronized with [currentRangeValues].start
  final TextEditingController minPriceController = TextEditingController(text: '50');

  /// Controller for the maximum price input field
  /// 
  /// Automatically synchronized with [currentRangeValues].end
  final TextEditingController maxPriceController = TextEditingController(text: '1200');

  /// Currently selected category index
  /// 
  /// Defaults to 0 (all categories). Used to filter search results by category.
  final RxInt selectedCategoryIndex = 0.obs;

  /// List of available filter options
  /// 
  /// Returns mock data from [SearchMockData.filters].
  /// These are the filter options that users can toggle on/off.
  List<String> get filters => SearchMockData.filters;

  /// List of currently active filters
  /// 
  /// Contains the filters that are currently applied to the search.
  /// Use [toggleFilter] to add or remove filters from this list.
  final RxList<String> selectedFilters = ['Nearby'].obs;

  /// List of available categories for filtering
  /// 
  /// Returns mock data from [SearchMockData.categories].
  /// These categories can be used to filter search results.
  List<CategoryModel> get categories => SearchMockData.categories;

  /// Disposes of all controllers when the controller is removed
  /// 
  /// This is important to prevent memory leaks. Always call super.onClose()
  /// after disposing custom controllers.
  @override
  void onInit() {
    super.onInit();
    _storageService = Get.find<StorageService>();
    _loadPersistedState();
  }

  /// Load persisted filter state from storage
  void _loadPersistedState() {
    final savedFilters = _storageService.loadSearchFilters();
    final savedSort = _storageService.loadSearchSort();
    final (min, max) = _storageService.loadPriceRange();

    selectedFilters.assignAll(savedFilters);
    selectedSort.value = savedSort;
    currentRangeValues.value = RangeValues(min, max);
    minPriceController.text = min.round().toString();
    maxPriceController.text = max.round().toString();
  }

  /// Save current filter state to storage
  Future<void> _saveFilterState() async {
    await _storageService.saveSearchFilters(selectedFilters.toList());
    await _storageService.saveSearchSort(selectedSort.value);
    await _storageService.savePriceRange(
      currentRangeValues.value.start,
      currentRangeValues.value.end,
    );
  }

  /// Toggles a filter on or off
  /// 
  /// Adds or removes a filter from [selectedFilters] based on the [selected] parameter.
  /// 
  /// Parameters:
  /// - [filter] The filter name to toggle
  /// - [selected] Whether the filter should be active (true) or inactive (false)
  /// 
  /// Example:
  /// ```dart
  /// controller.toggleFilter("Nearby", true); // Add filter
  /// controller.toggleFilter("Nearby", false); // Remove filter
  /// ```
  void toggleFilter(String filter, bool selected) {
    if (selected) {
      selectedFilters.add(filter);
    } else {
      selectedFilters.remove(filter);
    }
    _saveFilterState();
  }

  /// Updates the price range and synchronizes text controllers
  /// 
  /// Updates [currentRangeValues] and updates the text in both price
  /// input controllers to reflect the new range.
  /// 
  /// Parameters:
  /// - [values] The new price range values
  /// 
  /// Example:
  /// ```dart
  /// controller.updatePriceRange(RangeValues(100, 500));
  /// ```
  void updatePriceRange(RangeValues values) {
    currentRangeValues.value = values;
    minPriceController.text = values.start.round().toString();
    maxPriceController.text = values.end.round().toString();
    _saveFilterState();
  }

  /// Updates the selected sort option
  /// 
  /// Changes the [selectedSort] to the provided [sort] option.
  /// 
  /// Parameters:
  /// - [sort] The sort option to select (e.g., 'Best Match', 'Newest', 'Lowest Price')
  /// 
  /// Example:
  /// ```dart
  /// controller.updateSort('Newest');
  /// ```
  void updateSort(String sort) {
    selectedSort.value = sort;
    _saveFilterState();
  }

  /// Resets all filters to their default state
  /// 
  /// Clears all selected filters, resets sort to 'Best Match',
  /// and resets price range to the full range (0-2000).
  /// 
  /// Example:
  /// ```dart
  /// controller.resetFilters(); // All filters cleared
  /// ```
  void resetFilters() {
    selectedFilters.clear();
    selectedSort.value = 'Best Match';
    currentRangeValues.value = const RangeValues(0, 2000);
    minPriceController.text = '0';
    maxPriceController.text = '2000';
    _saveFilterState();
  }

  @override
  void onClose() {
    searchController.dispose();
    minPriceController.dispose();
    maxPriceController.dispose();
    super.onClose();
  }

  /// Performs a search with current filters
  /// 
  /// Simulates a search operation with loading and error states.
  /// In a real app, this would call an API to fetch search results.
  Future<void> performSearch() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // In a real app, this would fetch search results from an API
      await HapticFeedback.success();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Search failed. Please try again.';
      await HapticFeedback.error();
    } finally {
      isLoading.value = false;
    }
  }

  /// Retries the last search operation
  /// 
  /// Clears error state and performs the search again.
  Future<void> retrySearch() async {
    await performSearch();
  }
}
