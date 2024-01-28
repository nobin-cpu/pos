import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/model/damage_history/damage_history_model.dart';
import 'package:flutter_prime/data/model/product/product_model.dart';
import 'package:get/get.dart';

class DamageHistoryController extends GetxController {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  bool isLoading = false;
  List<DamageHistoryItem> damageHistory = [];

  @override
  void onInit() {
    super.onInit();
    loadDamageHistory();
  }

  Future<void> loadDamageHistory() async {
    await databaseHelper.initializeDatabase();
    isLoading = true;
    update();

    try {
      damageHistory = await databaseHelper.getDamageHistory();
      isLoading = false;
      update();
    } catch (e) {
      print('Error loading damage history: $e');
      isLoading = false;
      update();
    }
  }
}
