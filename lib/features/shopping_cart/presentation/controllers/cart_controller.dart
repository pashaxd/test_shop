import 'package:get/get.dart';
import 'package:test_shop/features/shop_feature/data/product_model.dart';
import 'package:test_shop/features/shopping_cart/data/cart_item_model.dart';

class CartController extends GetxController {
  final items = <CartItemModel>[].obs;

  void addToCart(ProductModel product, int selectedSizeIndex) {
    final existingItemIndex = items.indexWhere(
      (item) =>
          item.product.name == product.name &&
          item.selectedSizeIndex == selectedSizeIndex,
    );

    if (existingItemIndex != -1) {
      items[existingItemIndex].quantity++;
      items.refresh();
    } else {
      items.add(
        CartItemModel(
          product: product,
          selectedSizeIndex: selectedSizeIndex,
          quantity: 1,
        ),
      );
    }
  }

  void removeFromCart(int index) {
    if (index >= 0 && index < items.length) {
      items.removeAt(index);
    }
  }

  void updateQuantity(int index, int quantity) {
    if (index >= 0 && index < items.length) {
      if (quantity <= 0) {
        removeFromCart(index);
      } else {
        items[index].quantity = quantity;
        items.refresh();
      }
    }
  }

  double get totalPrice {
    return items.fold(0, (sum, item) {
      final packagingSize = item.product.sizes[item.selectedSizeIndex];
      return sum + (item.product.price * item.quantity * packagingSize);
    });
  }

  bool isInCart(ProductModel product, int selectedSizeIndex) {
    return items.any(
      (item) =>
          item.product.name == product.name &&
          item.selectedSizeIndex == selectedSizeIndex,
    );
  }
}
