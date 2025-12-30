import 'package:flutter/material.dart';
import '../../../models/category_model.dart';

/// Mock data for Search feature
class SearchMockData {
  SearchMockData._();

  static const List<String> filters = ['Nearby', 'New Arrival', 'Free Shipping'];

  static const List<String> sortOptions = ['Best Match', 'Newest', 'Lowest Price'];

  static final List<CategoryModel> categories = [
    const CategoryModel(
      id: 'tech',
      name: 'Tech',
      icon: Icons.devices,
      itemCount: 38,
    ),
    const CategoryModel(
      id: 'home',
      name: 'Home',
      icon: Icons.chair_outlined,
      itemCount: 31,
    ),
    const CategoryModel(
      id: 'style',
      name: 'Style',
      icon: Icons.checkroom,
      itemCount: 27,
    ),
    const CategoryModel(
      id: 'auto',
      name: 'Auto',
      icon: Icons.directions_car_outlined,
      itemCount: 42,
    ),
    const CategoryModel(
      id: 'sports',
      name: 'Sports',
      icon: Icons.fitness_center,
      itemCount: 18,
    ),
    const CategoryModel(
      id: 'books',
      name: 'Books',
      icon: Icons.menu_book,
      itemCount: 15,
    ),
    const CategoryModel(
      id: 'music',
      name: 'Music',
      icon: Icons.music_note,
      itemCount: 12,
    ),
    const CategoryModel(
      id: 'more',
      name: 'More',
      icon: Icons.grid_view,
      itemCount: 0,
    ),
  ];
}
