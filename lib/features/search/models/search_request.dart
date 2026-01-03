class SearchRequest {
  final String query;
  final int page;
  final int limit;
  final String? categoryId;
  final double? minPrice;
  final double? maxPrice;
  final String? location;
  final double? radius;
  final String? sortBy;
  final List<String>? tags;

  SearchRequest({
    required this.query,
    this.page = 1,
    this.limit = 20,
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.location,
    this.radius,
    this.sortBy,
    this.tags,
  });

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'page': page,
      'limit': limit,
      if (categoryId != null) 'category_id': categoryId,
      if (minPrice != null) 'min_price': minPrice,
      if (maxPrice != null) 'max_price': maxPrice,
      if (location != null) 'location': location,
      if (radius != null) 'radius': radius,
      if (sortBy != null) 'sort_by': sortBy,
      if (tags != null && tags!.isNotEmpty) 'tags': tags,
    };
  }
}

class FilterRequest {
  final String? categoryId;
  final double? minPrice;
  final double? maxPrice;
  final String? location;
  final double? radius;
  final String? sortBy;
  final List<String>? tags;
  final int page;
  final int limit;

  FilterRequest({
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.location,
    this.radius,
    this.sortBy,
    this.tags,
    this.page = 1,
    this.limit = 20,
  });

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      if (categoryId != null) 'category_id': categoryId,
      if (minPrice != null) 'min_price': minPrice,
      if (maxPrice != null) 'max_price': maxPrice,
      if (location != null) 'location': location,
      if (radius != null) 'radius': radius,
      if (sortBy != null) 'sort_by': sortBy,
      if (tags != null && tags!.isNotEmpty) 'tags': tags,
    };
  }
}

class GetSuggestionsRequest {
  final String query;
  final int limit;

  GetSuggestionsRequest({
    required this.query,
    this.limit = 10,
  });

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'limit': limit,
    };
  }
}

class SaveSearchRequest {
  final String name;
  final String query;
  final Map<String, dynamic> filters;

  SaveSearchRequest({
    required this.name,
    required this.query,
    required this.filters,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'query': query,
      'filters': filters,
    };
  }
}

class GetSavedSearchesRequest {
  final int page;
  final int limit;

  GetSavedSearchesRequest({
    this.page = 1,
    this.limit = 20,
  });

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
    };
  }
}
