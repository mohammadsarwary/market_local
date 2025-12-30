import 'package:flutter/material.dart';

/// Model class for Category
class CategoryModel {
  final String id;
  final String name;
  final String? parentId;
  final IconData icon;
  final String? iconUrl;
  final int itemCount;
  final int sortOrder;
  final bool isActive;
  final List<CategoryModel> subcategories;

  const CategoryModel({
    required this.id,
    required this.name,
    this.parentId,
    this.icon = Icons.category,
    this.iconUrl,
    this.itemCount = 0,
    this.sortOrder = 0,
    this.isActive = true,
    this.subcategories = const [],
  });

  /// Creates a copy of this CategoryModel with the given fields replaced
  CategoryModel copyWith({
    String? id,
    String? name,
    String? parentId,
    IconData? icon,
    String? iconUrl,
    int? itemCount,
    int? sortOrder,
    bool? isActive,
    List<CategoryModel>? subcategories,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      icon: icon ?? this.icon,
      iconUrl: iconUrl ?? this.iconUrl,
      itemCount: itemCount ?? this.itemCount,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      subcategories: subcategories ?? this.subcategories,
    );
  }

  /// Creates a CategoryModel from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      parentId: json['parent_id'] as String?,
      icon: _iconFromString(json['icon'] as String?),
      iconUrl: json['icon_url'] as String?,
      itemCount: json['item_count'] as int? ?? 0,
      sortOrder: json['sort_order'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      subcategories: json['subcategories'] != null
          ? (json['subcategories'] as List)
              .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  /// Converts this CategoryModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'parent_id': parentId,
      'icon': _iconToString(icon),
      'icon_url': iconUrl,
      'item_count': itemCount,
      'sort_order': sortOrder,
      'is_active': isActive,
      'subcategories': subcategories.map((e) => e.toJson()).toList(),
    };
  }

  /// Helper to convert icon string to IconData
  static IconData _iconFromString(String? iconName) {
    switch (iconName) {
      case 'car':
        return Icons.directions_car;
      case 'home':
        return Icons.home;
      case 'phone':
        return Icons.phone_android;
      case 'fashion':
        return Icons.checkroom;
      case 'electronics':
        return Icons.devices;
      case 'furniture':
        return Icons.chair;
      case 'sports':
        return Icons.sports_soccer;
      case 'books':
        return Icons.menu_book;
      case 'pets':
        return Icons.pets;
      case 'jobs':
        return Icons.work;
      case 'services':
        return Icons.handyman;
      default:
        return Icons.category;
    }
  }

  /// Helper to convert IconData to string
  static String _iconToString(IconData icon) {
    if (icon == Icons.directions_car) return 'car';
    if (icon == Icons.home) return 'home';
    if (icon == Icons.phone_android) return 'phone';
    if (icon == Icons.checkroom) return 'fashion';
    if (icon == Icons.devices) return 'electronics';
    if (icon == Icons.chair) return 'furniture';
    if (icon == Icons.sports_soccer) return 'sports';
    if (icon == Icons.menu_book) return 'books';
    if (icon == Icons.pets) return 'pets';
    if (icon == Icons.work) return 'jobs';
    if (icon == Icons.handyman) return 'services';
    return 'category';
  }
}
