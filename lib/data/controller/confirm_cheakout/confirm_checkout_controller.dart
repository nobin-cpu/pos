import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_prime/core/helper/shared_preference_helper.dart';
import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/util.dart';
import 'package:flutter_prime/data/model/cart/cart_product_model.dart';
import 'package:flutter_prime/data/model/category/category_model.dart';
import 'package:flutter_prime/data/model/customers/customer_model.dart';
import 'package:flutter_prime/data/model/product/product_model.dart';
import 'package:flutter_prime/data/model/uom/uom_model.dart';
import 'package:flutter_prime/view/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:flutter_prime/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutter_prime/view/screens/cheakout/widgets/edit_check_out_product_alart_dialogue.dart';
import 'package:flutter_prime/view/screens/confirm_checkout/widgets/add_customer_bottomSheet.dart';
import 'package:flutter_prime/view/screens/invoice_print/widgets/bill_to_section.dart';
import 'package:flutter_prime/view/screens/invoice_print/widgets/date_section.dart';
import 'package:flutter_prime/view/screens/invoice_print/widgets/shop_keeper_info_srction.dart';
import 'package:flutter_prime/view/screens/invoice_print/widgets/total_section.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pdf/widgets.dart' as pw;

class ConfirmCheakoutController extends GetxController {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController uomController = TextEditingController();
  TextEditingController newNameController = TextEditingController();
  TextEditingController newPriceController = TextEditingController();
  final TextEditingController productQuantityController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phController = TextEditingController();
  final TextEditingController poController = TextEditingController();

  List<CustomerModel> customers = [];
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
  List<CartProductModel> checkOutProductList = [];
  double vat = 0.0;
  double? discountPrice;
  List<ProductModel> products = [];

  String shopName = "";
  String shopAddress = "";
  String phoneNumber = "";

  List<CustomerModel> customerList = [];
  CustomerModel? selectedCustomer;
  fetchCustomers() async {
    await databaseHelper.initializeDatabase();
    customerList = await databaseHelper.getCustomers();
    update();
  }

  Future<void> loadProducts() async {
    await databaseHelper.initializeDatabase();
    try {
      products = await databaseHelper.getProductList();
      update();
    } catch (e) {
      print('Error loading product data: $e');
    }
  }

  Future<void> getCartList() async {
    await databaseHelper.initializeDatabase();
    cartProductList = await databaseHelper.getCartItems();
    checkOutProductList = await databaseHelper.getCartItems();
    update();
  }

  void initData() async {
    getCartList();
    await getVatData();
    await loadProducts();
    fetchCustomers();
    loadDropdownData();
    await loadDataFromSharedPreferences();
  }

  getVatData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    vatAmount = preferences.getString(SharedPreferenceHelper.vatAmountKey);
    isVatEnable = preferences.getBool(SharedPreferenceHelper.isVatactiveOrNot) ?? false;
    isVatInPercent = preferences.getBool(SharedPreferenceHelper.isVatInPercentiseKey) ?? false;

    try {
      vat = double.parse(vatAmount!);
    } catch (e) {
      print('error vat: $vat');
      vat = 0.0;
    }

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

  double get checkOutTotalPrice {
    return checkOutProductList.fold(0.0, (sum, item) => sum + (item.totalAmount ?? 0.0));
  }

  double get grandTotalPrice {
    double totalPriceWithoutVat = totalPrice;
    double vatAmount = isVatInPercent ? (totalPriceWithoutVat * (vat / 100.0)) : vat.toDouble();

    return totalPriceWithoutVat + vatAmount;
  }

  double get checkOutGrandTotalPrice {
    double totalPriceWithoutVat = totalPrice;
    double vatAmount = isVatInPercent ? (totalPriceWithoutVat * (vat / 100.0)) : vat.toDouble();

    return totalPriceWithoutVat + vatAmount;
  }

  double subTotalForProduct(CartProductModel product) {
    double totalPriceWithoutVat = (double.parse(product.price ?? "0.0") * product.quantity!) - (product.discountPrice ?? 0.0);
    return totalPriceWithoutVat;
  }

  int? customerid = 0;
  Future<void> completeCheckout(String paymentMethod) async {
    int? currentVat = int.tryParse(vatAmount.toString());
    print("this is current vat ${currentVat}");
    update();

    try {
      for (var cartProduct in cartProductList) {
        String productId = cartProduct.productId.toString();
        String stock = await databaseHelper.getProductStock(productId);

        int newStock = int.parse(stock) - cartProduct.quantity!;
        await updateProductStock(
          int.parse(productId),
          newStock.toString(),
        );
        await CustomSnackBar.success(successList: [MyStrings.productCheckoutSuccessfully]);
        print("Updated stock for product $productId: $newStock");
      }
      print("this is settled vat from controller${vatAmount}");
      await databaseHelper.insertCheckoutHistory(cartProductList, paymentMethod, generateUniqueId(), false, currentVat ?? 0, isVatInPercent, isVatInPercent, selectedCustomer!.id.toString());
      await CustomSnackBar.success(successList: [MyStrings.productCheckoutSuccessfully]);
      await databaseHelper.clearCart();

      cartProductList.clear();
      update();

      Get.back();
      Get.offAllNamed(RouteHelper.bottomNavBar);
    } catch (e) {
      print('Error completing checkout: $e');
      CustomSnackBar.error(errorList: [MyStrings.checkoutFailed]);
    }
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

  Future<void> updateProductStock(int productId, String newStock) async {
    try {
      await databaseHelper.updateProductStock(productId, newStock);
    } catch (e) {
      print('Error updating product stock: $e');
    }
  }

  void showAddCustomersBottomSheet(
    BuildContext context,
  ) {
    poController.clear();
    phController.clear();
    addressController.clear();
    nameController.clear();

    CustomBottomSheet(
      child: const AddCustomersBottomSheetSection(),
    ).customBottomSheet(context);
  }

  addCustomers() async {
    await databaseHelper.initializeDatabase();
    if (nameController.text.isNotEmpty && addressController.text.isNotEmpty && phController.text.isNotEmpty) {
      await databaseHelper.insertCustomers(nameController.text, addressController.text, phController.text, poController.text);
      fetchCustomers();
      Get.back();
      await CustomSnackBar.success(successList: [MyStrings.customerAddedSuccessfully]);
    } else {
      await CustomSnackBar.error(errorList: [MyStrings.failedToAddCustomer]);
    }

    update();
    Get.back();
  }

  void generatePdf() async {
    await getCustomerById(customerid!);

    await getAndPrintCustomerById(customerid!);
    update();
    await Printing.layoutPdf(onLayout: (format) => _generatePdf(format));
    Get.offAllNamed(RouteHelper.bottomNavBar);
    checkOutProductList.clear();
  }

  Future<Uint8List> _generatePdf(
    PdfPageFormat format,
  ) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.tiroBanglaRegular();
    final boldFont = await PdfGoogleFonts.robotoBold();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(Dimensions.space15),
        pageFormat: format,
        build: (context) {
          return pw.Column(children: [
            pw.Center(child: pw.Text(MyStrings.checkout)),
            pw.SizedBox(height: Dimensions.space15),
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, mainAxisAlignment: pw.MainAxisAlignment.start, children: [shopKeeperInfo(font, boldFont)]),
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [billTo(font, boldFont), date(font, boldFont)]),
            pw.SizedBox(height: Dimensions.space15),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                _buildTableRow([
                  MyStrings.products,
                  MyStrings.price,
                  MyStrings.discount,
                  MyStrings.quantity,
                  MyStrings.subTotal,
                ], font),
                ...checkOutProductList.map((invoice) {
                  return _buildTableRow([
                    invoice.name.toString() ?? "",
                    '${MyUtils.getCurrency()}${invoice.price ?? 0}',
                    '${invoice.discountAmount ?? 0}${invoice.isDiscountInPercent == 0 ? MyUtils.getCurrency() : MyUtils.getPercentSymbol()}',
                    '${invoice.quantity}${invoice.uom}',
                    '${MyUtils.getCurrency()}${invoice.totalAmount ?? 0}',
                  ], font);
                }).toList(),
              ],
            ),
            pw.SizedBox(height: Dimensions.space25),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                totalSection(font, boldFont),
              ],
            )
          ]);
        },
      ),
    );
    return pdf.save();
  }

  shopKeeperInfo(pw.Font font, pw.Font boldFont) {
   
    return ShopInfoSection(font: font, boldFont: boldFont, shopkeeperName: shopName, shopAddress: shopAddress, shopPhoneNo: phoneNumber).build();
  }

  date(pw.Font font, pw.Font boldFont) {
    return DateSection(
      font: font,
      boldFont: boldFont,
      dateTime: DateTime.now().toString(),
    ).build();
  }

  totalSection(pw.Font font, pw.Font boldFont) {
    double grandTotal = isVatEnable ? checkOutGrandTotalPrice : checkOutTotalPrice;
    update();
    print("this is grande totoal${grandTotal}");
    return TotalSection(font: font, boldFont: boldFont, totalPrice: double.tryParse(checkOutTotalPrice.toStringAsFixed(2)) ?? 0.0, grandTotalPrice: checkOutGrandTotalPrice ?? 0.0, vat: double.tryParse(vatAmount.toString()) ?? 0.0).build();
  }

  pw.TableRow _buildTableRow(List<String> rowData, pw.Font font) {
    return pw.TableRow(
      children: rowData.map((data) {
        return pw.Container(
          alignment: pw.Alignment.center,
          padding: pw.EdgeInsets.all(Dimensions.space8),
          child: pw.Text(
            data,
            style: pw.TextStyle(font: font),
          ),
        );
      }).toList(),
    );
  }

  Future<void> loadDataFromSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    shopName = preferences.getString(SharedPreferenceHelper.shopNameKey) ?? "";
    shopAddress = preferences.getString(SharedPreferenceHelper.shopAddressKey) ?? "";
    phoneNumber = preferences.getString(SharedPreferenceHelper.phNoKey) ?? "";
    update();
  }

  String? customerName = "";
  String? customerAddress = "";
  String? customerPhNo = "";
  String? customerPost = "";

  Future<void> getAndPrintCustomerById(int customerid) async {
    final customer = await getCustomerById(customerid);
    if (customer != null) {
      customerName = customer.name;
      customerAddress = customer.address;
      customerPhNo = customer.phNo;
      customerPost = customer.post;
      print('Customer Details:');
      print('ID: ${customer.id}');
      print('Name: ${customer.name}');
      print('Address: ${customer.address}');
      print('Phone Number: ${customer.phNo}');
      print('Post: ${customer.post}');
      update();
    } else {
      print('No customer found with ID: $customerid');
    }
  }

  Future<CustomerModel?> getCustomerById(int customerid) async {
    await databaseHelper.initializeDatabase();
    print("this is customer id to fetch data${customerid}");
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'customers',
      where: 'id = ?',
      whereArgs: [customerid],
    );
    if (maps.isNotEmpty) {
      final Map<String, dynamic> customerMap = maps.first;
      return CustomerModel.fromMap(customerMap);
    } else {
      print("No customer found with id: $customerid");
      return null;
    }
  }

  billTo(pw.Font font, pw.Font boldFont) {
    print("this is customer name from ccc-------- ${customerName}");
    return BillToSection(font: font, boldFont: boldFont, customerName: customerName ?? "", customerAddress: customerAddress ?? "", customerpost: customerPhNo ?? "", customerph: customerPost ?? "").build();
  }
}
