import '../../../core/api/api_client.dart';
import '../../../core/api/api_constants.dart';
import '../../../core/repositories/base_repository.dart';
import '../../../core/repositories/local_data_source.dart';
import '../models/search_request.dart';
import '../models/search_response.dart';
import 'search_repository.dart';

class SearchRepositoryImpl extends BaseRepository implements SearchRepository {
  final ApiClient apiClient;
  final LocalDataSource localDataSource;

  SearchRepositoryImpl({
    required this.apiClient,
    required this.localDataSource,
  });

  @override
  Future<SearchResponse> search(SearchRequest request) async {
    return handleException(() async {
      try {
        final response = await apiClient.get(
          SearchEndpoints.search,
          queryParameters: request.toJson(),
        );
        final searchResponse = SearchResponse.fromJson(response as Map<String, dynamic>);
        await cacheSearchResults(request.query, searchResponse);
        return searchResponse;
      } catch (e) {
        final cached = await getCachedSearchResults(request.query);
        if (cached != null) {
          return cached;
        }
        rethrow;
      }
    });
  }

  @override
  Future<SearchResponse> filterAds(FilterRequest request) async {
    return handleException(() async {
      final response = await apiClient.get(
        SearchEndpoints.filter,
        queryParameters: request.toJson(),
      );
      return SearchResponse.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<SuggestionsResponse> getSuggestions(GetSuggestionsRequest request) async {
    return handleException(() async {
      final response = await apiClient.get(
        SearchEndpoints.suggestions,
        queryParameters: request.toJson(),
      );
      return SuggestionsResponse.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<SaveSearchResponse> saveSearch(SaveSearchRequest request) async {
    return handleException(() async {
      final response = await apiClient.post(
        SearchEndpoints.saveSearch,
        data: request.toJson(),
      );
      return SaveSearchResponse.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<SavedSearchesResponse> getSavedSearches(GetSavedSearchesRequest request) async {
    return handleException(() async {
      final response = await apiClient.get(
        SearchEndpoints.savedSearches,
        queryParameters: request.toJson(),
      );
      return SavedSearchesResponse.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<DeleteSearchResponse> deleteSavedSearch(String searchId) async {
    return handleException(() async {
      final endpoint = SearchEndpoints.deleteSavedSearch.replaceAll(':id', searchId);
      final response = await apiClient.delete(endpoint);
      return DeleteSearchResponse.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<FavoritesResponse> getFavorites(int page, int limit) async {
    return handleException(() async {
      final response = await apiClient.get(
        SearchEndpoints.favorites,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      return FavoritesResponse.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<void> cacheSearchResults(String query, SearchResponse response) async {
    return handleException(() async {
      await localDataSource.save('search_$query', response.toJson());
    });
  }

  @override
  Future<SearchResponse?> getCachedSearchResults(String query) async {
    return handleException(() async {
      final cached = await localDataSource.get('search_$query');
      if (cached != null) {
        return SearchResponse.fromJson(cached as Map<String, dynamic>);
      }
      return null;
    });
  }

  @override
  Future<void> clearSearchCache() async {
    return handleException(() async {
      await localDataSource.delete('search_cache');
    });
  }
}
