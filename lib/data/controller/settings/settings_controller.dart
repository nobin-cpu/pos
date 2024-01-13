import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/shared_preference_helper.dart';
import 'package:flutter_prime/view/components/alert-dialog/custom_alert_dialog.dart';
import 'package:flutter_prime/view/screens/settings/widget/settings_aleart_dialogue.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  final TextEditingController vatController = TextEditingController();
  bool percentDiscount = false;
  bool vatCheckBox = false;

  String cheakAmount = "";
  bool? bools;

  void showVatCustomizeAleartDialogue(BuildContext context) {
    CustomAlertDialog(child: const VatCustomizeAlartDialogue(), actions: []).customAlertDialog(context);
  }

  changediscountCheckBox() {
    percentDiscount = !percentDiscount;
    update();
  }

  void changevatCheckBox() {
    vatCheckBox = !vatCheckBox;
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
    vatCheckBox = preferences.getBool(SharedPreferenceHelper.isVatactiveOrNot)!;
    update();
  }

  Future<void> saveUidToSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(SharedPreferenceHelper.vatAmountKey, vatController.text);
    await preferences.setBool(SharedPreferenceHelper.isVatInPercentiseKey, percentDiscount);
    await preferences.setBool(SharedPreferenceHelper.isVatactiveOrNot, vatCheckBox);
  }
}
