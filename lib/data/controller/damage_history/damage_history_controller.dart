import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/model/damage_history/damage_history_model.dart';
import 'package:flutter_prime/data/model/damage_history_details/damage_history_details_model.dart';
import 'package:flutter_prime/data/model/product/product_model.dart';
import 'package:get/get.dart';

class DamageHistoryController extends GetxController {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  bool isLoading = false;
  List<DamageHistoryItem> damageHistory = [];
  List<DamageDetailItem> damageDetails = [];

  @override
  void onInit() {
    super.onInit();
    loadDamageHistory(); // Load damage history when controller is initialized
    fetchDamageDetails(); // Load damage details when controller is initialized
  }

  Future<void> loadDamageHistory() async {
    await databaseHelper.initializeDatabase();
    isLoading = true;
    update();

    try {
      damageHistory = await databaseHelper.getDamageHistory();
    } catch (e) {
      print('Error loading damage history: $e');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchDamageDetails() async {
    await databaseHelper.initializeDatabase();
    isLoading = true;
    update();

    try {
      damageDetails = await databaseHelper.getAllDamageItems();
    } catch (e) {
      print('Error loading damage details: $e');
    } finally {
      isLoading = false;
      update();
    }
  }
}
