// ProductScreen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/data/controller/product/product_controller.dart';
import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';
import 'package:flutter_prime/view/components/card/custom_card.dart';
import 'package:get/get.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    super.initState();
    final controller = Get.put(ProductController());
    controller.initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
        builder: (controller) => Scaffold(
            appBar: CustomAppBar(
              title: MyStrings.product,
             
              isActionImage: true,
              isShowActionBtn: true,
              actionIcon: MyImages.add,
              actionPress: () {
                controller.showAddProductBottomSheet(context);
              },
            ),
            body: GetBuilder<ProductController>(
                builder: (controller) => ListView.builder(
                      itemCount: controller.productList.length,
                      itemBuilder: (context, index) {
                        print("helooooooooooooooo");
                        print(controller.productList[index].name );
                        return Padding(
                          padding: const EdgeInsets.all(Dimensions.space5),
                          child: CustomCard(
                            radius: Dimensions.space8,
                            width: double.infinity,
                            child: Row(
                              children: [
                             Image.file(File(controller.productList[index].imagePath ?? ""),height: 50,width: 50,),
                                const SizedBox(width:Dimensions.space10,),
                                Text(controller.productList[index].name ?? 'N/A', style: regularMediumLarge),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    controller.showEditOrDeleteBottomSheet(context,controller.productList[index]);
                                  },
                                  child: Image.asset(MyImages.edit, height: Dimensions.space15, color: MyColor.colorBlack),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ))));
  }
}
