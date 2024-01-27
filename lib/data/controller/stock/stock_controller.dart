import 'package:flutter/widgets.dart';
import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/model/product/product_model.dart';
import 'package:flutter_prime/view/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:flutter_prime/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutter_prime/view/screens/stock/widgets/update_stock_bottom_sheet.dart';
import 'package:get/get.dart';

class StockController extends GetxController {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  TextEditingController productNamecontroller = TextEditingController();
  TextEditingController stockcontroller = TextEditingController();
  List<ProductModel> products = [];
  List<ProductModel> productList = [];
  String selectedProductId = "";

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> loadProducts() async {
    await databaseHelper.initializeDatabase();
    productList.clear();
    products.clear();
    update();

    try {
      products = await databaseHelper.getProductList();
      productList.add(ProductModel(name: MyStrings.selectOne, id: -1));
      productList.addAll(products);
      print("this is product List=============================================== ${productList.length}");
      update();
    } catch (e) {
      print('Error loading product data: $e');
    }
  }

  updateStockQuantity() async {
    try {
      String productId = selectedProductId;
      String stock = await databaseHelper.getProductStock(selectedProductId);

      int newStock = int.parse(stock) + int.parse(stockcontroller.text);
      await updateProductStock(int.parse(productId), newStock.toString());

      print("Updated stock for product $productId: $newStock");

      loadProducts();
      update();
      Get.back();
    } catch (e) {
      print('Error completing checkout: $e');
      CustomSnackBar.error(errorList: [MyStrings.accountName]);
    }
  }

  Future<void> updateProductStock(int productId, String newStock) async {
    try {
      await databaseHelper.updateProductStock(productId, newStock);
    } catch (e) {
      print('Error updating product stock: $e');
    }
  }

  showupdateStockBottomSheet(BuildContext context) {
    stockcontroller.clear();
    productNamecontroller.clear();
    CustomBottomSheet(child: const UpdateStockBottomSheet()).customBottomSheet(context);
  }
}
