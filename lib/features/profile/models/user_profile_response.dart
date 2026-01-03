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
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      avatar: json['avatar'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      totalAds: json['total_ads'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
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
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class UpdateProfileResponse {
  final String message;
  final UserProfile user;

  UpdateProfileResponse({
    required this.message,
    required this.user,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponse(
      message: json['message'] as String,
      user: UserProfile.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user': user.toJson(),
    };
  }
}

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
