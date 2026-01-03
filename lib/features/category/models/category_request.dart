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

class GetCategoryDetailsRequest {
  final String categoryId;

  GetCategoryDetailsRequest({required this.categoryId});

  Map<String, dynamic> toJson() {
    return {
      'id': categoryId,
    };
  }
}

class GetSubcategoriesRequest {
  final String parentCategoryId;

  GetSubcategoriesRequest({required this.parentCategoryId});

  Map<String, dynamic> toJson() {
    return {
      'parent_id': parentCategoryId,
    };
  }
}
