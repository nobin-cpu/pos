import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/model/customers/customer_model.dart';
import 'package:flutter_prime/view/components/alert-dialog/custom_alert_dialog.dart';
import 'package:flutter_prime/view/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:flutter_prime/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutter_prime/view/screens/customers/widgets/add_customers_bottom_sheet.dart';
import 'package:flutter_prime/view/screens/customers/widgets/custom_alert_dialogue.dart';
import 'package:get/get.dart';

class AddCustomersController extends GetxController {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phController = TextEditingController();
  final TextEditingController poController = TextEditingController();

  List<CustomerModel> customers = [];

  @override
  void onInit() {
    super.onInit();
    fetchCustomers();
  }

  void fetchCustomers() async {
    await databaseHelper.initializeDatabase();
    customers = await databaseHelper.getCustomers();
    update();
  }

  void showAddCustomersBottomSheet(
    BuildContext context,
  ) {
    nameController.clear();
    addressController.clear();
    phController.clear();
    poController.clear();
    update();
    CustomBottomSheet(
      child: const AddCustomersBottomSheet(),
    ).customBottomSheet(context);
  }

  void showAddCustomersDetailsAlertDialogue(
    BuildContext context,
    String address,
    String post,
    String phone,
  ) {
    

    CustomAlertDialog(
      actions: [],
      child: CustomerDetails(
        address: address,
        post: post,
        phone: phone,
      ),
    ).customAlertDialog(context);
  }

  addCustomers() async {
    await databaseHelper.initializeDatabase();
    if (nameController.text.isNotEmpty && addressController.text.isNotEmpty && phController.text.isNotEmpty) {
      await databaseHelper.insertCustomers(nameController.text, addressController.text, phController.text, poController.text);
      fetchCustomers();
      Get.back();
      await CustomSnackBar.success(successList: ["CustomerAddedSuccessfully"]);
    } else {
      await CustomSnackBar.error(errorList: ["Failed to add customer"]);
    }

    update();
    Get.back();
  }
}
