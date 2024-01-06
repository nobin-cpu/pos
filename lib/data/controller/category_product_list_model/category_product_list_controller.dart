import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/model/cart/cart_product_model.dart';
import 'package:flutter_prime/data/model/product/product_model.dart';
import 'package:flutter_prime/view/components/alert-dialog/custom_alert_dialog.dart';
import 'package:flutter_prime/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutter_prime/view/screens/category_product_list_screen/widgets/add_to_cart_aleart_dialogue.dart';
import 'package:get/get.dart';

class CategoryProductListController extends GetxController {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final TextEditingController productQuantityController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  List<ProductModel> productList = [];
  List<ProductModel> uomList = [];
  List<CartProductModel> cartList = [];
  int quantity = 1;
  bool percentDiscount = false;
  String categoryTitle = "";
  String totalCartItems = "";
  @override
  void onInit() {
    super.onInit();
  }

  Future<void> loadProductData(String category) async {
    try {
      await databaseHelper.initializeDatabase();

      productList = await databaseHelper.getProductsByCategory(category);
      cartList = await databaseHelper.getCartItems();
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
    CustomAlertDialog(child: AddToCartAlertDialogue(index: index), actions: []).customAlertDialog(context);
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
      await databaseHelper.insertCartItem(product, quantity, totalAmount.toString());
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

  changeRememberMe() {
    percentDiscount = !percentDiscount;
    update();
  }

  double calculateTotalAmount(ProductModel product, int quantity) {
    double price = double.parse(product.price ?? '0.0');
    return price * quantity;
  }

  void updateTotalAmountWithDiscount(ProductModel product, int quantity, double discount) {
    double price = double.parse(product.price ?? '0.0');
    double totalAmount = price * quantity;

    if (percentDiscount) {
      double discountedAmount = totalAmount - (totalAmount * discount / 100);
      this.totalAmount = discountedAmount;
    } else {
      double discountedAmount = totalAmount - discount;
      this.totalAmount = discountedAmount;
    }

    update();
  }

  void handleDiscountChange(String value, int index) {
    if (percentDiscount) {
      double discountPercentage = double.tryParse(value) ?? 0;
      updateTotalAmountWithDiscount(productList[index], quantity, discountPercentage);
    } else {
      double directDiscount = double.tryParse(value) ?? 0;
      updateTotalAmountWithDiscount(productList[index], quantity, directDiscount);
    }
  }
}
