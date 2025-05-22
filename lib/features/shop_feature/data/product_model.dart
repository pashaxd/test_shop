class ProductModel {
  final String name;
  final String category;
  final String subcategory;
  final String description;
  final String composition;
  final double price;
  final List<String> images;
  final List<double> sizes;

  ProductModel({
    required this.name,
    required this.category,
    required this.subcategory,
    required this.description,
    required this.composition,
    required this.price,
    required this.images,
    required this.sizes,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Handle both 'size' and 'sizes' fields
    final dynamic sizeData = json['sizes'] ?? json['size'];
    List<double> sizesList = [];

    if (sizeData != null) {
      if (sizeData is List) {
        sizesList = sizeData.map((e) => double.parse(e.toString())).toList();
      } else if (sizeData is num) {
        sizesList = [sizeData.toDouble()];
      }
    }

    return ProductModel(
      name: json['name'] as String,
      category: json['category'] as String,
      subcategory: json['subcategory'] as String? ?? '',
      description: json['description'] as String,
      composition: json['composition'] as String,
      price: (json['price'] as num).toDouble(),
      images: List<String>.from(json['images'] as List),
      sizes: sizesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'subcategory': subcategory,
      'description': description,
      'composition': composition,
      'price': price,
      'images': images,
      'sizes': sizes,
    };
  }
}
