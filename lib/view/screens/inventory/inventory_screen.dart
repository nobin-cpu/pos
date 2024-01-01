import 'package:flutter/material.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/data/controller/inventory/inventory_controller.dart';
import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';
import 'package:flutter_prime/view/components/card/custom_card.dart';
import 'package:get/get.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  void initState() {
    final controller = Get.put(InventoryController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: MyStrings.inventory),
      body: GetBuilder<InventoryController>(
        builder: (controller) => ListView.builder(
          shrinkWrap: true,
          itemCount: controller.dataList.length,
          itemBuilder: ((context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.space8, vertical: Dimensions.space4),
              child: InkWell(
                onTap: () {
                  if (index == 0) {
                    Get.toNamed(RouteHelper.uomScreen);
                  }
                  if (index == 1) {
                    Get.toNamed(RouteHelper.categoryScreen);
                  }
                  if (index == 2) {
                    Get.toNamed(RouteHelper.productScreen);
                  }
                },
                child: CustomCard(
                    radius: Dimensions.space10,
                    width: double.infinity,
                    child: Row(children: [
                      Image.asset(
                        controller.dataList[index]["image"].toString(),
                        height: Dimensions.space30,
                        width: Dimensions.space30,
                      ),
                      const SizedBox(width: Dimensions.space20),
                      Text(
                        controller.dataList[index]["title"].toString(),
                        style: mediumLarge,
                      )
                    ])),
              ),
            );
          }),
        ),
      ),
    );
  }
}
