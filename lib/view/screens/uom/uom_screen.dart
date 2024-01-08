import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/data/controller/uom/uom_controller.dart';
import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';
import 'package:flutter_prime/view/components/card/custom_card.dart';

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
          action: [
            InkWell(
              customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*.1),
        ),
  onTap: () {
    controller.showAddUomBottomSheet(context);
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
        body: GetBuilder<UomController>(
          builder: (controller) => Padding(
            padding: const EdgeInsets.all(Dimensions.space8),
            child:controller.uomData.isEmpty? Center(child: Image.asset(MyImages.noDataFound, height: Dimensions.space200))
                          : ListView.builder(
              itemCount: controller.uomData.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(Dimensions.space5),
                  child: Slidable(
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.space8), bottomLeft: Radius.circular(Dimensions.space8)),
                          onPressed: (BuildContext context) {
                            controller.deleteUom(controller.uomData[index].id!);
                          },
                          backgroundColor: MyColor.colorRed,
                          foregroundColor: MyColor.colorWhite,
                          icon: Icons.delete,
                          label: MyStrings.delete,
                        ),
                      ],
                    ),
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
          ),
        ),
      ),
    );
  }
}
