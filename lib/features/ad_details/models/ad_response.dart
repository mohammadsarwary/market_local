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
    return Ad(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      categoryId: json['category_id'] as String,
      categoryName: json['category_name'] as String,
      price: (json['price'] as num).toDouble(),
      location: json['location'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      images: List<String>.from(json['images'] as List<dynamic>? ?? []),
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      userAvatar: json['user_avatar'] as String?,
      userRating: (json['user_rating'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'active',
      isFavorite: json['is_favorite'] as bool? ?? false,
      views: json['views'] as int? ?? 0,
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
    return AdsResponse(
      ads: (json['ads'] as List<dynamic>)
          .map((item) => Ad.fromJson(item as Map<String, dynamic>))
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
