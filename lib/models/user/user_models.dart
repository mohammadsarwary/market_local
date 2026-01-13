// ============================================================================
// User Domain Models
// ============================================================================
// Contains all models related to users including:
// - UserModel: Main user data model
// - Request models: UpdateProfileRequest, UpdateAvatarRequest, GetUserAdsRequest, etc.
// - Response models: UserProfile, UpdateProfileResponse, UserAdsResponse, etc.
// ============================================================================

// ----------------------------------------------------------------------------
// UserModel - Main User Model
// ----------------------------------------------------------------------------

/// Model class for User
class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatar;
  final bool isVerified;
  final double rating;
  final int reviewCount;
  final int activeListings;
  final int soldItems;
  final int followers;
  final int following;
  final String location;
  final DateTime createdAt;
  final DateTime? lastActive;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
    this.avatar = '',
    this.isVerified = false,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.activeListings = 0,
    this.soldItems = 0,
    this.followers = 0,
    this.following = 0,
    this.location = '',
    required this.createdAt,
    this.lastActive,
  });

  /// Creates a copy of this UserModel with the given fields replaced
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    bool? isVerified,
    double? rating,
    int? reviewCount,
    int? activeListings,
    int? soldItems,
    int? followers,
    int? following,
    String? location,
    DateTime? createdAt,
    DateTime? lastActive,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      isVerified: isVerified ?? this.isVerified,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      activeListings: activeListings ?? this.activeListings,
      soldItems: soldItems ?? this.soldItems,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
    );
  }

  /// Creates a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
      isVerified: json['is_verified'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] as int? ?? 0,
      activeListings: json['active_listings'] as int? ?? 0,
      soldItems: json['sold_items'] as int? ?? 0,
      followers: json['followers'] as int? ?? 0,
      following: json['following'] as int? ?? 0,
      location: json['location'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      lastActive: json['last_active'] != null
          ? DateTime.parse(json['last_active'] as String)
          : null,
    );
  }

  /// Converts this UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'is_verified': isVerified,
      'rating': rating,
      'review_count': reviewCount,
      'active_listings': activeListings,
      'sold_items': soldItems,
      'followers': followers,
      'following': following,
      'location': location,
      'created_at': createdAt.toIso8601String(),
      'last_active': lastActive?.toIso8601String(),
    };
  }
}

// ----------------------------------------------------------------------------
// Request Models
// ----------------------------------------------------------------------------

/// Request model for updating user profile
class UpdateProfileRequest {
  final String name;
  final String email;
  final String phone;
  final String? bio;
  final String? location;

  UpdateProfileRequest({
    required this.name,
    required this.email,
    required this.phone,
    this.bio,
    this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      if (bio != null) 'bio': bio,
      if (location != null) 'location': location,
    };
  }
}

/// Request model for updating user avatar
class UpdateAvatarRequest {
  final String filePath;

  UpdateAvatarRequest({required this.filePath});
}

/// Request model for fetching user's ads
class GetUserAdsRequest {
  final int page;
  final int limit;
  final String? status;

  GetUserAdsRequest({
    this.page = 1,
    this.limit = 20,
    this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      if (status != null) 'status': status,
    };
  }
}

/// Request model for fetching user's favorites
class GetFavoritesRequest {
  final int page;
  final int limit;

  GetFavoritesRequest({
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

// ----------------------------------------------------------------------------
// Response Models
// ----------------------------------------------------------------------------

/// Response model for user profile
class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;
  final String? bio;
  final String? location;
  final bool isVerified;
  final int totalAds;
  final double rating;
  final int reviewCount;
  final int activeListings;
  final int soldItems;
  final int followers;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
    this.bio,
    this.location,
    required this.isVerified,
    required this.totalAds,
    required this.rating,
    required this.reviewCount,
    required this.activeListings,
    required this.soldItems,
    required this.followers,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return UserProfile(
      id: data['id'].toString(),
      name: data['name'] as String,
      email: data['email'] as String,
      phone: data['phone']?.toString() ?? '',
      avatar: data['avatar'] as String?,
      bio: data['bio'] as String?,
      location: data['location'] as String?,
      isVerified: data['is_verified'] as bool? ?? false,
      totalAds: int.tryParse(data['total_ads']?.toString() ?? data['active_listings']?.toString() ?? '0') ?? 0,
      rating: double.tryParse(data['rating']?.toString() ?? '0') ?? 0.0,
      reviewCount: int.tryParse(data['review_count']?.toString() ?? '0') ?? 0,
      activeListings: int.tryParse(data['active_listings']?.toString() ?? '0') ?? 0,
      soldItems: int.tryParse(data['sold_items']?.toString() ?? '0') ?? 0,
      followers: int.tryParse(data['followers']?.toString() ?? '0') ?? 0,
      createdAt: DateTime.parse(data['created_at'] as String),
      updatedAt: DateTime.parse(data['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'bio': bio,
      'location': location,
      'is_verified': isVerified,
      'total_ads': totalAds,
      'rating': rating,
      'review_count': reviewCount,
      'active_listings': activeListings,
      'sold_items': soldItems,
      'followers': followers,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Response model for updating profile
class UpdateProfileResponse {
  final String message;
  final UserProfile user;

  UpdateProfileResponse({
    required this.message,
    required this.user,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return UpdateProfileResponse(
      message: json['message'] as String? ?? '',
      user: data != null ? UserProfile.fromJson(data) : UserProfile.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user': user.toJson(),
    };
  }
}

/// Response model for avatar upload
class AvatarUploadResponse {
  final String message;
  final String avatarUrl;

  AvatarUploadResponse({
    required this.message,
    required this.avatarUrl,
  });

  factory AvatarUploadResponse.fromJson(Map<String, dynamic> json) {
    return AvatarUploadResponse(
      message: json['message'] as String,
      avatarUrl: json['avatar_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'avatar_url': avatarUrl,
    };
  }
}

/// Response model for user's ads
class UserAdsResponse {
  final List<UserAdItem> ads;
  final int total;
  final int page;
  final int limit;

  UserAdsResponse({
    required this.ads,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory UserAdsResponse.fromJson(Map<String, dynamic> json) {
    return UserAdsResponse(
      ads: (json['ads'] as List<dynamic>)
          .map((item) => UserAdItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      limit: json['limit'] as int,
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

/// Model for a user's ad item
class UserAdItem {
  final String id;
  final String title;
  final String? image;
  final double price;
  final String status;
  final DateTime createdAt;

  UserAdItem({
    required this.id,
    required this.title,
    this.image,
    required this.price,
    required this.status,
    required this.createdAt,
  });

  factory UserAdItem.fromJson(Map<String, dynamic> json) {
    return UserAdItem(
      id: json['id'] as String,
      title: json['title'] as String,
      image: json['image'] as String?,
      price: (json['price'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'price': price,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Response model for user's favorites
class FavoritesResponse {
  final List<FavoriteItem> favorites;
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
          .map((item) => FavoriteItem.fromJson(item as Map<String, dynamic>))
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

/// Model for a favorite item
class FavoriteItem {
  final String id;
  final String title;
  final String? image;
  final double price;
  final String category;
  final DateTime createdAt;

  FavoriteItem({
    required this.id,
    required this.title,
    this.image,
    required this.price,
    required this.category,
    required this.createdAt,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id'] as String,
      title: json['title'] as String,
      image: json['image'] as String?,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'price': price,
      'category': category,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
