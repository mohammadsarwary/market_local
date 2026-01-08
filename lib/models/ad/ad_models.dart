// ============================================================================
// Ad Domain Models
// ============================================================================
// Contains all models related to advertisements including:
// - AdModel: Main advertisement data model
// - Request models: CreateAdRequest, UpdateAdRequest, GetAdsRequest, etc.
// - Response models: AdsResponse, CreateAdResponse, UpdateAdResponse, etc.
// ============================================================================

// ----------------------------------------------------------------------------
// AdModel - Main Advertisement Model
// ----------------------------------------------------------------------------

/// Model class for Advertisement/Listing
class AdModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String currency;
  final List<String> images;
  final String categoryId;
  final String categoryName;
  final String sellerId;
  final String sellerName;
  final String sellerAvatar;
  final bool isSellerVerified;
  final String location;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isPromoted;
  final bool isSold;
  final bool isFavorite;
  final int viewCount;
  final AdCondition condition;

  const AdModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.currency = 'USD',
    required this.images,
    required this.categoryId,
    required this.categoryName,
    required this.sellerId,
    required this.sellerName,
    this.sellerAvatar = '',
    this.isSellerVerified = false,
    required this.location,
    this.latitude,
    this.longitude,
    required this.createdAt,
    this.updatedAt,
    this.isPromoted = false,
    this.isSold = false,
    this.isFavorite = false,
    this.viewCount = 0,
    this.condition = AdCondition.used,
  });

  /// Creates a copy of this AdModel with the given fields replaced
  AdModel copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? currency,
    List<String>? images,
    String? categoryId,
    String? categoryName,
    String? sellerId,
    String? sellerName,
    String? sellerAvatar,
    bool? isSellerVerified,
    String? location,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPromoted,
    bool? isSold,
    bool? isFavorite,
    int? viewCount,
    AdCondition? condition,
  }) {
    return AdModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      images: images ?? this.images,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      sellerAvatar: sellerAvatar ?? this.sellerAvatar,
      isSellerVerified: isSellerVerified ?? this.isSellerVerified,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPromoted: isPromoted ?? this.isPromoted,
      isSold: isSold ?? this.isSold,
      isFavorite: isFavorite ?? this.isFavorite,
      viewCount: viewCount ?? this.viewCount,
      condition: condition ?? this.condition,
    );
  }

  /// Creates an AdModel from JSON
  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      images: List<String>.from(json['images'] as List),
      categoryId: json['category_id'] as String,
      categoryName: json['category_name'] as String,
      sellerId: json['seller_id'] as String,
      sellerName: json['seller_name'] as String,
      sellerAvatar: json['seller_avatar'] as String? ?? '',
      isSellerVerified: json['is_seller_verified'] as bool? ?? false,
      location: json['location'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      isPromoted: json['is_promoted'] as bool? ?? false,
      isSold: json['is_sold'] as bool? ?? false,
      isFavorite: json['is_favorite'] as bool? ?? false,
      viewCount: json['view_count'] as int? ?? 0,
      condition: AdCondition.values.firstWhere(
        (e) => e.name == json['condition'],
        orElse: () => AdCondition.used,
      ),
    );
  }

  /// Converts this AdModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'currency': currency,
      'images': images,
      'category_id': categoryId,
      'category_name': categoryName,
      'seller_id': sellerId,
      'seller_name': sellerName,
      'seller_avatar': sellerAvatar,
      'is_seller_verified': isSellerVerified,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_promoted': isPromoted,
      'is_sold': isSold,
      'is_favorite': isFavorite,
      'view_count': viewCount,
      'condition': condition.name,
    };
  }
}

/// Enum for item condition
enum AdCondition {
  newItem,
  likeNew,
  used,
  fair,
  forParts,
}

/// Extension for AdCondition display names
extension AdConditionExtension on AdCondition {
  String get displayName {
    switch (this) {
      case AdCondition.newItem:
        return 'New';
      case AdCondition.likeNew:
        return 'Like New';
      case AdCondition.used:
        return 'Used';
      case AdCondition.fair:
        return 'Fair';
      case AdCondition.forParts:
        return 'For Parts';
    }
  }
}

// ----------------------------------------------------------------------------
// Request Models
// ----------------------------------------------------------------------------

/// Request model for creating a new advertisement
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

/// Request model for updating an existing advertisement
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

/// Request model for fetching advertisements with filters
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

/// Request model for marking an ad as sold
class MarkAsSoldRequest {
  final String adId;

  MarkAsSoldRequest({required this.adId});

  Map<String, dynamic> toJson() {
    return {
      'id': adId,
    };
  }
}

/// Request model for toggling favorite status
class ToggleFavoriteRequest {
  final String adId;

  ToggleFavoriteRequest({required this.adId});

  Map<String, dynamic> toJson() {
    return {
      'id': adId,
    };
  }
}

// ----------------------------------------------------------------------------
// Response Models
// ----------------------------------------------------------------------------

/// Response model for a single advertisement (API response)
class Ad {
  final String id;
  final String title;
  final String description;
  final String categoryId;
  final String categoryName;
  final double price;
  final String location;
  final double latitude;
  final double longitude;
  final List<String> images;
  final String userId;
  final String userName;
  final String? userAvatar;
  final double userRating;
  final String status;
  final bool isFavorite;
  final int views;
  final DateTime createdAt;
  final DateTime updatedAt;

  Ad({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.price,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.images,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.userRating,
    required this.status,
    required this.isFavorite,
    required this.views,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Ad.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    final category = json['category'] as Map<String, dynamic>?;

    double parseNum(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return Ad(
      id: json['id'].toString(),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      categoryId: json['category_id']?.toString() ?? category?['id']?.toString() ?? '',
      categoryName: json['category_name'] as String? ?? category?['name'] as String? ?? '',
      price: parseNum(json['price']),
      location: json['location'] as String? ?? '',
      latitude: parseNum(json['latitude']),
      longitude: parseNum(json['longitude']),
      images: json['images'] != null
          ? List<String>.from(json['images'] as List<dynamic>)
          : (json['primary_image'] != null ? [json['primary_image'] as String] : []),
      userId: json['user_id']?.toString() ?? user?['id']?.toString() ?? '',
      userName: json['user_name'] as String? ?? user?['name'] as String? ?? '',
      userAvatar: json['user_avatar'] as String? ?? user?['avatar'] as String?,
      userRating: parseNum(json['user_rating'] ?? user?['rating']),
      status: json['status'] as String? ?? 'active',
      isFavorite: json['is_favorite'] as bool? ?? false,
      views: json['views'] is int ? json['views'] as int : int.tryParse(json['views']?.toString() ?? '0') ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
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
      'latitude': latitude,
      'longitude': longitude,
      'images': images,
      'user_id': userId,
      'user_name': userName,
      'user_avatar': userAvatar,
      'user_rating': userRating,
      'status': status,
      'is_favorite': isFavorite,
      'views': views,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Response model for paginated ads list
class AdsResponse {
  final List<Ad> ads;
  final int total;
  final int page;
  final int limit;

  AdsResponse({
    required this.ads,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory AdsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    
    return AdsResponse(
      ads: (data['ads'] as List<dynamic>?)
          ?.map((item) => Ad.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      total: data['total'] as int? ?? (data['ads'] as List?)?.length ?? 0,
      page: data['page'] as int? ?? 1,
      limit: data['limit'] as int? ?? 20,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ads': ads.map((ad) => ad.toJson()).toList(),
      'total': total,
      'page': page,
      'limit': limit,
    };
  }
}

/// Response model for creating an ad
class CreateAdResponse {
  final String message;
  final Ad ad;

  CreateAdResponse({
    required this.message,
    required this.ad,
  });

  factory CreateAdResponse.fromJson(Map<String, dynamic> json) {
    return CreateAdResponse(
      message: json['message'] as String,
      ad: Ad.fromJson(json['ad'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'ad': ad.toJson(),
    };
  }
}

/// Response model for updating an ad
class UpdateAdResponse {
  final String message;
  final Ad ad;

  UpdateAdResponse({
    required this.message,
    required this.ad,
  });

  factory UpdateAdResponse.fromJson(Map<String, dynamic> json) {
    return UpdateAdResponse(
      message: json['message'] as String,
      ad: Ad.fromJson(json['ad'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'ad': ad.toJson(),
    };
  }
}

/// Response model for deleting an ad
class DeleteAdResponse {
  final String message;

  DeleteAdResponse({required this.message});

  factory DeleteAdResponse.fromJson(Map<String, dynamic> json) {
    return DeleteAdResponse(
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}

/// Response model for marking an ad as sold
class MarkAsSoldResponse {
  final String message;
  final Ad ad;

  MarkAsSoldResponse({
    required this.message,
    required this.ad,
  });

  factory MarkAsSoldResponse.fromJson(Map<String, dynamic> json) {
    return MarkAsSoldResponse(
      message: json['message'] as String,
      ad: Ad.fromJson(json['ad'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'ad': ad.toJson(),
    };
  }
}

/// Response model for toggling favorite status
class ToggleFavoriteResponse {
  final String message;
  final bool isFavorite;

  ToggleFavoriteResponse({
    required this.message,
    required this.isFavorite,
  });

  factory ToggleFavoriteResponse.fromJson(Map<String, dynamic> json) {
    return ToggleFavoriteResponse(
      message: json['message'] as String,
      isFavorite: json['is_favorite'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'is_favorite': isFavorite,
    };
  }
}

/// Response model for image upload
class ImageUploadResponse {
  final String message;
  final List<String> imageUrls;

  ImageUploadResponse({
    required this.message,
    required this.imageUrls,
  });

  factory ImageUploadResponse.fromJson(Map<String, dynamic> json) {
    return ImageUploadResponse(
      message: json['message'] as String,
      imageUrls: List<String>.from(json['image_urls'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'image_urls': imageUrls,
    };
  }
}
