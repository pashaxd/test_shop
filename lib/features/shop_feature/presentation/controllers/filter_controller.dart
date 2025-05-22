import 'package:get/get.dart';
import '../../data/category_model.dart';
import '../../data/product_model.dart';

class FilterController extends GetxController {
  final RxList<ProductModel> filteredProducts = <ProductModel>[].obs;
  final RxList<ProductModel> _allProducts = <ProductModel>[].obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);
  final Rx<SubcategoryModel?> selectedSubcategory = Rx<SubcategoryModel?>(null);

  @override
  void onInit() {
    super.onInit();
    print('FilterController: Initialized');
  }

  void setProducts(List<ProductModel> products) {
    print('Setting ${products.length} products');
    _allProducts.value = products;
    _generateCategoriesFromProducts();
    applyFilters();
  }

  void selectCategory(CategoryModel? category) {
    print('Selecting category: ${category?.name}');
    selectedCategory.value = category;
    selectedSubcategory.value = null;
    applyFilters();
  }

  void selectSubcategory(SubcategoryModel? subcategory) {
    print('Selecting subcategory: ${subcategory?.name}');
    selectedSubcategory.value = subcategory;
    applyFilters();
  }

  void clearFilters() {
    print('Clearing all filters');
    selectedCategory.value = null;
    selectedSubcategory.value = null;
    applyFilters();
  }

  void applyFilters() {
    print('Applying filters...');
    print('Selected category: ${selectedCategory.value?.name}');
    print('Selected subcategory: ${selectedSubcategory.value?.name}');

    if (selectedCategory.value == null) {
      filteredProducts.value = _allProducts;
      print(
        'No category selected, showing all products: ${filteredProducts.length}',
      );
      return;
    }

    var filtered =
        _allProducts.where((product) {
          final matchesCategory =
              product.category == selectedCategory.value?.name;
          final matchesSubcategory =
              selectedSubcategory.value == null
                  ? true
                  : product.subcategory == selectedSubcategory.value?.name;

          print('Product: ${product.name}');
          print('Category match: $matchesCategory');
          print('Subcategory match: $matchesSubcategory');

          return matchesCategory && matchesSubcategory;
        }).toList();

    filteredProducts.value = filtered;
    print('Filtered products count: ${filteredProducts.length}');
  }

  void _generateCategoriesFromProducts() {
    print('Generating categories from products...');
    final categoryMap = <String, List<String>>{};

    for (var product in _allProducts) {
      if (product.category != null) {
        if (!categoryMap.containsKey(product.category)) {
          categoryMap[product.category!] = [];
        }
        if (product.subcategory != null &&
            !categoryMap[product.category!]!.contains(product.subcategory)) {
          categoryMap[product.category!]!.add(product.subcategory!);
        }
      }
    }

    categories.value =
        categoryMap.entries.map((entry) {
          return CategoryModel(
            name: entry.key,
            subcategories:
                entry.value.map((subName) {
                  return SubcategoryModel(name: subName);
                }).toList(),
          );
        }).toList();

    print('Generated ${categories.length} categories');
    for (var category in categories) {
      print(
        'Category: ${category.name} with ${category.subcategories.length} subcategories',
      );
    }
  }
}
