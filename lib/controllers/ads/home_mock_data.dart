import 'package:flutter/material.dart';
import '../../models/category/category_models.dart';

/// Mock data for home functionality
class HomeMockData {
  static const String welcomeMessage = 'Welcome to MarketLocal!';
  static const String emptyStateMessage = 'No items found';
  
  static const List<String> featuredCategories = [
    'Electronics',
    'Fashion',
    'Home & Garden',
    'Sports',
    'Vehicles',
    'Books',
    'Toys',
    'Other',
  ];
  
  static List<CategoryModel> get categories => [
    CategoryModel(id: '1', name: 'Electronics', icon: Icons.devices),
    CategoryModel(id: '2', name: 'Fashion', icon: Icons.checkroom),
    CategoryModel(id: '3', name: 'Home & Garden', icon: Icons.home),
    CategoryModel(id: '4', name: 'Sports', icon: Icons.sports_soccer),
    CategoryModel(id: '5', name: 'Vehicles', icon: Icons.directions_car),
  ];
}
