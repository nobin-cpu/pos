import 'package:flutter/material.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/data/controller/pos/pos_controller.dart';
import 'package:flutter_prime/view/components/card/custom_card.dart';
import 'package:get/get.dart';

class PosCategorySection extends StatefulWidget {
  const PosCategorySection({super.key});

  @override
  State<PosCategorySection> createState() => _PosCategorySectionState();
}

class _PosCategorySectionState extends State<PosCategorySection> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GetBuilder<PosController>(
        builder: (controller) => GridView.builder(
          itemCount: controller.categoryList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 2.2,
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(Dimensions.cardRadius)),
            child: CustomCard(
              isPress: true,
              onPressed: () {
                Get.toNamed(RouteHelper.categoryProductListScreen, arguments: [controller.categoryList[index].title]);
              },
              width: double.infinity,
              child: Center(child: Text(controller.categoryList[index].title.toString())),
            ),
          ),
        ),
      ),
    );
  }
}
