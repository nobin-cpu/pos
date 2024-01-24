import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/shared_preference_helper.dart';
import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/model/cart/cart_product_model.dart';
import 'package:flutter_prime/data/model/category/category_model.dart';
import 'package:flutter_prime/data/model/product/product_model.dart';
import 'package:flutter_prime/data/model/uom/uom_model.dart';
import 'package:flutter_prime/view/components/alert-dialog/custom_alert_dialog.dart';
import 'package:flutter_prime/view/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:flutter_prime/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutter_prime/view/screens/cheakout/widgets/confirm_checkout_pop_up.dart';
import 'package:flutter_prime/view/screens/cheakout/widgets/edit_check_out_product_alart_dialogue.dart';
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
  String? vatAmount = "";
  bool isVatEnable = false;
  bool isVatInPercent = false;
  bool paidOnline = false;
  bool paidinCash = false;
  int id = 0;
  List<CartProductModel> cartProductList = [];
  double vat = 0.0;
  double? discountPrice;

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
    vatAmount = preferences.getString(SharedPreferenceHelper.vatAmountKey);
    isVatEnable = preferences.getBool(SharedPreferenceHelper.isVatactiveOrNot) ?? false;
    isVatInPercent = preferences.getBool(SharedPreferenceHelper.isVatInPercentiseKey) ?? false;
    print('vat amount: $vatAmount');

    try {
      print('before parse vat: $vatAmount');
      vat = double.parse(vatAmount!);
      print('after parse: $vat');
      print("this is vat");
      print(vat);
    } catch (e) {
      print('error vat: $vat');
      vat = 0.0;
    }

    print('final vat: $vat');
    isVatInPercent = preferences.getBool(SharedPreferenceHelper.isVatInPercentiseKey) ?? false;

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
    // CustomBottomSheet(
    //   child: CheckoutProductEditBottomSheet(
    //     id: int.parse(cartProductModel.id.toString()),
    //   ),
    // ).customBottomSheet(context);
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
    // cartItem.discountAmount = disc;

    await databaseHelper.updateCartItem(cartItem);
    print("cart updated succesfully" + cartItem.discountAmount.toString());
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
      child: EditCheakoutProductAlartDialogue(
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
  double vatAmount = isVatInPercent
      ? (totalPriceWithoutVat * (vat / 100.0))
      : vat.toDouble(); 

  return totalPriceWithoutVat + vatAmount;
}

double subTotalForProduct(CartProductModel product) {
  double totalPriceWithoutVat = (double.parse(product.price ?? "0.0") * product.quantity!) - (product.discountPrice ?? 0.0);
  return totalPriceWithoutVat;
}



  // void showConfirmPopUp(
  //   BuildContext context,
  // ) {
  //   CustomAlertDialog(child: const ConfirmCheckoutPopUp(), actions: []).customAlertDialog(context);
  // }

  Future<void> completeCheckout(String paymentMethod) async {
    int? currentVat = int.tryParse(vatAmount.toString());
    print("this is current vat ${currentVat}");
    update();
    await databaseHelper.insertCheckoutHistory(cartProductList, paymentMethod, generateUniqueId(), false, currentVat ?? 0, isVatInPercent);
    await databaseHelper.clearCart();
    print("vat in percent or not${isVatInPercent}");
    CustomSnackBar.success(successList: [MyStrings.productCheckoutSuccessfully]);

    cartProductList.clear();
    update();

    Get.back();
    Get.offAllNamed(RouteHelper.bottomNavBar);
  }

  int generateUniqueId() {
    Random random = Random();
    int id = 0;

    for (int i = 0; i < 9; i++) {
      id *= 10;
      id += random.nextInt(10);
    }

    return id;
  }

  double calculateTotalDiscount() {
    double totalDiscount = 0.0;
    for (var cartItem in cartProductList) {
      totalDiscount += cartItem.discountAmount ?? 0.0;
    }
    return totalDiscount;
  }

  void calculateDiscountedPrices() {
    for (var cartItem in cartProductList) {
      if (cartItem.isDiscountInPercent == 1) {
        cartItem.discountPrice = cartItem.totalAmount! * (cartItem.discountAmount! / 100);
      } else {
        cartItem.discountPrice = cartItem.discountAmount;
      }
    }
    update();
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
