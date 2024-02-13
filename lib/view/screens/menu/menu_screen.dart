import 'package:flutter/material.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/controller/menu/my_menu_controller.dart';
import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';
import 'package:flutter_prime/view/components/card/custom_card.dart';
import 'package:get/get.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
     Get.put(MyMenuController());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: MyStrings.menu),
      body: GetBuilder<MyMenuController>(
        builder: (controller) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(Dimensions.space8),
              child: CustomCard(
                  isPress: true,
                  onPressed: () {
                    Get.toNamed(RouteHelper.vatSettingsScreen);
                  },
                  width: double.infinity,
                  child: const Text(MyStrings.vatSettiings)),
            ),
            Padding(
              padding: const EdgeInsets.all(Dimensions.space8),
              child: CustomCard(
                  isPress: true,
                  onPressed: () {
                    Get.toNamed(RouteHelper.addShopDetailsScreen);
                  },
                  width: double.infinity,
                  child: const Text(MyStrings.addShopDetails)),
            ),
            Padding(
              padding: const EdgeInsets.all(Dimensions.space8),
              child: CustomCard(
                  isPress: true,
                  onPressed: () {
                    controller.logout();
                  },
                  width: double.infinity,
                  child: const Text(MyStrings.logout)),
            ),
          ],
        ),
      ),
    );
  }
}
