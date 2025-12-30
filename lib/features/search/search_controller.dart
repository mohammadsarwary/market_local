import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/category_model.dart';
import 'data/mock_data.dart';

class SearchController extends GetxController {
  final RxString selectedSort = 'Best Match'.obs;
  final Rx<RangeValues> currentRangeValues = const RangeValues(50, 1200).obs;
  
  final TextEditingController minPriceController = TextEditingController(text: '50');
  final TextEditingController maxPriceController = TextEditingController(text: '1200');

  final RxInt selectedCategoryIndex = 0.obs;

  List<String> get filters => SearchMockData.filters;
  final RxList<String> selectedFilters = ['Nearby'].obs;

  List<CategoryModel> get categories => SearchMockData.categories;

  @override
  void onClose() {
    minPriceController.dispose();
    maxPriceController.dispose();
    super.onClose();
  }

  void toggleFilter(String filter, bool selected) {
    if (selected) {
      selectedFilters.add(filter);
    } else {
      selectedFilters.remove(filter);
    }
  }

  void updatePriceRange(RangeValues values) {
    currentRangeValues.value = values;
    minPriceController.text = values.start.round().toString();
    maxPriceController.text = values.end.round().toString();
  }

  void updateSort(String sort) {
    selectedSort.value = sort;
  }

  void resetFilters() {
    selectedFilters.clear();
    selectedSort.value = 'Best Match';
    currentRangeValues.value = const RangeValues(0, 2000);
    minPriceController.text = '0';
    maxPriceController.text = '2000';
  }
}
