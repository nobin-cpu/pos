import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/model/product/product_model.dart';
import 'package:flutter_prime/view/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:flutter_prime/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutter_prime/view/screens/damage/widgets/damage_stock_update_bottom_sheet.dart';
import 'package:get/get.dart';

class DamageController extends GetxController {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  TextEditingController productNamecontroller = TextEditingController();
  TextEditingController damageAmountController = TextEditingController();
  TextEditingController damageReasonController = TextEditingController();
  List<ProductModel> products = [];
  List<ProductModel> productList = [];
  String selectedProductId = "";
  String productName = "";

  @override
  void onInit() {
    super.onInit();
  }

   showupdateStockBottomSheet(BuildContext context, String productId, String damagedProductName) {
    selectedProductId = productId;
    productName = damagedProductName;
    damageAmountController.clear();
    productNamecontroller.clear();
    damageReasonController.clear();
    update();
    CustomBottomSheet(child: const DamageStockUpdateBottomSheet()).customBottomSheet(context);
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

  Future<void> updateStockQuantity() async {
    try {
      String productId = selectedProductId;
      int damagedProductId = int.parse(selectedProductId);
      int damagedProductAmount = int.parse(damageAmountController.text);
      String stock = await databaseHelper.getProductStock(selectedProductId);
      int damageId = Random().nextInt(90000000) + 10000000;
      update();
      databaseHelper.insertDamageDetails(damageId,productName,DateTime.now().toString(),damagedProductAmount,damagedProductId,damageReasonController.text);
      int newStock = int.parse(stock) - int.parse(damageAmountController.text);
      await updateProductStock(int.parse(productId), newStock.toString());

      print("Updated stock for product $productId: $newStock");

      loadProducts();
      update();
      Get.back();
    } catch (e) {
      print('Error adding damage data: $e');
      CustomSnackBar.error(errorList: ["MyStrings.errorAddingDamageData"]);
    }
  }
 

  Future<void> updateProductStock(int productId, String newStock) async {
    await databaseHelper.initializeDatabase();
    try {
      await databaseHelper.updateProductStock(productId, newStock);
    } catch (e) {
      print('Error updating product stock: $e');
    }
  }

 
}
