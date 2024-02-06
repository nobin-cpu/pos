import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/shared_preference_helper.dart';
import 'package:flutter_prime/view/components/alert-dialog/custom_alert_dialog.dart';
import 'package:flutter_prime/view/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:flutter_prime/view/screens/settings/widget/settings_aleart_dialogue.dart';
import 'package:flutter_prime/view/screens/settings/widget/shop_details_add_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  final TextEditingController vatController = TextEditingController();
  final TextEditingController shopKeeperNameController = TextEditingController();
  final TextEditingController shopAddressController = TextEditingController();
  final TextEditingController phNoController = TextEditingController();
  bool percentDiscount = false;
  bool vatSwitch = false;

  String cheakAmount = "";
  bool? bools;

  String? vatamount = "";

  void showVatCustomizeAleartDialogue(BuildContext context) {
    vatController.text = vatamount.toString();
    update();
    CustomAlertDialog(child: const VatCustomizeAlartDialogue(), actions: []).customAlertDialog(context);
  }
  void showShopDetailsAddBottomSheet(BuildContext context) {
    vatController.text = vatamount.toString();
    update();
    CustomBottomSheet(child: const ShopDetailsAddBottomSheet(),).customBottomSheet(context);
  }

  changediscountCheckBox() {
    percentDiscount = !percentDiscount;
    update();
  }

  void changevatCheckBox() {
    vatSwitch = !vatSwitch;
    update();
  }

  cheakSavedData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    cheakAmount = preferences.getString(SharedPreferenceHelper.vatAmountKey)!;
    bools = preferences.getBool(SharedPreferenceHelper.isVatInPercentiseKey);
    update();
  }

  getVatActivationValue() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    percentDiscount = preferences.getBool(SharedPreferenceHelper.isVatInPercentiseKey)!;
    vatamount = preferences.getString(SharedPreferenceHelper.vatAmountKey);
    vatSwitch = preferences.getBool(SharedPreferenceHelper.isVatactiveOrNot)!;
    print('saved vat amountsssssssssssssss $vatamount');
    print('saved vat amount $percentDiscount');
    update();
  }

  Future<void> saveVatDataToSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(SharedPreferenceHelper.vatAmountKey, vatController.text);
    await preferences.setString(SharedPreferenceHelper.shopKeeperNameKey, shopKeeperNameController.text);
    await preferences.setString(SharedPreferenceHelper.shopAddressKey, shopAddressController.text);
    await preferences.setString(SharedPreferenceHelper.phNoKey, phNoController.text);
    await preferences.setBool(SharedPreferenceHelper.isVatInPercentiseKey, percentDiscount);
    await preferences.setBool(SharedPreferenceHelper.isVatactiveOrNot, vatSwitch);
  }

  Future<void> saveshopDataToSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(SharedPreferenceHelper.shopKeeperNameKey, shopKeeperNameController.text);
    await preferences.setString(SharedPreferenceHelper.shopAddressKey, shopAddressController.text);
    await preferences.setString(SharedPreferenceHelper.phNoKey, phNoController.text);
  }
}
