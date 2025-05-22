import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_shop/features/shop_feature/data/product_model.dart';
import 'package:test_shop/features/shop_feature/presentation/controllers/filter_controller.dart';
import 'package:test_shop/features/shop_feature/presentation/screens/filter_screen.dart';
import 'package:test_shop/features/shop_feature/presentation/widgets/product_card.dart';
import 'package:test_shop/features/shopping_cart/presentation/screens/shopping_cart_screen.dart';
import 'controllers/shop_controller.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShopController());
    final filterController = Get.put(FilterController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.to(() => const FilterScreen());
          },
          icon: Image.asset('assets/shop_screen/filters.png'),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const ShoppingCartScreen());
            },
            icon: Image.asset('assets/shop_screen/korzina.png'),
          ),
        ],
        title: const Text(
          'Каталог товаров',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
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
            Obx(() {
              final selectedCategory = filterController.selectedCategory.value;
              final selectedSubcategory =
                  filterController.selectedSubcategory.value;

              if (selectedCategory == null) return const SizedBox.shrink();

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedSubcategory != null
                            ? '${selectedCategory.name} > ${selectedSubcategory.name}'
                            : selectedCategory.name,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 52, 50, 53),
                        ),
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        filterController.clearFilters();
                      },
                      child: const Text(
                        'Сбросить',
                        style: TextStyle(
                          color: Color.fromARGB(255, 52, 50, 53),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            Expanded(
              child: Obx(() {
                print(
                  'ShopScreen: Building with ${filterController.filteredProducts.length} filtered products',
                );
                print(
                  'ShopScreen: Loading state: ${controller.isLoading.value}',
                );

                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final products = filterController.filteredProducts;

                if (products.isEmpty) {
                  return const Center(
                    child: Text(
                      'Товары не найдены',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(product: product);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
