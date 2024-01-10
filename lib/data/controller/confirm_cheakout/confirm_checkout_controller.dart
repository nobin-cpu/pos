import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/shared_preference_helper.dart';
import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/model/cart/cart_product_model.dart';
import 'package:flutter_prime/data/model/category/category_model.dart';
import 'package:flutter_prime/data/model/product/product_model.dart';
import 'package:flutter_prime/data/model/uom/uom_model.dart';
import 'package:flutter_prime/view/components/alert-dialog/custom_alert_dialog.dart';
import 'package:flutter_prime/view/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:flutter_prime/view/components/buttons/rounded_button.dart';
import 'package:flutter_prime/view/screens/cheakout/widgets/cheak_out_product_edit_bottom_sheet.dart';
import 'package:flutter_prime/view/screens/cheakout/widgets/confirm_checkout_pop_up.dart';
import 'package:flutter_prime/view/screens/cheakout/widgets/edit_check_out_product_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmCheakoutController extends GetxController {
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
  double? totalAmount = 0.0;
  String productName = "";
  String perProductPrice = "";
  String uom = "";
  String vatAmount = "";
  bool isVatEnable = false;
  bool isVatInPercent = false;
  bool paidOnline = false;
  bool paidinCash = false;
  int id = 0;
  List<CartProductModel> cartProductList = [];
  double vat = 0.0;

  Future<void> getCartList() async {
    await databaseHelper.initializeDatabase();
    cartProductList = await databaseHelper.getCartItems();
    update();
  }

  void initData() async {
    getCartList();
    await getVatData();
    loadDropdownData();
  }

  getVatData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    vatAmount = preferences.getString(SharedPreferenceHelper.vatAmountKey) ?? "00";
    isVatEnable = preferences.getBool(SharedPreferenceHelper.isVatactiveOrNot)!;
    isVatInPercent = preferences.getBool(SharedPreferenceHelper.isVatInPercentiseKey)!;
    print('vat amount: $vatAmount');

    update();
    try {
      print('before parse vat: $vatAmount');
      vat = double.parse(vatAmount);
      print('afteer parse: $vat');
      print("this is vat");
      print(vat);
    } catch (e) {
      print('error vat: $vat');
      vat = 0.0;
    }

    print('final vat: $vat');
    isVatInPercent = preferences.getBool(SharedPreferenceHelper.isVatInPercentiseKey)!;

    update();
  }

  void showEditOrDeleteBottomSheet(
    BuildContext context,
    CartProductModel cartProductModel,
  ) {
    productQuantityController.clear();
    update();
    productName = cartProductModel.name ?? "";
    perProductPrice = cartProductModel.price ?? "";
    totalAmount = double.parse(cartProductModel.totalAmount.toString());
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

  void checkOutProductBottomSheet(
    BuildContext context,
    CartProductModel cartProductModel,
  ) {
    productQuantityController.clear();
    update();
    productName = cartProductModel.name ?? "";
    perProductPrice = cartProductModel.price ?? "";
    totalAmount = double.parse(cartProductModel.totalAmount.toString());
    productQuantityController.text = cartProductModel.quantity.toString();
    quantity = cartProductModel.quantity as int;
    newPickedImage = File(cartProductModel.imagePath ?? "");
    newCategory = cartProductModel.category ?? "";
    newUom = cartProductModel.uom ?? "";
    uom = cartProductModel.uom ?? "";
    update();
    CustomBottomSheet(
      child: EditCheakoutProductBottomSheet(
        id: int.parse(cartProductModel.id.toString()),
      ),
    ).customBottomSheet(context);
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

  int get totalCount => cartProductList.length;

  double get totalPrice {
    return cartProductList.fold(0.0, (sum, item) => sum + (item.totalAmount ?? 0.0));
  }

  double get grandTotalPrice {
    double totalPriceWithoutVat = totalPrice;
    double vatAmount = (totalPriceWithoutVat * (vat / 100.0));

    return totalPriceWithoutVat + vatAmount;
  }

  void showConfirmPopUp(
    BuildContext context,
  ) {
    CustomAlertDialog(child: const ConfirmCheckoutPopUp(), actions: []).customAlertDialog(context);
  }

  Future<void> completeCheckout(String paymentMethod) async {
    await databaseHelper.insertCheckoutHistory(cartProductList, paymentMethod);
    await databaseHelper.clearCart();

    cartProductList.clear();
    update();

    Get.back();
  }

  void showDropdownMenu(BuildContext context) {
    showMenu(
      color: MyColor.colorWhite,
      context: context,
      position: RelativeRect.fromLTRB(
        MediaQuery.of(context).size.width - 150.0,
        MediaQuery.of(context).size.height - 150.0,
        0.0,
        0.0,
      ),
      items: [
        PopupMenuItem(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.space8),
            child: RoundedButton(
                text: MyStrings.paidByCash,
                press: () {
                  paidinCash = true;
                  paidOnline = false;
                  print("cash" + paidinCash.toString());
                  print("online" + paidOnline.toString());
                  Get.back();
                  update();
                }),
          ),
        ),
        PopupMenuItem(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.space8),
            child: RoundedButton(
                text: MyStrings.paidOnline,
                press: () {
                  paidOnline = true;
                  paidinCash = false;
                  print("cash" + paidinCash.toString());
                  print("online" + paidOnline.toString());
                  Get.back();
                  update();
                }),
          ),
        ),
      ],
    );
  }

  changeonlinePaid() {
    paidOnline = !paidOnline;
    paidinCash = true;
    update();
  }

  changeCashPaid() {
    paidinCash = !paidinCash;
    paidOnline = false;
    update();
  }
}
