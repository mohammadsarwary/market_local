class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final UserData user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    print('AuthResponse.fromJson: Parsing response: $json');
    // Handle wrapped API response format: {success, message, data: {...}}
    final data = json['data'] as Map<String, dynamic>? ?? json;
    print('AuthResponse.fromJson: Data extracted: $data');
    
    final accessToken = data['access_token'] as String?;
    final refreshToken = data['refresh_token'] as String?;
    final userData = data['user'] as Map<String, dynamic>?;
    
    if (accessToken == null || refreshToken == null || userData == null) {
      print('AuthResponse.fromJson: Missing required fields');
      throw Exception('Invalid response format: missing required fields');
    }
    
    print('AuthResponse.fromJson: Creating UserData from: $userData');
    final user = UserData.fromJson(userData);
    print('AuthResponse.fromJson: UserData created: ${user.name}');
    
    return AuthResponse(
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: user,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'user': user.toJson(),
    };
  }
}

class UserData {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;
  final bool isVerified;
  final DateTime createdAt;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
    required this.isVerified,
    required this.createdAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone']?.toString() ?? '',
      avatar: json['avatar'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'is_verified': isVerified,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class RefreshTokenResponse {
  final String accessToken;
  final String refreshToken;

  RefreshTokenResponse({
    required this.accessToken,
    required this.refreshToken,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }
}

class OtpResponse {
  final String message;
  final int expiresIn;

  OtpResponse({
    required this.message,
    required this.expiresIn,
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      message: json['message'] as String,
      expiresIn: json['expires_in'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'expires_in': expiresIn,
    };
  }
}

class LogoutResponse {
  final String message;

  LogoutResponse({required this.message});

  factory LogoutResponse.fromJson(Map<String, dynamic> json) {
    return LogoutResponse(
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
