import 'package:cloud_firestore/cloud_firestore.dart';

import 'product_model.dart';

class ShopRepository {
  final FirebaseFirestore _firestore;
  final String _collection = 'products';

  ShopRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<ProductModel>> getAllProducts() async {
    try {
      print('Fetching products from Firestore...');
      final QuerySnapshot snapshot =
          await _firestore.collection(_collection).get();
      print('Firestore response: ${snapshot.docs.length} documents found');

      final products =
          snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            print('Document data: $data');
            return ProductModel.fromJson(data);
          }).toList();

      print('Successfully converted ${products.length} products');
      return products;
    } catch (e) {
      print('Error fetching products: $e');
      throw Exception('Failed to get products: $e');
    }
  }

  Future<ProductModel> getProductById(String id) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) {
        throw Exception('Product not found');
      }
      final data = doc.data() as Map<String, dynamic>;
      return ProductModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to get product: $e');
    }
  }

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final QuerySnapshot snapshot =
          await _firestore
              .collection(_collection)
              .where('category', isEqualTo: category)
              .get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ProductModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get products by category: $e');
    }
  }

  Future<List<ProductModel>> getProductsBySubCategory(
    String subCategory,
  ) async {
    try {
      final QuerySnapshot snapshot =
          await _firestore
              .collection(_collection)
              .where('subCategory', isEqualTo: subCategory)
              .get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ProductModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get products by subcategory: $e');
    }
  }

  Future<void> addProduct(ProductModel product) async {
    try {
      await _firestore.collection(_collection).add(product.toJson());
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  Future<void> updateProduct(String id, ProductModel product) async {
    try {
      await _firestore.collection(_collection).doc(id).update(product.toJson());
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}
