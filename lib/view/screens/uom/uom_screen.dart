import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/data/controller/uom/uom_controller.dart';
import 'package:flutter_prime/data/model/uom/uom_model.dart';
import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';
import 'package:flutter_prime/view/components/card/custom_card.dart';
import 'package:get/get.dart';

class UomScreen extends StatefulWidget {
  @override
  _UomScreenState createState() => _UomScreenState();
}

class _UomScreenState extends State<UomScreen> {
    
  @override
  void initState() {
    super.initState();

    final controller = Get.put(UomController());
    controller.initData();
  }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<UomController>(
      builder: (controller) => Scaffold(
        appBar: CustomAppBar(
          title: MyStrings.uom.tr,
          isActionImage: true,
          isShowActionBtn: true,
          actionIcon: MyImages.add,
          actionPress: () {
            controller.showAddUomBottomSheet(context);
          },
        ),
        body: GetBuilder<UomController>(
            builder: (controller) => Padding(
                  padding: const EdgeInsets.all(Dimensions.space8),
                  child: ListView.builder(
                    itemCount: controller.uomData.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(controller.uomData[index].id.toString()),
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
                          await controller.deleteUom(controller.uomData[index].id!);
                          controller.update();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(Dimensions.space5),
                          child: CustomCard(
                            radius: Dimensions.space8,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Text(controller.uomData[index].title!, style: regularMediumLarge),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    controller.showUomDetails(controller.uomData[index], context);
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
