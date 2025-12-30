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
