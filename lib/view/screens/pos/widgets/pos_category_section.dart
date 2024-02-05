import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/style.dart';
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
      child: GetBuilder<PosController>(builder: (controller) {
        return GridView.builder(
            itemCount: controller.categoryList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1.3,
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
               print("this is photo ${controller.categoryList[index].image.toString()}");
              return CustomCard(
                isPress: true,
                onPressed: () {
                   Get.toNamed(RouteHelper.categoryProductListScreen, arguments: [controller.categoryList[index].title]);
                },
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.file(
                        File(controller.categoryList[index].image.toString()),
                        height: Dimensions.space60,
                        width: Dimensions.space80,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: Dimensions.space10),
                      Text(
                        controller.categoryList[index].title.toString(),
                        style: semiBoldLarge,
                      )
                    ],
                  ));
            });
      }),
    );
  }
}
//  CustomCard(
//               isPress: true,
//               onPressed: () {
//                 Get.toNamed(RouteHelper.categoryProductListScreen, arguments: [controller.categoryList[index].title]);
//               },
//               width: double.infinity,
//               child: Center(child: Text(controller.categoryList[index].title.toString())),
//             ),