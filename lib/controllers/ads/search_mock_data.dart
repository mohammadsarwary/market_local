import 'package:flutter/material.dart';
import '../../models/category/category_models.dart';

/// Mock data for search functionality
class SearchMockData {
  static const List<String> recentSearches = [
    'iPhone 13',
    'MacBook Pro',
    'Gaming Chair',
    'Nike Shoes',
  ];
  
  static const List<String> popularCategories = [
    'Electronics',
    'Fashion',
    'Home & Garden',
    'Sports',
    'Vehicles',
  ];
  
  static const List<String> priceRanges = [
    'Under 50',
    '50 - 100',
    '100 - 500',
    '500 - 1000',
    'Over 1000',
  ];
  
  static const List<String> sortOptions = [
    'Newest First',
    'Price: Low to High',
    'Price: High to Low',
    'Most Popular',
  ];
  
  static const List<String> filters = [
    'New',
    'Used',
    'Free Shipping',
    'Local',
  ];
  
  static List<CategoryModel> get categories => [
    CategoryModel(id: '1', name: 'All', icon: Icons.apps),
    CategoryModel(id: '2', name: 'Electronics', icon: Icons.devices),
    CategoryModel(id: '3', name: 'Fashion', icon: Icons.checkroom),
    CategoryModel(id: '4', name: 'Home', icon: Icons.home),
    CategoryModel(id: '5', name: 'Sports', icon: Icons.sports_soccer),
    CategoryModel(id: '6', name: 'Vehicles', icon: Icons.directions_car),
  ];
}
