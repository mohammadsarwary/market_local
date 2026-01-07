import 'package:flutter/material.dart';

// ============================================================================
// Category Domain Models
// ============================================================================
// Contains all models related to categories including:
// - CategoryModel: Main category data model
// - Request models: GetCategoriesRequest, GetCategoryDetailsRequest, etc.
// - Response models: CategoriesResponse, SubcategoriesResponse, etc.
// ============================================================================

// ----------------------------------------------------------------------------
// CategoryModel - Main Category Model
// ----------------------------------------------------------------------------

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

// ----------------------------------------------------------------------------
// Request Models
// ----------------------------------------------------------------------------

/// Request model for fetching categories
class GetCategoriesRequest {
  final bool includeSubcategories;

  GetCategoriesRequest({
    this.includeSubcategories = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'include_subcategories': includeSubcategories,
    };
  }
}

/// Request model for fetching category details
class GetCategoryDetailsRequest {
  final String categoryId;

  GetCategoryDetailsRequest({required this.categoryId});

  Map<String, dynamic> toJson() {
    return {
      'id': categoryId,
    };
  }
}

/// Request model for fetching subcategories
class GetSubcategoriesRequest {
  final String parentCategoryId;

  GetSubcategoriesRequest({required this.parentCategoryId});

  Map<String, dynamic> toJson() {
    return {
      'parent_id': parentCategoryId,
    };
  }
}

// ----------------------------------------------------------------------------
// Response Models
// ----------------------------------------------------------------------------

/// Response model for a single category (API response)
class Category {
  final String id;
  final String name;
  final String? icon;
  final String? description;
  final int adCount;
  final List<Category>? subcategories;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    this.icon,
    this.description,
    required this.adCount,
    this.subcategories,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      icon: json['icon'] as String?,
      description: json['description'] as String?,
      adCount: json['ad_count'] as int? ?? 0,
      subcategories: (json['subcategories'] as List<dynamic>?)
          ?.map((item) => Category.fromJson(item as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'description': description,
      'ad_count': adCount,
      'subcategories': subcategories?.map((cat) => cat.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Response model for categories list
class CategoriesResponse {
  final List<Category> categories;
  final int total;

  CategoriesResponse({
    required this.categories,
    required this.total,
  });

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> categoriesList = [];

    if (json['data'] is List) {
      categoriesList = json['data'] as List<dynamic>;
    } else if (json['data'] is Map) {
      final dataMap = json['data'] as Map<String, dynamic>;
      if (dataMap['categories'] is List) {
        categoriesList = dataMap['categories'] as List<dynamic>;
      } else if (dataMap['data'] is List) {
        categoriesList = dataMap['data'] as List<dynamic>;
      }
    } else if (json['categories'] is List) {
      categoriesList = json['categories'] as List<dynamic>;
    }

    return CategoriesResponse(
      categories: categoriesList
          .map((item) => Category.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? categoriesList.length,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories.map((cat) => cat.toJson()).toList(),
      'total': total,
    };
  }
}

/// Response model for subcategories
class SubcategoriesResponse {
  final List<Category> subcategories;
  final int total;

  SubcategoriesResponse({
    required this.subcategories,
    required this.total,
  });

  factory SubcategoriesResponse.fromJson(Map<String, dynamic> json) {
    return SubcategoriesResponse(
      subcategories: (json['subcategories'] as List<dynamic>)
          .map((item) => Category.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subcategories': subcategories.map((cat) => cat.toJson()).toList(),
      'total': total,
    };
  }
}
