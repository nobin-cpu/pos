import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/data/model/damage_history/damage_history_model.dart';
import 'package:flutter_prime/data/model/damage_history_details/damage_history_details_model.dart';
import 'package:get/get.dart';

class DamageHistoryDetailsController extends GetxController {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  bool isLoading = false;
  // int damageID = 0;
  List<DamageHistoryItem> damageHistory = [];
  List<DamageDetailItem> damageDetails = [];

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchDamageDetails(int damageID) async {
    await databaseHelper.initializeDatabase();
    isLoading = true;
    update();

    try {
      damageDetails = await databaseHelper.getDamageDetails(damageID);
      isLoading = false;
      update();
    } catch (e) {
      print('Error loading damage details: $e');
      isLoading = false;
      update();
    }
  }
}
