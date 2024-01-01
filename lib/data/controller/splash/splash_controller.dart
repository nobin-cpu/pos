import 'package:flutter_prime/core/helper/secured_storage_helper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/data/controller/localization/localization_controller.dart';
import 'package:flutter_prime/data/repo/auth/general_setting_repo.dart';

class SplashController extends GetxController {
  GeneralSettingRepo repo;
  LocalizationController localizationController;
  SplashController({required this.repo, required this.localizationController});

  bool isLoading = true;
  String? userID = "";
  gotoNextPage() async {
    
    final storage = new FlutterSecureStorage();
    userID = await storage.read(key: SecuredStorageHelper.uniqueID);
   
    noInternet = false;
    update();
    if (userID != null) {
      Future.delayed(const Duration(seconds: 2), () {
        Get.offAndToNamed(RouteHelper.bottomNavBar);
      });
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        Get.offAndToNamed(RouteHelper.loginScreen);
      });
    }
  }

  bool noInternet = false;
  void getGSData(bool isRemember) async {
    isLoading = false;
    update();

    if (isRemember) {
      Future.delayed(const Duration(seconds: 1), () {
        Get.offAndToNamed(RouteHelper.bottomNavBar);
      });
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        Get.offAndToNamed(RouteHelper.loginScreen);
      });
    }
  }
}
