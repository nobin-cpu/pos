import 'package:flutter_prime/core/helper/shared_preference_helper.dart';
import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/model/invoice_details/invoice_details_model.dart';
import 'package:flutter_prime/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvoiceDetailsController extends GetxController {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  List<InvoiceDetailsModel> products = [];
  int invoiceId = 0;
  int transectionId = 0;
  String dateTime = "";
  bool isFromVoidScreen = false;

  bool isVatEnable = false;
  bool isVatInPercent = false;
  bool isVatActivateOrNot = false;
   int? customerId = 0;
   double ? settledVatForCurrentTrx = 0;

  String? vatamount = "";

  Future<void> fetchProducts(int invoiceId) async {
    print('my invoiceId: ${invoiceId}');
    await databaseHelper.initializeDatabase();
    this.invoiceId = invoiceId;
    List<InvoiceDetailsModel> productList = await databaseHelper.getProductsByTransactionId(invoiceId);
    products = productList;
    print(products);
    print("this id product");
    update();
  }

// Future<void> updateVoidStatus() async {
//   try {
//     await databaseHelper.deleteInvoiceByTransactionId(databaseHelper.database, transectionId);

//     List<VoidItemsModel> voidedItems = await databaseHelper.getVoidedItems();
//     print("Voided Items: $voidedItems");

//   } catch (e) {
//     print("Error during deleteInvoiceItems: $e");
//   }
// }

  Future<void> updateVoidStatus() async {
    try {
      await databaseHelper.updateInvoiceItemStatus(invoiceId, 'VOID');
      try {
        for (var voidProduct in products) {
          String productId = voidProduct.productId.toString();
          String stock = await databaseHelper.getProductStock(productId);
          // vatamount = products[0].vatAmount;
          int newStock = int.parse(stock) + voidProduct.quantity!;
          await updateProductStock(int.parse(productId), newStock.toString());
          CustomSnackBar.success(successList: [MyStrings.listedAsVoidItem]);
        }

        update();

        Get.back();
        Get.offAllNamed(RouteHelper.bottomNavBar);
      } catch (e) {
        print('Error completing checkout: $e');
        CustomSnackBar.error(errorList: [MyStrings.voidStockUpdateFailed]);
      }
      Get.offAllNamed(RouteHelper.bottomNavBar);
    } catch (e) {
      print("Error during updateVoidStatus: $e");
    }
  }

  Future<void> updateProductStock(int productId, String newStock) async {
    try {
      await databaseHelper.updateProductStock(productId, newStock);
    } catch (e) {
      print('Error updating product stock: $e');
    }
  }

  getVatActivationValue() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isVatInPercent = preferences.getBool(SharedPreferenceHelper.isVatInPercentiseKey)!;
      vatamount = preferences.getString(SharedPreferenceHelper.vatAmountKey);
    isVatActivateOrNot = preferences.getBool(SharedPreferenceHelper.isVatactiveOrNot)!;
    // print('saved vat amount ${vatamount}');
    update();
  }

  double get totalPrice {
    double total = 0.0;
    for (var product in products) {
      total += double.parse(product.totalAmount.toString());
    }
    return total;
  }

  double get grandTotalPrice {
    double totalPriceWithoutVat = totalPrice;
    double vatAmount = (totalPriceWithoutVat * (double.tryParse(vatamount.toString())! / 100.0));

    return totalPriceWithoutVat + vatAmount;
  }
}
