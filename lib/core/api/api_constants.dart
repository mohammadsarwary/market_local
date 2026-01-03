class ApiConstants {
  static const String baseUrl = 'https://market.bazarino.store/api';

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);
}

class AuthEndpoints {
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';
}

class UserEndpoints {
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String uploadAvatar = '/user/avatar';
  static const String userAds = '/user/ads';
  static const String favorites = '/user/favorites';
  static const String settings = '/user/settings';
}

class AdEndpoints {
  static const String ads = '/ads';
  static const String createAd = '/ads';
  static const String adDetails = '/ads/:id';
  static const String updateAd = '/ads/:id';
  static const String deleteAd = '/ads/:id';
  static const String uploadImages = '/ads/:id/images';
  static const String markAsSold = '/ads/:id/mark-sold';
  static const String toggleFavorite = '/ads/:id/favorite';
}

class CategoryEndpoints {
  static const String categories = '/categories';
  static const String categoryDetails = '/categories/:id';
  static const String subcategories = '/categories/:id/subcategories';
}

class SearchEndpoints {
  static const String search = '/search';
  static const String filter = '/search/filter';
  static const String suggestions = '/search/suggestions';
  static const String saveSearch = '/search/saved';
  static const String savedSearches = '/search/saved';
  static const String deleteSavedSearch = '/search/saved/:id';
  static const String favorites = '/search/favorites';
}

class ChatEndpoints {
  static const String conversations = '/chat/conversations';
  static const String messages = '/chat/conversations/:id/messages';
  static const String sendMessage = '/chat/conversations/:id/messages';
  static const String markAsRead = '/chat/conversations/:id/mark-read';
  static const String uploadImage = '/chat/conversations/:id/upload-image';
}

class NotificationEndpoints {
  static const String notifications = '/notifications';
  static const String markAsRead = '/notifications/:id/read';
  static const String deleteNotification = '/notifications/:id';
  static const String preferences = '/notifications/preferences';
  static const String registerFcm = '/notifications/fcm-token';
}
