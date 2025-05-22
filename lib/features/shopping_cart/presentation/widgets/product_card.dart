import 'package:flutter/material.dart';
import 'package:test_shop/features/shop_feature/data/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Image.network(product.images[0]),
          Text(product.name),
          Text(product.price.toString()),
        ],
      ),
    );
  }
}
