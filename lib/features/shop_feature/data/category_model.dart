class CategoryModel {
  final String name;
  final List<SubcategoryModel> subcategories;

  CategoryModel({required this.name, required this.subcategories});
}

class SubcategoryModel {
  final String name;

  SubcategoryModel({required this.name});
}
