import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/data/model/cart/cart_product_model.dart';
import 'package:flutter_prime/data/model/category/category_model.dart';
import 'package:flutter_prime/data/model/product/product_model.dart';
import 'package:flutter_prime/data/model/uom/uom_model.dart';
import 'package:flutter_prime/view/components/alert-dialog/custom_alert_dialog.dart';
import 'package:flutter_prime/view/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:flutter_prime/view/screens/cheakout/widgets/cheak_out_product_edit_bottom_sheet.dart';
import 'package:flutter_prime/view/screens/cheakout/widgets/confirm_checkout_pop_up.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CheakoutController extends GetxController {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController uomController = TextEditingController();
  TextEditingController newNameController = TextEditingController();
  TextEditingController newPriceController = TextEditingController();
  final TextEditingController productQuantityController = TextEditingController();
  List<CategoryModel> categoryList = [];
  List<UomModel> uomList = [];
  List<ProductModel> productList = [];
  File? pickedImage;
  File? newPickedImage;
  String newCategory = '';
  String newUom = '';
  int quantity = 1;
  double? totalPric = 0.0;
  String productName = "";
  String price = "";
  String uom = "";

  List<CartProductModel> cartProductList = [];

  Future<void> getCartList() async {
    await databaseHelper.initializeDatabase();
    cartProductList = await databaseHelper.getCartItems();

    update();
  }

  void initData() {
    getCartList();
    loadDropdownData();
  }

  void showEditOrDeleteBottomSheet(
    BuildContext context,
    CartProductModel cartProductModel,
  ) {
    productQuantityController.clear();
    update();
    productName = cartProductModel.name ?? "";
    price = cartProductModel.price ?? "";
    totalPric = double.parse(cartProductModel.totalAmount.toString());
    productQuantityController.text = cartProductModel.quantity.toString();
    quantity = cartProductModel.quantity as int;
    newPickedImage = File(cartProductModel.imagePath ?? "");
    newCategory = cartProductModel.category ?? "";
    newUom = cartProductModel.uom ?? "";
    uom = cartProductModel.uom ?? "";
    update();
    print(quantity);
    print(quantity);
    CustomBottomSheet(
      child: CheckoutProductEditBottomSheet(
        id: int.parse(cartProductModel.id.toString()),
      ),
    ).customBottomSheet(context);
  }

  Future<void> loadDropdownData() async {
    try {
      await databaseHelper.initializeDatabase();

      List<UomModel> uomData = await databaseHelper.getUomList();
      List<CategoryModel> categoryData = await databaseHelper.getCategoryList();

      uomList = uomData;
      categoryList = categoryData;
      print(uomList);
      print("--------------------.............................");
      update();
    } catch (e) {
      print('Error loading dropdown data: $e');
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      pickedImage = File(pickedFile.path);
      newPickedImage = pickedImage;
      update();
    }
  }

  Future<void> editCartItem(int? id) async {
    CartProductModel cartItem = cartProductList.firstWhere((item) => item.id == id);

    cartItem.name = productName;

    cartItem.totalAmount = cartItem.totalAmount;
    cartItem.imagePath = newPickedImage?.path ?? cartItem.imagePath;
    cartItem.category = newCategory;
    cartItem.uom = uomController.text;
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

  void updateTotalAmount(int id, quantity) {
    print("cartItem.totalAmount1");
    CartProductModel cartItem = cartProductList.firstWhere((item) => item.id == id);
    double price = double.parse(cartItem.price ?? '0.0');
    cartItem.totalAmount = price * quantity;
    newPriceController.text = cartItem.totalAmount.toString();
    totalPric = cartItem.totalAmount;

    print(cartItem.totalAmount);
    print("cartItem.totalAmount");
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
    await databaseHelper.insertCheckoutHistory(cartProductList, paymentMethod);
    await databaseHelper.clearCart();

    cartProductList.clear();
    update();

    Get.back();
  }
}
