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
