import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/data/model/invoice_details/invoice_details_model.dart';
import 'package:get/get.dart';

class InvoiceDetailsController extends GetxController {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  List<InvoiceDetailsModel> products = [];
  int invoiceId = 0;
  int transectionId = 0;
  String dateTime = "";

  Future<void> fetchProducts(int invoiceId) async {
    print('my invoiceId: ${invoiceId}');
    await databaseHelper.initializeDatabase();
    this.invoiceId = invoiceId;
    List<InvoiceDetailsModel> productList = await databaseHelper.getProductsByTransactionId(invoiceId);
    products = productList;
    print(products);
    print("this si product");
    update();
  }

  deleteInvoiceItems() {
    databaseHelper.deleteInvoiceByTransactionId(transectionId,);

  }
}
