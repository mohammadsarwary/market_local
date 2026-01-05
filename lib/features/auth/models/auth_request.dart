class RegisterRequest {
  final String phone;
  final String password;
  final String name;
  final String email;

  RegisterRequest({
    required this.phone,
    required this.password,
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'password': password,
      'name': name,
      'email': email,
    };
  }
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class RefreshTokenRequest {
  final String refreshToken;

  RefreshTokenRequest({required this.refreshToken});

  Map<String, dynamic> toJson() {
    return {
      'refresh_token': refreshToken,
    };
  }
}

class VerifyOtpRequest {
  final String phone;
  final String otp;

  VerifyOtpRequest({
    required this.phone,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'otp': otp,
    };
  }
}

class ForgotPasswordRequest {
  final String phone;

  ForgotPasswordRequest({required this.phone});

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
    };
  }
}

class ResetPasswordRequest {
  final String phone;
  final String otp;
  final String newPassword;

  ResetPasswordRequest({
    required this.phone,
    required this.otp,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'otp': otp,
      'new_password': newPassword,
    };
  }
}
