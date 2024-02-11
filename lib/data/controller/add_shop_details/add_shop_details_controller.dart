import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/shared_preference_helper.dart';
import 'package:flutter_prime/view/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:flutter_prime/view/screens/add_shop_details/widgets/shop_details_add_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddShopDetailsController extends GetxController {
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController shopAddressController = TextEditingController();
  final TextEditingController phNoController = TextEditingController();

  String? shopName = "";
  String? shopAddress = "";
  String? phoneNumber = "";

  void showShopDetailsAddBottomSheet(BuildContext context) {
    shopNameController.text = shopName ?? "";
    shopAddressController.text = shopAddress ?? "";
    phNoController.text = phoneNumber ?? "";
    update();
    CustomBottomSheet(
      child: const ShopDetailsAddBottomSheet(),
    ).customBottomSheet(context);
  }

  getShopDetailsData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    shopName = preferences.getString(SharedPreferenceHelper.shopNameKey);
    shopAddress = preferences.getString(SharedPreferenceHelper.shopAddressKey);
    phoneNumber = preferences.getString(SharedPreferenceHelper.phNoKey);

    update();
  }

  Future<void> saveshopDataToSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(SharedPreferenceHelper.shopNameKey, shopNameController.text);
    await preferences.setString(SharedPreferenceHelper.shopAddressKey, shopAddressController.text);
    await preferences.setString(SharedPreferenceHelper.phNoKey, phNoController.text);
    getShopDetailsData();
    update();
  }
}
