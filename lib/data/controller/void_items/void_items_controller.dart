import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/data/model/invoice_details/invoice_details_model.dart';
import 'package:flutter_prime/data/model/void_items/void_items_model.dart';
import 'package:get/get.dart';

class VoidItemsController extends GetxController {
  final DatabaseHelper databaseHelper = DatabaseHelper();

  List<VoidItemsModel> voidedItems = [];

  @override
  void onInit() {
    super.onInit();
    fetchVoidedItems();
  }

  Future<void> fetchVoidedItems() async {
    await databaseHelper.initializeDatabase();
    try {
      voidedItems = await databaseHelper.getVoidedItems();
      print("this is voidsss${voidedItems}");
      voidedItems.forEach((item) {
        print("Voided Item: ${item.name}, Price: ${item.price}, Total Amount: ${item.totalAmount}");
      });
      update();
    } catch (e) {
      print("Error fetching voided items: $e");
    }
  }
}
