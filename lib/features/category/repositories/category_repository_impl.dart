import '../../../core/api/api_client.dart';
import '../../../core/api/api_constants.dart';
import '../../../core/repositories/base_repository.dart';
import '../../../core/repositories/local_data_source.dart';
import '../models/category_response.dart';
import 'category_repository.dart';

class CategoryRepositoryImpl extends BaseRepository implements CategoryRepository {
  final ApiClient apiClient;
  final LocalDataSource localDataSource;

  CategoryRepositoryImpl({
    required this.apiClient,
    required this.localDataSource,
  });

  @override
  Future<CategoriesResponse> getCategories() async {
    return handleException(() async {
      try {
        final response = await apiClient.get(CategoryEndpoints.categories);
        final categoriesResponse = CategoriesResponse.fromJson(response as Map<String, dynamic>);
        await cacheCategories(categoriesResponse.categories);
        return categoriesResponse;
      } catch (e) {
        final cached = await getCachedCategories();
        if (cached != null && cached.isNotEmpty) {
          return CategoriesResponse(categories: cached, total: cached.length);
        }
        rethrow;
      }
    });
  }

  @override
  Future<Category> getCategoryDetails(String categoryId) async {
    return handleException(() async {
      final endpoint = CategoryEndpoints.categoryDetails.replaceAll(':id', categoryId);
      final response = await apiClient.get(endpoint);
      return Category.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<SubcategoriesResponse> getSubcategories(String parentCategoryId) async {
    return handleException(() async {
      final endpoint = CategoryEndpoints.subcategories.replaceAll(':id', parentCategoryId);
      final response = await apiClient.get(endpoint);
      return SubcategoriesResponse.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<void> cacheCategories(List<Category> categories) async {
    return handleException(() async {
      await localDataSource.save(
        'categories',
        categories.map((cat) => cat.toJson()).toList(),
      );
    });
  }

  @override
  Future<List<Category>?> getCachedCategories() async {
    return handleException(() async {
      final cached = await localDataSource.get('categories');
      if (cached != null && cached is List) {
        return cached
            .map((item) => Category.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return null;
    });
  }

  @override
  Future<void> clearCategoryCache() async {
    return handleException(() async {
      await localDataSource.delete('categories');
    });
  }
}
