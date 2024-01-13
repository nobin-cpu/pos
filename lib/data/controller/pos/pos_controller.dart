import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/data/model/category/category_model.dart';
import 'package:flutter_prime/data/model/product/product_model.dart';
import 'package:get/get.dart';

class PosController extends GetxController {
  final DatabaseHelper databaseHelper = DatabaseHelper();

  List<CategoryModel> categoryList = [];
  List<ProductModel> productList = [];
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    // loadDropdownData();
  }

  Future<void> loadCategoryData() async {
    isLoading = true;
    update();
    try {
      await databaseHelper.initializeDatabase();

      List<CategoryModel> categoryData = await databaseHelper.getCategoryList();
      categoryList = categoryData;

      // Load products when loading category data
      await loadProductData();

      update();
    } catch (e) {
      print('Error loading dropdown data: $e');
    }
    isLoading = false;
    update();
  }

  Future<void> loadProductData() async {
    try {
      List<ProductModel> productsData = await databaseHelper.getProductList();
      productList = productsData;
    } catch (e) {
      print('Error loading product data: $e');
    }
  }

  Future<void> initData() async {
    await loadProductData();
    await loadCategoryData();
  }
}
