import 'package:get/get.dart';
import '../../data/product_model.dart';
import '../../data/repo.dart';
import 'package:test_shop/features/shop_feature/presentation/controllers/filter_controller.dart';

class ShopController extends GetxController {
  final ShopRepository _repository = ShopRepository();
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      print('ShopController: Starting to load products');
      isLoading.value = true;
      final loadedProducts = await _repository.getAllProducts();
      print('ShopController: Loaded ${loadedProducts.length} products');
      products.value = loadedProducts;

      // Передаем продукты в FilterController
      final filterController = Get.find<FilterController>();
      filterController.setProducts(products);

      print('ShopController: Updated products list');
    } catch (e) {
      print('ShopController: Error loading products - $e');
      Get.snackbar(
        'Ошибка',
        'Не удалось загрузить товары',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
      print('ShopController: Finished loading products');
    }
  }
}
