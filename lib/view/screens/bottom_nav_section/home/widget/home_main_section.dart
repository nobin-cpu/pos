import 'package:flutter/material.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/controller/home/home_controller.dart';
import 'package:flutter_prime/view/screens/bottom_nav_section/home/widget/home_button.dart';
import 'package:get/get.dart';

class HomeMainSection extends StatelessWidget {
  const HomeMainSection({Key? key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) => Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.5),
        itemCount: controller.homeButtons.length,
        itemBuilder: (context, index) => HomeButtonContainer(
          color: controller.homeButtons[index]["color"],
          imagePath: controller.homeButtons[index]["image"].toString(),
          text: controller.homeButtons[index]["title"].toString(),
          onPressed: () {
            if (index == 0) {
              Get.toNamed(RouteHelper.inventoryScreen);
            }
            if (index == 2) {
              Get.toNamed(RouteHelper.posScreen);
            }
            print(index);
          },
        ),
      ),
              ),
    );
  }
}