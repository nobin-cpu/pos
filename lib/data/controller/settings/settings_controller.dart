import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/shared_preference_helper.dart';
import 'package:flutter_prime/view/components/alert-dialog/custom_alert_dialog.dart';
import 'package:flutter_prime/view/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:flutter_prime/view/screens/settings/widget/settings_aleart_dialogue.dart';
import 'package:flutter_prime/view/screens/add_shop_details/widgets/shop_details_add_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VatSettingsController extends GetxController {
  final TextEditingController vatController = TextEditingController();
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController shopAddressController = TextEditingController();
  final TextEditingController phNoController = TextEditingController();
  bool percentDiscount = false;
  bool vatSwitch = false;

  String cheakAmount = "";
  bool? bools;

  String? vatamount = "";
  String? shopName = "";

  void showVatCustomizeAleartDialogue(BuildContext context) {
    vatController.text = vatamount.toString();
    update();
    CustomAlertDialog(child: const VatCustomizeAlartDialogue(), actions: []).customAlertDialog(context);
  }

  void showShopDetailsAddBottomSheet(BuildContext context) {
    vatController.text = vatamount.toString();
    update();
    CustomBottomSheet(
      child: const ShopDetailsAddBottomSheet(),
    ).customBottomSheet(context);
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
 
    update();
  }

  Future<void> saveVatDataToSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(SharedPreferenceHelper.vatAmountKey, vatController.text);

    await preferences.setBool(SharedPreferenceHelper.isVatInPercentiseKey, percentDiscount);
    await preferences.setBool(SharedPreferenceHelper.isVatactiveOrNot, vatSwitch);
    await getVatActivationValue();
  }
}
