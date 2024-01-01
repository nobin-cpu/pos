import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/model/cart/cart_product_model.dart';
import 'package:flutter_prime/data/model/product/product_model.dart';
import 'package:flutter_prime/view/components/alert-dialog/custom_alert_dialog.dart';
import 'package:flutter_prime/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutter_prime/view/screens/category_product_list_screen/widgets/add_to_cart_bottom_sheet.dart';
import 'package:get/get.dart';

class CategoryProductListController extends GetxController {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final TextEditingController productQuantityController = TextEditingController();
  List<ProductModel> productList = [];
  List<ProductModel> uomList = [];
  int quantity = 1;



  @override
  void onInit() {
    super.onInit();
  }

  Future<void> loadProductData(String category) async {
    try {
      await databaseHelper.initializeDatabase();

      productList = await databaseHelper.getProductsByCategory(category);
      update();
    } catch (e) {
      print('Error loading product data: $e');
    }
  }

  Future<void> initData(String category) async {
    await loadProductData(category);
  }

  increaseCartItem() {
    quantity++;
    productQuantityController.text = quantity.toString();
    update();
  }

  decreaseCartItem() {
    quantity--;
    productQuantityController.text = quantity.toString();
    update();
  }

  double totalAmount = 0.0;

  void updateTotalAmount(ProductModel product, int quantity) {
    double price = double.parse(product.price ?? '0.0');
    totalAmount = price * quantity;
    update();
  }

  void showAddToCartBottomSheet(ProductModel product, BuildContext context, int index) {
    totalAmount = double.parse(product.price.toString());
    
    productQuantityController.text = quantity.toString();
    CustomAlertDialog(
      child: AddToCartBottomSheet(index: index),
      actions: [],
    ).customAlertDialog(context);
  }

  Future<void> loadCartData() async {
    try {
      await databaseHelper.initializeDatabase();

      List<CartProductModel> cartItems = await databaseHelper.getCartItems();

      cartItems.forEach((cartItem) {
        print("Cart Item: $cartItem");
      });
    } catch (e) {
      print('Error loading cart data: $e');
    }
  }

Future<void> addToCart(ProductModel product, int quantity) async {
  try {
    await databaseHelper.insertCartItem(product, quantity);
    CustomSnackBar.success(successList: [MyStrings.succesfullyProductAddedToCart]);
    print("Successfully added to cart");

    // Clear the text field and set the value to "1"
    productQuantityController.clear();
    productQuantityController.text = "1";

    // Reset the quantity back to 1
    this.quantity = 1;

    update();
    Get.back();
  } catch (e) {
    CustomSnackBar.error(errorList: [MyStrings.failedToAddToCart]);
    print("Failed to add to cart: $e");
  }
}


}
