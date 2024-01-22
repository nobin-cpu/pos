// ProductScreen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/core/utils/util.dart';
import 'package:flutter_prime/data/controller/product/product_controller.dart';
import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';
import 'package:flutter_prime/view/components/card/custom_card.dart';
import 'package:flutter_prime/view/components/custom_loader/custom_loader.dart';
import 'package:flutter_prime/view/screens/product/add_product_bottom_sheet/chip_filter.dart';
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
              actionPress: () {},
              action: [
                InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * .1),
                  ),
                  onTap: () {
                    controller.showAddProductBottomSheet(context);
                  },
                  hoverColor: Colors.transparent,
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.space10),
                      color: MyColor.transparentColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.space17),
                      child: Image.asset(
                        MyImages.add,
                        height: Dimensions.space15,
                        color: MyColor.colorWhite,
                      ),
                    ),
                  ),
                )
              ],
            ),
            body: controller.loading?const CustomLoader():
             Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                controller.productList.isEmpty
                    ? const SizedBox()
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: ChipFilter(
                          
                          categories: controller.categoryList,
                          onChipSelected: (category) {
                            controller.selectedCategory = category.title!;
                            controller.update();
                          },
                          selectedCategory:controller.selectedCategory,
                        ),
                      ),
                      controller.productList.isEmpty ?Center(child: Image.asset(MyImages.noDataFound,height: Dimensions.space200,)):
                Expanded(
                  child: GetBuilder<ProductController>(
                      builder: (controller) => controller.productList.isEmpty
                          ? Center(child: Image.asset(MyImages.noDataFound, height: Dimensions.space300))
                          : ListView.builder(
                              itemCount: controller.productList.length,
                              itemBuilder: (context, index) {
                                if (controller.selectedCategory.isEmpty || controller.productList[index].category == controller.selectedCategory) {
                                  return Padding(
                                    padding: const EdgeInsets.all(Dimensions.space5),
                                    child: CustomCard(
                                      radius: Dimensions.space8,
                                      width: double.infinity,
                                      child: Row(
                                        children: [
                                          Image.file(File(controller.productList[index].imagePath ?? ""), height: Dimensions.space50, width: Dimensions.space50),
                                          const SizedBox(
                                            width: Dimensions.space10,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(controller.productList[index].name ?? 'N/A', style: regularMediumLarge),
                                              Text("${MyStrings.price}: ${controller.productList[index].price}${MyUtils.getCurrency()} /${controller.productList[index].uom}" ?? 'N/A ', style: regularMediumLarge),
                                            ],
                                          ),
                                          const Spacer(),
                                          InkWell(
                                            onTap: () {
                                              controller.showEditOrDeleteBottomSheet(context, controller.productList[index]);
                                            },
                                            child: Image.asset(MyImages.edit, height: Dimensions.space15, color: MyColor.colorBlack),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container(); // Empty container for products not matching the selected category
                                }
                              },
                            )),
                ),
              ],
            )));
  }
}
