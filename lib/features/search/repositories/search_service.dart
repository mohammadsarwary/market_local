import '../../../core/api/api_service.dart';
import '../../../core/repositories/local_data_source_impl.dart';
import '../models/search_request.dart';
import '../models/search_response.dart';
import 'search_repository.dart';
import 'search_repository_impl.dart';

class SearchService {
  static final SearchService _instance = SearchService._internal();

  late SearchRepository _searchRepository;

  SearchService._internal();

  factory SearchService() {
    return _instance;
  }

  static SearchService get instance => _instance;

  void initialize() {
    final apiClient = ApiService.instance.apiClient;
    final localDataSource = LocalDataSourceImpl();
    _searchRepository = SearchRepositoryImpl(
      apiClient: apiClient,
      localDataSource: localDataSource,
    );
  }

  SearchRepository get repository => _searchRepository;

  Future<SearchResponse> search({
    required String query,
    int page = 1,
    int limit = 20,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    String? location,
    double? radius,
    String? sortBy,
    List<String>? tags,
  }) async {
    final request = SearchRequest(
      query: query,
      page: page,
      limit: limit,
      categoryId: categoryId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      location: location,
      radius: radius,
      sortBy: sortBy,
      tags: tags,
    );
    return await _searchRepository.search(request);
  }

  Future<SearchResponse> filterAds({
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    String? location,
    double? radius,
    String? sortBy,
    List<String>? tags,
    int page = 1,
    int limit = 20,
  }) async {
    final request = FilterRequest(
      categoryId: categoryId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      location: location,
      radius: radius,
      sortBy: sortBy,
      tags: tags,
      page: page,
      limit: limit,
    );
    return await _searchRepository.filterAds(request);
  }

  Future<SuggestionsResponse> getSuggestions({
    required String query,
    int limit = 10,
  }) async {
    final request = GetSuggestionsRequest(
      query: query,
      limit: limit,
    );
    return await _searchRepository.getSuggestions(request);
  }

  Future<SaveSearchResponse> saveSearch({
    required String name,
    required String query,
    required Map<String, dynamic> filters,
  }) async {
    final request = SaveSearchRequest(
      name: name,
      query: query,
      filters: filters,
    );
    return await _searchRepository.saveSearch(request);
  }

  Future<SavedSearchesResponse> getSavedSearches({
    int page = 1,
    int limit = 20,
  }) async {
    final request = GetSavedSearchesRequest(
      page: page,
      limit: limit,
    );
    return await _searchRepository.getSavedSearches(request);
  }

  Future<DeleteSearchResponse> deleteSavedSearch(String searchId) async {
    return await _searchRepository.deleteSavedSearch(searchId);
  }

  Future<FavoritesResponse> getFavorites({
    int page = 1,
    int limit = 20,
  }) async {
    return await _searchRepository.getFavorites(page, limit);
  }

  Future<SearchResponse?> getCachedSearchResults(String query) async {
    return await _searchRepository.getCachedSearchResults(query);
  }

  Future<void> clearSearchCache() async {
    await _searchRepository.clearSearchCache();
  }
}
