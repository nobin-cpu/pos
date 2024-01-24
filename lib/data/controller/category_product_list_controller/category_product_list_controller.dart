import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/shared_preference_helper.dart';
import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/model/cart/cart_product_model.dart';
import 'package:flutter_prime/data/model/product/product_model.dart';
import 'package:flutter_prime/view/components/alert-dialog/custom_alert_dialog.dart';
import 'package:flutter_prime/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutter_prime/view/screens/category_product_list_screen/widgets/add_to_cart_aleart_dialogue.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryProductListController extends GetxController {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final TextEditingController productQuantityController = TextEditingController();
  final TextEditingController retailProductQuantityController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  List<ProductModel> productList = [];
  List<ProductModel> uomList = [];
  List<CartProductModel> cartList = [];
  int quantity = 1;

  bool isDiscountInpercent = false;
  String categoryTitle = "";
  String totalCartItems = "";
  @override
  void onInit() {
    super.onInit();
  }

  bool isLoading = false;
  Future<void> loadProductData(String category) async {
    isLoading = true;
    update();
    try {
      await databaseHelper.initializeDatabase();

      productList = await databaseHelper.getProductsByCategory(category);
      cartList = await databaseHelper.getCartItems();
      update();
    } catch (e) {
      print('Error loading product data: $e');
    }
    isLoading = false;
    update();
  }

  Future<void> initData(String category) async {
    await loadProductData(category);
  }

  void increaseInputFieldProductQuantity() {
    quantity++;
    productQuantityController.text = quantity.toString();
    update();
  }

  void decreaseInputFieldProductQuantity() {
    if (quantity > 1) {
      quantity--;
      productQuantityController.text = quantity.toString();
      update();
    }
  }

  double totalAmount = 0.0;

  void updateTotalAmount(int index, dynamic quantity) {
    ProductModel product = productList[index];

    double price = double.parse(product.price ?? '0.0');

    totalAmount = price * quantity;

    update();
  }

  void showAddToCartAlertDialogue(ProductModel product, BuildContext context, int index) {
    totalAmount = double.parse(product.price.toString());

    productQuantityController.text = quantity.toString();
    discountController.text = "";
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

  double previousDiscount = 0.0;
  Future<void> addToCart(ProductModel product, int quantity) async {
    try {
      List<CartProductModel> existingCartItems = await databaseHelper.getCartItems();
      CartProductModel? existingCartItem = existingCartItems.firstWhere(
        (cartItem) => cartItem.productId == product.id,
        orElse: () => CartProductModel(),
      );

      double discount = double.tryParse(discountController.text) ?? 0.0;

      if (existingCartItem != null && existingCartItem.id != null) {
        existingCartItem.quantity = quantity;
        existingCartItem.totalAmount = totalAmount;
        existingCartItem.discountAmount = discount;

        await databaseHelper.updateCartItem(existingCartItem).then((value) => isDiscountInpercent = false);
        // Get.back();
        CustomSnackBar.success(successList: [MyStrings.productUpdatededSuccessfully]);
        update();
      } else {
        print("discount type.............." + isDiscountInpercent.toString());
        await databaseHelper.insertCartItem(product, quantity, totalAmount.toString(), discount, isDiscountInpercent).then((value) => isDiscountInpercent = false);
        // Get.back();
        CustomSnackBar.success(successList: [MyStrings.productAddedSuccessfully]);
        update();
      }

      CustomSnackBar.success(successList: [MyStrings.succesfullyProductAddedToCart]);
      print("Successfully added to cart");

      productQuantityController.clear();
      productQuantityController.text = "1";

      this.quantity = 1;

      update();
      Get.back();
      initData(categoryTitle);
    } catch (e) {
      print(isDiscountInpercent);

      print("discount...........................................");
      CustomSnackBar.error(errorList: [MyStrings.failedToAddToCart]);
      print("Failed to add to cart: $e");
    }
  }

  changediscountCheckBox() {
    isDiscountInpercent = !isDiscountInpercent;
    update();
  }

  double calculateTotalAmount(ProductModel product, int quantity) {
    double price = double.parse(product.price ?? '0.0');
    return price * quantity;
  }

  void updateTotalAmountWithDiscount(ProductModel product, int quantity, double discount) async {
    double price = double.parse(product.price ?? '0.0');
    double totalAmount = price * quantity;
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (isDiscountInpercent) {
      double discountedAmount = totalAmount - (totalAmount * discount / 100);
      this.totalAmount = discountedAmount;
      await preferences.setBool(SharedPreferenceHelper.isDiscountInPercentiseKey, isDiscountInpercent);
      update();
    } else {
      double discountedAmount = totalAmount - discount;
      this.totalAmount = discountedAmount;
      await preferences.setBool(SharedPreferenceHelper.isDiscountInPercentiseKey, isDiscountInpercent);
      update();
    }
    print(".........................................................................");
    update();
  }

  void handleDiscountChange(String value, int index) {
    if (isDiscountInpercent) {
      double discountPercentage = double.tryParse(value) ?? 0;
      updateTotalAmountWithDiscount(productList[index], quantity, discountPercentage);
    } else {
      double directDiscount = double.tryParse(value) ?? 0;
      updateTotalAmountWithDiscount(productList[index], quantity, directDiscount);
    }
  }

  resetFields() {
    quantity = 1;
    update();
  }
}
