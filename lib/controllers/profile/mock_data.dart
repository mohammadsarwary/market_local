import '../../models/user/user_models.dart';
import '../../models/ad/ad_models.dart';

/// Mock data for profile functionality
class ProfileMockData {
  static const String defaultName = 'John Doe';
  static const String defaultEmail = 'john.doe@example.com';
  static const String defaultPhone = '+1 234 567 8900';
  static const String defaultLocation = 'San Francisco, CA';
  static const String appVersion = '1.0.0';
  
  static final UserModel currentUser = UserModel(
    id: '1',
    name: 'John Doe',
    email: 'john.doe@example.com',
    phone: '+1 234 567 8900',
    location: 'San Francisco, CA',
    createdAt: DateTime(2023, 1, 1),
  );
  
  static const List<String> menuItems = [
    'My Ads',
    'Favorites',
    'Messages',
    'Settings',
    'Help & Support',
  ];
  
  static const List<String> tabs = ['Active', 'Sold', 'Draft'];
  
  static final List<AdModel> userItems = [
    AdModel(
      id: '1',
      title: 'iPhone 13',
      description: 'Brand new iPhone 13, 128GB, Blue',
      price: 699,
      images: ['https://images.unsplash.com/photo-1592750475338-74b7b21085ab'],
      categoryId: '1',
      categoryName: 'Electronics',
      sellerId: '1',
      sellerName: 'John Doe',
      location: 'San Francisco, CA',
      createdAt: DateTime.now(),
      condition: AdCondition.newItem,
    ),
    AdModel(
      id: '2',
      title: 'MacBook Pro',
      description: 'MacBook Pro 14", M1 Pro, 16GB RAM, 512GB SSD',
      price: 1299,
      images: ['https://images.unsplash.com/photo-1517336714731-489689fd1ca8'],
      categoryId: '1',
      categoryName: 'Electronics',
      sellerId: '1',
      sellerName: 'John Doe',
      location: 'San Francisco, CA',
      createdAt: DateTime.now(),
      condition: AdCondition.likeNew,
    ),
  ];
}
