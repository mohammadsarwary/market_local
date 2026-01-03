class CreateAdRequest {
  final String title;
  final String description;
  final String categoryId;
  final double price;
  final String location;
  final double latitude;
  final double longitude;
  final List<String>? imagePaths;
  final Map<String, dynamic>? customFields;

  CreateAdRequest({
    required this.title,
    required this.description,
    required this.categoryId,
    required this.price,
    required this.location,
    required this.latitude,
    required this.longitude,
    this.imagePaths,
    this.customFields,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category_id': categoryId,
      'price': price,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      if (customFields != null) ...customFields!,
    };
  }
}

class UpdateAdRequest {
  final String adId;
  final String title;
  final String description;
  final String categoryId;
  final double price;
  final String location;
  final double latitude;
  final double longitude;
  final Map<String, dynamic>? customFields;

  UpdateAdRequest({
    required this.adId,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.price,
    required this.location,
    required this.latitude,
    required this.longitude,
    this.customFields,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category_id': categoryId,
      'price': price,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      if (customFields != null) ...customFields!,
    };
  }
}

class GetAdsRequest {
  final int page;
  final int limit;
  final String? categoryId;
  final double? minPrice;
  final double? maxPrice;
  final String? location;
  final double? radius;
  final String? sortBy;

  GetAdsRequest({
    this.page = 1,
    this.limit = 20,
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.location,
    this.radius,
    this.sortBy,
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
    };
  }
}

class MarkAsSoldRequest {
  final String adId;

  MarkAsSoldRequest({required this.adId});

  Map<String, dynamic> toJson() {
    return {
      'id': adId,
    };
  }
}

class ToggleFavoriteRequest {
  final String adId;

  ToggleFavoriteRequest({required this.adId});

  Map<String, dynamic> toJson() {
    return {
      'id': adId,
    };
  }
}
