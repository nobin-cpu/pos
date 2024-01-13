
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/data/model/cart/cart_product_model.dart';
import 'package:flutter_prime/data/model/category/category_model.dart';
import 'package:flutter_prime/data/model/product/product_model.dart';
import 'package:flutter_prime/data/model/uom/uom_model.dart';
import 'package:flutter_prime/view/components/alert-dialog/custom_alert_dialog.dart';
import 'package:flutter_prime/view/screens/cheakout/widgets/confirm_checkout_pop_up.dart';
import 'package:flutter_prime/view/screens/cheakout/widgets/edit_check_out_product_alart_dialogue.dart';
import 'package:get/get.dart';

class CheakoutController extends GetxController {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController uomController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  TextEditingController newNameController = TextEditingController();
  TextEditingController newPriceController = TextEditingController();
  final TextEditingController productQuantityController = TextEditingController();
  List<CategoryModel> categoryList = [];
  List<UomModel> uomList = [];
  List<ProductModel> productList = [];
  int quantity = 1;
  double? totalProductPrice = 0.0;
  String productName = "";
  String price = "";
  String uom = "";
  bool? percentDiscount = false;

  List<CartProductModel> cartProductList = [];
  bool isDiscountInpercent = false;
  Future<void> getCartList() async {
    await databaseHelper.initializeDatabase();
    cartProductList = await databaseHelper.getCartItems();

    update();
  }

  void initData() async {
    getCartList();
    loadDropdownData();
    // await getDiscountInpercentOrNot();
  }

  void showEditOrDeleteBottomSheet(
    BuildContext context,
    CartProductModel cartProductModel,
  ) {
    productQuantityController.clear();
    update();
    productName = cartProductModel.name ?? "";
    price = cartProductModel.price ?? "";
    totalProductPrice = double.parse(cartProductModel.totalAmount.toString());
    productQuantityController.text = cartProductModel.quantity.toString();
    quantity = cartProductModel.quantity as int;
    uom = cartProductModel.uom ?? "";
    percentDiscount = cartProductModel.isDiscountInPercent == '0'? false : true;

    update();
  }

  Future<void> loadDropdownData() async {
    try {
      await databaseHelper.initializeDatabase();

      List<UomModel> uomData = await databaseHelper.getUomList();
      List<CategoryModel> categoryData = await databaseHelper.getCategoryList();

      uomList = uomData;
      categoryList = categoryData;
      print(uomList);

      update();
    } catch (e) {
      print('Error loading dropdown data: $e');
    }
  }

  Future<void> editCartItem(int? id) async {
    CartProductModel cartItem = cartProductList.firstWhere((item) => item.id == id);

    cartItem.name = productName;
    cartItem.totalAmount = totalProductPrice;
    cartItem.uom = uom;
    cartItem.quantity = quantity;

    await databaseHelper.updateCartItem(cartItem);
    print("cart updated succesfully" + cartItem.totalAmount.toString());
    await getCartList();
    update();
  }

  Future<void> deleteCartItem(int? id) async {
    await databaseHelper.deleteCartItem(id);

    await getCartList();
    update();
  }

  void productEditDialog(
    BuildContext context,
    CartProductModel cartProductModel,
  ) {
    productQuantityController.clear();
    update();
    productName = cartProductModel.name ?? "";
    price = cartProductModel.price ?? "";
    totalProductPrice = double.parse(cartProductModel.totalAmount.toString());
    productQuantityController.text = cartProductModel.quantity.toString();
    quantity = cartProductModel.quantity as int;
    uom = cartProductModel.uom ?? "";

    //init discount

    update();
    print(quantity);
    print(quantity);
    CustomAlertDialog(
      child: EditCheakoutProductAlartDialogue(
        id: int.parse(cartProductModel.id.toString()),
      ),
      actions: [],
    ).customAlertDialog(context);
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

  void updateTotalAmount() {
    print("-------------updateTotalAmount called");

    double productPrice = double.parse(price ?? '0.0');
    double totalProductAmount = productPrice * quantity;

    double discount = double.tryParse(discountController.text) ?? 0.0;
    double discountedAmount = 0.0;

    print('-------is discount in percent${discount}');
    print('-------is discount in percent${isDiscountInpercent}');
    print('-------is total product amount${totalProductAmount}');

    if (isDiscountInpercent) {
      discountedAmount = totalProductAmount - (totalProductAmount * discount / 100);
    } else {
      discountedAmount = totalProductAmount - discount;
    }

    totalProductPrice = discountedAmount;

    print('-------------updateTotalAmount final value: $totalProductPrice');

    update();
  }

  int get totalCount => cartProductList.length;

  double get totalPrice {
    return cartProductList.fold(0.0, (sum, item) => sum + (item.totalAmount ?? 0.0));
  }

  void showConfirmPopUp(
    BuildContext context,
  ) {
    CustomAlertDialog(child: ConfirmCheckoutPopUp(), actions: []).customAlertDialog(context);
  }

  Future<void> completeCheckout(String paymentMethod) async {
    await databaseHelper.insertCheckoutHistory(cartProductList, paymentMethod,generateUniqueId());
    await databaseHelper.clearCart();

    cartProductList.clear();
    update();

    Get.back();
  }
int generateUniqueId() {
  Random random = Random();
  int id = 0;

  for (int i = 0; i < 9; i++) {
    id += random.nextInt(10);
  }

  return id;
}


  // getDiscountInpercentOrNot() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   percentDiscount = preferences.getBool(SharedPreferenceHelper.isDiscountInPercentiseKey)!;
  // }

  changeDiscountCheckBox() {
    isDiscountInpercent = !isDiscountInpercent;
    update();
  }

  void handleDiscountChange(String value) {
    double discount = double.tryParse(value) ?? 0.0;
    updateTotalAmount();
    update();
  }

  double calculateTotalPrice() {
    return cartProductList.fold(0.0, (sum, item) => sum + (item.totalAmount ?? 0.0));
  }
}
