class SearchResult {
  final String id;
  final String title;
  final String description;
  final String categoryId;
  final String categoryName;
  final double price;
  final String location;
  final List<String> images;
  final String userId;
  final String userName;
  final double userRating;
  final bool isFavorite;
  final DateTime createdAt;

  SearchResult({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.price,
    required this.location,
    required this.images,
    required this.userId,
    required this.userName,
    required this.userRating,
    required this.isFavorite,
    required this.createdAt,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      categoryId: json['category_id'] as String,
      categoryName: json['category_name'] as String,
      price: (json['price'] as num).toDouble(),
      location: json['location'] as String,
      images: List<String>.from(json['images'] as List<dynamic>? ?? []),
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      userRating: (json['user_rating'] as num?)?.toDouble() ?? 0.0,
      isFavorite: json['is_favorite'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category_id': categoryId,
      'category_name': categoryName,
      'price': price,
      'location': location,
      'images': images,
      'user_id': userId,
      'user_name': userName,
      'user_rating': userRating,
      'is_favorite': isFavorite,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class SearchResponse {
  final List<SearchResult> results;
  final int total;
  final int page;
  final int limit;
  final List<String>? suggestedQueries;

  SearchResponse({
    required this.results,
    required this.total,
    required this.page,
    required this.limit,
    this.suggestedQueries,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      results: (json['results'] as List<dynamic>)
          .map((item) => SearchResult.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      limit: json['limit'] as int,
      suggestedQueries: (json['suggested_queries'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'results': results.map((result) => result.toJson()).toList(),
      'total': total,
      'page': page,
      'limit': limit,
      'suggested_queries': suggestedQueries,
    };
  }
}

class SuggestionsResponse {
  final List<String> suggestions;

  SuggestionsResponse({required this.suggestions});

  factory SuggestionsResponse.fromJson(Map<String, dynamic> json) {
    return SuggestionsResponse(
      suggestions: List<String>.from(json['suggestions'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'suggestions': suggestions,
    };
  }
}

class SavedSearch {
  final String id;
  final String name;
  final String query;
  final Map<String, dynamic> filters;
  final DateTime createdAt;
  final DateTime updatedAt;

  SavedSearch({
    required this.id,
    required this.name,
    required this.query,
    required this.filters,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SavedSearch.fromJson(Map<String, dynamic> json) {
    return SavedSearch(
      id: json['id'] as String,
      name: json['name'] as String,
      query: json['query'] as String,
      filters: json['filters'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'query': query,
      'filters': filters,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class SavedSearchesResponse {
  final List<SavedSearch> searches;
  final int total;
  final int page;
  final int limit;

  SavedSearchesResponse({
    required this.searches,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory SavedSearchesResponse.fromJson(Map<String, dynamic> json) {
    return SavedSearchesResponse(
      searches: (json['searches'] as List<dynamic>)
          .map((item) => SavedSearch.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      limit: json['limit'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'searches': searches.map((search) => search.toJson()).toList(),
      'total': total,
      'page': page,
      'limit': limit,
    };
  }
}

class SaveSearchResponse {
  final String message;
  final SavedSearch search;

  SaveSearchResponse({
    required this.message,
    required this.search,
  });

  factory SaveSearchResponse.fromJson(Map<String, dynamic> json) {
    return SaveSearchResponse(
      message: json['message'] as String,
      search: SavedSearch.fromJson(json['search'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'search': search.toJson(),
    };
  }
}

class DeleteSearchResponse {
  final String message;

  DeleteSearchResponse({required this.message});

  factory DeleteSearchResponse.fromJson(Map<String, dynamic> json) {
    return DeleteSearchResponse(
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}

class FavoritesResponse {
  final List<SearchResult> favorites;
  final int total;
  final int page;
  final int limit;

  FavoritesResponse({
    required this.favorites,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory FavoritesResponse.fromJson(Map<String, dynamic> json) {
    return FavoritesResponse(
      favorites: (json['favorites'] as List<dynamic>)
          .map((item) => SearchResult.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      limit: json['limit'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'favorites': favorites.map((fav) => fav.toJson()).toList(),
      'total': total,
      'page': page,
      'limit': limit,
    };
  }
}
