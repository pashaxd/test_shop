import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_shop/features/shop_feature/presentation/controllers/filter_controller.dart';
import 'package:test_shop/features/shop_feature/presentation/screens/subcategories_screen.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FilterController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF427A5B)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Фильтры',
          style: TextStyle(
            color: Color(0xFF427A5B),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.clearFilters();
              Get.back();
            },
            child: const Text(
              'Сбросить',
              style: TextStyle(color: Color(0xFF427A5B), fontSize: 16),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.categories.isEmpty) {
          return const Center(
            child: Text(
              'Нет доступных категорий',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Color(0xFFF1F8E9)],
            ),
          ),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final category = controller.categories[index];
              return Obx(() {
                final isSelected =
                    controller.selectedCategory.value?.name == category.name;
                return GestureDetector(
                  onTap: () {
                    if (category.subcategories.isNotEmpty) {
                      Get.to(() => SubcategoriesScreen(category: category));
                    } else {
                      controller.selectCategory(category);
                      Get.back();
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? const Color(0xFF427A5B)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color:
                            isSelected
                                ? const Color(0xFF427A5B)
                                : const Color(0xFFE0E0E0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          category.name,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check, color: Colors.white),
                      ],
                    ),
                  ),
                );
              });
            },
          ),
        );
      }),
    );
  }
}
