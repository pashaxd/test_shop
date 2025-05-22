import 'package:test_shop/features/shop_feature/data/product_model.dart';

class CartItemModel {
  final ProductModel product;
  final int selectedSizeIndex;
  int quantity;

  CartItemModel({
    required this.product,
    required this.selectedSizeIndex,
    this.quantity = 1,
  });

  double get totalPrice =>
      product.price * quantity * product.sizes[selectedSizeIndex];
}
