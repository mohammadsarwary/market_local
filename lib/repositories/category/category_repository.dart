import '../../models/category/category_models.dart';

abstract class CategoryRepository {
  Future<CategoriesResponse> getCategories();

  Future<Category> getCategoryDetails(String categoryId);

  Future<SubcategoriesResponse> getSubcategories(String parentCategoryId);

  Future<void> cacheCategories(List<Category> categories);

  Future<List<Category>?> getCachedCategories();

  Future<void> clearCategoryCache();

  // Convenience methods
  Future<CategoriesResponse> getCategoriesWithFallback();
}
