import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/data/model/invoice_details/invoice_details_model.dart';
import 'package:get/get.dart';

class InvoiceDetailsController extends GetxController {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  List<InvoiceDetailsModel> products = [];
  int invoiceId = 0;
  int transectionId = 0;
  String dateTime = "";
  bool isFromVoidScreen = false;

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
      Get.offAllNamed(RouteHelper.bottomNavBar);
    } catch (e) {
      print("Error during updateVoidStatus: $e");
    }
  }
}
