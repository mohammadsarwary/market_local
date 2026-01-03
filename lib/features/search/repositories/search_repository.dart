import '../models/search_request.dart';
import '../models/search_response.dart';

abstract class SearchRepository {
  Future<SearchResponse> search(SearchRequest request);

  Future<SearchResponse> filterAds(FilterRequest request);

  Future<SuggestionsResponse> getSuggestions(GetSuggestionsRequest request);

  Future<SaveSearchResponse> saveSearch(SaveSearchRequest request);

  Future<SavedSearchesResponse> getSavedSearches(GetSavedSearchesRequest request);

  Future<DeleteSearchResponse> deleteSavedSearch(String searchId);

  Future<FavoritesResponse> getFavorites(int page, int limit);

  Future<void> cacheSearchResults(String query, SearchResponse response);

  Future<SearchResponse?> getCachedSearchResults(String query);

  Future<void> clearSearchCache();
}
