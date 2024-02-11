import 'package:flutter_prime/core/helper/shared_preference_helper.dart';
import 'package:get/get.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyMenuController extends GetxController{

  logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(
      SharedPreferenceHelper.userIdKey,
    );
    Get.offAllNamed(RouteHelper.loginScreen);
  }
}