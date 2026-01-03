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

class UpdateAvatarRequest {
  final String filePath;

  UpdateAvatarRequest({required this.filePath});
}

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
