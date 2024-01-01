import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/data/controller/category/category_controller.dart';
import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';
import 'package:flutter_prime/view/components/card/custom_card.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    final controller = Get.put(CategoryController());
    
    controller.initData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(
      builder: (controller) => Scaffold(
        appBar: CustomAppBar(
          title: MyStrings.category,
          isShowBackBtn: true,
          isActionImage: true,
          isShowActionBtn: true,
          actionIcon: MyImages.add,
          actionPress: () {
            controller.showAddCategoryBottomSheet(context);
          },
        ),
        body: GetBuilder<CategoryController>(
            builder: (controller) => Padding(
                  padding: const EdgeInsets.all(Dimensions.space8),
                  child: ListView.builder(
                    itemCount: controller.catagoryData.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(controller.catagoryData[index].id.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          decoration: BoxDecoration(color: MyColor.colorRed, borderRadius: BorderRadius.circular(Dimensions.space8)),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: Dimensions.space15),
                          child: Image.asset(
                            MyImages.delete,
                            height: Dimensions.space20,
                            color: MyColor.colorWhite,
                          ),
                        ),
                        onDismissed: (direction) async {
                          await controller.deleteCategory(controller.catagoryData[index].id!);
                          controller.update();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(Dimensions.space5),
                          child: CustomCard(
                            radius: Dimensions.space8,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Text(controller.catagoryData[index].title!, style: regularMediumLarge),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    controller.editCategoryDetails(controller.catagoryData[index], context);
                                  },
                                  child: Image.asset(
                                    MyImages.edit,
                                    height: Dimensions.space15,
                                    color: MyColor.colorBlack,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )),
      ),
    );
      
    
  }
}
