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
  static const String me = '/auth/me';
}

class UserEndpoints {
  static const String profile = '/users/profile';
  static const String updateProfile = '/users/profile';
  static const String uploadAvatar = '/users/avatar';
  static const String changePassword = '/users/change-password';
  static const String deleteAccount = '/users/account';
  static const String favorites = '/users/favorites';
  static const String userAds = '/users/ads';
  static const String getUserProfile = '/users/{user}';
  static const String getUserAds = '/users/{user}/ads';
}

class AdEndpoints {
  static const String ads = '/ads';
  static const String createAd = '/ads';
  static const String adDetails = '/ads/{ad}';
  static const String updateAd = '/ads/{ad}';
  static const String deleteAd = '/ads/{ad}';
  static const String uploadImages = '/ads/{ad}/images';
  static const String markAsSold = '/ads/{ad}/sold';
  static const String toggleFavorite = '/ads/{ad}/favorite';
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
