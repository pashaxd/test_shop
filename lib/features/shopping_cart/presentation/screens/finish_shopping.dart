import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:test_shop/features/shop_feature/presentation/shop_screen.dart';
import 'package:test_shop/features/shopping_cart/presentation/controllers/cart_controller.dart';
import 'package:test_shop/features/shopping_cart/presentation/screens/shopping_cart_screen.dart';

class FinishShoppingScreen extends StatelessWidget {
  const FinishShoppingScreen({super.key});

  String getRandomImage() {
    final random = Random();
    final images = ['assets/finish/people.png', 'assets/finish/preson.png'];
    return images[random.nextInt(images.length)];
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF427A5B)),
            onPressed: () {
              cartController.items.clear();
              Get.offAll(() => const ShopScreen());
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color(0xFFF1F8E9),
              Color.fromARGB(255, 236, 245, 237),
            ],
          ),
        ),
        child: Column(
          children: [
            Image.asset(getRandomImage()),
            const Text(
              'Заказ оформлен успешно!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
