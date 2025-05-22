import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_shop/features/shop_feature/data/product_model.dart';
import 'package:test_shop/features/shopping_cart/presentation/controllers/cart_controller.dart';
import 'package:test_shop/features/shopping_cart/presentation/screens/shopping_cart_screen.dart';

class ProductInfoController extends GetxController {
  final RxInt selectedImageIndex = 0.obs;
  final RxInt selectedSizeIndex = 0.obs;
  final RxInt selectedTabIndex = 0.obs;
  final RxInt itemCount = 0.obs;
  final RxBool isInCart = false.obs;

  void selectImage(int index) {
    selectedImageIndex.value = index;
  }

  void selectSize(int index) {
    selectedSizeIndex.value = index;
  }

  void selectTab(int index) {
    selectedTabIndex.value = index;
  }

  void addToCart(ProductModel product) {
    final cartController = Get.find<CartController>();
    cartController.addToCart(product, selectedSizeIndex.value);
    isInCart.value = true;
    itemCount.value = 1;
  }

  void incrementCount() {
    itemCount.value++;
  }

  void decrementCount() {
    if (itemCount.value > 1) {
      itemCount.value--;
    } else {
      isInCart.value = false;
      itemCount.value = 0;
    }
  }
}

class ProductInfo extends StatelessWidget {
  final ProductModel product;
  const ProductInfo({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductInfoController());
    final cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(product.name),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => const ShoppingCartScreen()),
            icon: Image.asset('assets/shop_screen/korzina.png'),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SizedBox(
                  height: 300,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 80,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30.0),
                          child: ListView.builder(
                            itemCount: product.images.length,
                            itemBuilder: (context, index) {
                              return Obx(
                                () => GestureDetector(
                                  onTap: () => controller.selectImage(index),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12.0,
                                      horizontal: 8.0,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color:
                                              controller
                                                          .selectedImageIndex
                                                          .value ==
                                                      index
                                                  ? const Color(0xFF427A5B)
                                                  : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: Image.network(
                                            product.images[index],
                                            fit: BoxFit.cover,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return Container(
                                                color: Colors.grey[200],
                                                child: const Icon(
                                                  Icons.error_outline,
                                                ),
                                              );
                                            },
                                            loadingBuilder: (
                                              context,
                                              child,
                                              loadingProgress,
                                            ) {
                                              if (loadingProgress == null)
                                                return child;
                                              return const Center(
                                                child: CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(Color(0xFF427A5B)),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Obx(
                            () => ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                product.images[controller
                                    .selectedImageIndex
                                    .value],
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.error_outline,
                                      size: 50,
                                    ),
                                  );
                                },
                                loadingBuilder: (
                                  context,
                                  child,
                                  loadingProgress,
                                ) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF427A5B),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.category,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Выбрать фасовку:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: product.sizes.length,
                        itemBuilder: (context, index) {
                          return Obx(
                            () => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: GestureDetector(
                                onTap: () => controller.selectSize(index),
                                child: Container(
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color:
                                        controller.selectedSizeIndex.value ==
                                                index
                                            ? const Color.fromARGB(
                                              255,
                                              52,
                                              50,
                                              53,
                                            )
                                            : const Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color:
                                          controller.selectedSizeIndex.value ==
                                                  index
                                              ? const Color.fromARGB(
                                                255,
                                                52,
                                                50,
                                                53,
                                              )
                                              : const Color(0xFFE0E0E0),
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${product.sizes[index]}',
                                      style: TextStyle(
                                        color:
                                            controller
                                                        .selectedSizeIndex
                                                        .value ==
                                                    index
                                                ? Colors.white
                                                : const Color.fromARGB(
                                                  255,
                                                  52,
                                                  50,
                                                  53,
                                                ),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => GestureDetector(
                              onTap: () => controller.selectTab(0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color:
                                          controller.selectedTabIndex.value == 0
                                              ? const Color(0xFF427A5B)
                                              : const Color(0xFFE0E0E0),
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Описание',
                                    style: TextStyle(
                                      color:
                                          controller.selectedTabIndex.value == 0
                                              ? const Color(0xFF427A5B)
                                              : const Color(0xFF757575),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Obx(
                            () => GestureDetector(
                              onTap: () => controller.selectTab(1),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color:
                                          controller.selectedTabIndex.value == 1
                                              ? const Color(0xFF427A5B)
                                              : const Color(0xFFE0E0E0),
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Состав',
                                    style: TextStyle(
                                      color:
                                          controller.selectedTabIndex.value == 1
                                              ? const Color(0xFF427A5B)
                                              : const Color(0xFF757575),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () =>
                          controller.selectedTabIndex.value == 0
                              ? Text(
                                product.description,
                                key: const ValueKey('description'),
                                style: const TextStyle(fontSize: 16),
                              )
                              : Text(
                                product.composition,
                                key: const ValueKey('composition'),
                                style: const TextStyle(fontSize: 16),
                              ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 24,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => Text(
                        '\$${product.price.toInt() * (product.sizes[controller.selectedSizeIndex.value])}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Obx(() {
                      final isInCart = cartController.isInCart(
                        product,
                        controller.selectedSizeIndex.value,
                      );
                      return SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child:
                            isInCart
                                ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        final index = cartController.items
                                            .indexWhere(
                                              (item) =>
                                                  item.product.name ==
                                                      product.name &&
                                                  item.selectedSizeIndex ==
                                                      controller
                                                          .selectedSizeIndex
                                                          .value,
                                            );
                                        if (index != -1) {
                                          cartController.updateQuantity(
                                            index,
                                            cartController
                                                    .items[index]
                                                    .quantity -
                                                1,
                                          );
                                        }
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                            255,
                                            52,
                                            50,
                                            53,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Obx(() {
                                      final index = cartController.items
                                          .indexWhere(
                                            (item) =>
                                                item.product.name ==
                                                    product.name &&
                                                item.selectedSizeIndex ==
                                                    controller
                                                        .selectedSizeIndex
                                                        .value,
                                          );
                                      return Text(
                                        '${index != -1 ? cartController.items[index].quantity : 0}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF427A5B),
                                        ),
                                      );
                                    }),
                                    GestureDetector(
                                      onTap: () {
                                        final index = cartController.items
                                            .indexWhere(
                                              (item) =>
                                                  item.product.name ==
                                                      product.name &&
                                                  item.selectedSizeIndex ==
                                                      controller
                                                          .selectedSizeIndex
                                                          .value,
                                            );
                                        if (index != -1) {
                                          cartController.updateQuantity(
                                            index,
                                            cartController
                                                    .items[index]
                                                    .quantity +
                                                1,
                                          );
                                        }
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                            255,
                                            52,
                                            50,
                                            53,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                                : GestureDetector(
                                  onTap: () => controller.addToCart(product),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF427A5B),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'В корзину',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                      );
                    }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Obx(() {
                  final isInCart = cartController.isInCart(
                    product,
                    controller.selectedSizeIndex.value,
                  );
                  return SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: GestureDetector(
                      onTap:
                          isInCart
                              ? () => Get.to(() => const ShoppingCartScreen())
                              : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              isInCart
                                  ? const Color(0xFF427A5B)
                                  : const Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        child: const Center(
                          child: Text(
                            'Заказать',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
