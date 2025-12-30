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
