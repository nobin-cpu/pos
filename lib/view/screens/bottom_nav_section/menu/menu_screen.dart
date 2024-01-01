import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_prime/core/helper/shared_preference_helper.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/core/utils/util.dart';
import 'package:flutter_prime/data/controller/localization/localization_controller.dart';
import 'package:flutter_prime/data/controller/menu/my_menu_controller.dart';
import 'package:flutter_prime/data/repo/auth/general_setting_repo.dart';
import 'package:flutter_prime/data/repo/menu_repo/menu_repo.dart';
import 'package:flutter_prime/data/services/api_service.dart';
import 'package:flutter_prime/view/components/divider/custom_divider.dart';
import 'package:flutter_prime/view/components/will_pop_widget.dart';
import 'package:flutter_prime/view/screens/bottom_nav_section/menu/widget/language_dialog.dart';
import 'package:flutter_prime/view/screens/bottom_nav_section/menu/widget/menu_item.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  @override
  void initState() {

    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(GeneralSettingRepo(apiClient: Get.find()));
    Get.put(MenuRepo(apiClient: Get.find()));
    final controller = Get.put(MyMenuController(menuRepo: Get.find(), repo: Get.find()));
    Get.put(LocalizationController(sharedPreferences: Get.find()));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(
      builder: (localizationController) => GetBuilder<MyMenuController>(
        builder: (menuController) => WillPopWidget(
          nextRoute: RouteHelper.bottomNavBar,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: MyColor.screenBgColor,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: MyColor.primaryColor,
                title: Text(MyStrings.menu, style: regularLarge.copyWith(color: MyColor.colorWhite)),
                automaticallyImplyLeading: false,
              ),
              body: GetBuilder<MyMenuController>(
                builder: (controller) => SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.space12),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.space15, horizontal: Dimensions.space15),
                        decoration: BoxDecoration(
                          color: MyColor.colorWhite,
                          borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
                          boxShadow: MyUtils.getCardShadow()
                        ),
                        child: Column(
                          children: [
                            // MenuItems(
                            //   // imageSrc: MyImages.user,
                            //   label: MyStrings.profile.tr,
                            //   onPressed: () => Get.toNamed(RouteHelper.profileScreen)
                            // ),
                            const CustomDivider(space: Dimensions.space10),
                            MenuItems(
                              imageSrc: MyImages.changePassword,
                              label: MyStrings.changePassword,
                              onPressed: () => Get.toNamed(RouteHelper.changePasswordScreen)
                            ),
                            // MenuItems(
                            //   imageSrc: MyImages.addMoney,
                            //   label: MyStrings.deposit,
                            //   isSvgImage: false,
                            //   onPressed: () => Get.toNamed(RouteHelper.depositsScreen)
                            // ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Dimensions.space10),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.space15, horizontal: Dimensions.space15),
                        decoration: BoxDecoration(
                          color: MyColor.colorWhite,
                          borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
                          boxShadow: MyUtils.getCardShadow()
                        ),
                        child: Column(
                          children: [
                          //  Visibility(
                          //    visible: menuController.isWithdrawEnable,
                          //    child: Column(
                          //    crossAxisAlignment: CrossAxisAlignment.start,
                          //    children: [
                          //      MenuItems(
                          //        imageSrc: MyImages.withdraw,
                          //        label: MyStrings.withdraw.tr,
                          //        onPressed: () => Get.toNamed(RouteHelper.withdrawScreen)
                          //      ),
                          //      const CustomDivider(space: Dimensions.space10),
                          //    ],
                          //  )),
                            // MenuItems(
                            //   imageSrc: MyImages.transaction,
                            //   label: MyStrings.transaction.tr,
                            //   onPressed: () => Get.toNamed(RouteHelper.transactionHistoryScreen)
                            // ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Dimensions.space10),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.space15, horizontal: Dimensions.space15),
                        decoration: BoxDecoration(
                          color: MyColor.colorWhite,
                          borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
                          boxShadow: MyUtils.getCardShadow()
                        ),
                        child: Column(
                          children: [
                            Visibility(
                              visible: menuController.langSwitchEnable,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MenuItems(
                                    imageSrc: MyImages.language,
                                    label: MyStrings.language.tr,
                                    onPressed: (){
                                      final apiClient = Get.put(ApiClient(sharedPreferences: Get.find()));
                                      SharedPreferences pref = apiClient.sharedPreferences;
                                      String language = pref.getString(SharedPreferenceHelper.languageListKey)  ??'';
                                      String countryCode = pref.getString(SharedPreferenceHelper.countryCode)   ??'US';
                                      String languageCode = pref.getString(SharedPreferenceHelper.languageCode) ??'en';
                                      Locale local = Locale(languageCode,countryCode);
                                      showLanguageDialog(language, local, context);
                                      //Get.toNamed(RouteHelper.languageScreen);
                                    },
                                  ),
                                  const CustomDivider(space: Dimensions.space10),
                                ],
                              )
                            ),
                            MenuItems(
                              imageSrc: MyImages.policy,
                              label: MyStrings.privacyPolicy.tr,
                              onPressed: (){
                                Get.toNamed(RouteHelper.privacyScreen);
                              }
                            ),
                            const CustomDivider(space: Dimensions.space10),
                            controller.logoutLoading ? const Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                height: 20, width: 20,
                                child: CircularProgressIndicator(color: MyColor.primaryColor, strokeWidth: 2.00),
                              ),
                            ) :
                            MenuItems(
                              imageSrc: MyImages.logout,
                              label: MyStrings.logout.tr,
                              onPressed: () => controller.logout()
                            )
                          ],
                        )
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
