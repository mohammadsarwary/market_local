import '../../../core/api/api_service.dart';
import '../../../core/repositories/local_data_source_impl.dart';
import '../models/category_response.dart';
import 'category_repository.dart';
import 'category_repository_impl.dart';

class CategoryService {
  static final CategoryService _instance = CategoryService._internal();

  late CategoryRepository _categoryRepository;

  CategoryService._internal();

  factory CategoryService() {
    return _instance;
  }

  static CategoryService get instance => _instance;

  void initialize() {
    final apiClient = ApiService.instance.apiClient;
    final localDataSource = LocalDataSourceImpl();
    _categoryRepository = CategoryRepositoryImpl(
      apiClient: apiClient,
      localDataSource: localDataSource,
    );
  }

  CategoryRepository get repository => _categoryRepository;

  Future<CategoriesResponse> getCategories() async {
    return await _categoryRepository.getCategories();
  }

  Future<Category> getCategoryDetails(String categoryId) async {
    return await _categoryRepository.getCategoryDetails(categoryId);
  }

  Future<SubcategoriesResponse> getSubcategories(String parentCategoryId) async {
    return await _categoryRepository.getSubcategories(parentCategoryId);
  }

  Future<List<Category>?> getCachedCategories() async {
    return await _categoryRepository.getCachedCategories();
  }

  Future<void> clearCategoryCache() async {
    await _categoryRepository.clearCategoryCache();
  }
}
