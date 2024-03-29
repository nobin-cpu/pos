import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/date_converter.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/core/utils/util.dart';
import 'package:flutter_prime/data/controller/void_items/void_items_controller.dart';
import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';
import 'package:flutter_prime/view/components/card/custom_card.dart';
import 'package:get/get.dart';

class VoidItemsScreen extends StatefulWidget {
  const VoidItemsScreen({super.key});

  @override
  State<VoidItemsScreen> createState() => _VoidItemsScreenState();
}

class _VoidItemsScreenState extends State<VoidItemsScreen> {
  @override
  void initState() {
    final controller = Get.put(VoidItemsController());
    controller.fromDate = DateTime.now().subtract(Duration(days: 7));
    controller.toDate = DateTime.now();
    controller.loadInvoices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VoidItemsController>(builder: (controller) {
      return Scaffold(
        backgroundColor: MyColor.getScreenBgColor(),
        appBar: CustomAppBar(
          title: MyStrings.voids,
          action: [
            InkWell(
                child: Padding(
              padding: const EdgeInsets.all(Dimensions.space10),
              child: InkWell(
                  onTap: () {
                    controller.showFilterSection();
                  },
                  child: Image.asset(
                    MyImages.filter,
                    color: MyColor.colorWhite,
                    height: Dimensions.space20,
                  )),
            ))
          ],
        ),
        body: Column(
          children: [
          controller.showFilter?
          
            Row(
              children: [
                 Expanded(
    child: Padding(
      padding: const EdgeInsets.all(Dimensions.space8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(Dimensions.space5),
            child: Text(MyStrings.from, style: semiBoldLarge),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: controller.isFrom ? MyColor.getGreyText() : MyColor.colorBlack,
              ),
              borderRadius: BorderRadius.circular(Dimensions.space8),
              color: MyColor.getGreyText(),
            ),
            child: CustomCard(
              isPress: true,
              onPressed: () {
                controller.isFrom = true;
                controller.isTo = false;
                controller.selectDate(context, true);
              },
              width: double.infinity,
              child: Row(
                children: [
                  Image.asset(MyImages.calendar, height: Dimensions.space20),
                  const SizedBox(width: Dimensions.space10),
                  Text(DateConverter.formatValidityDate(controller.fromDate.toString())),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  ),
  Expanded(
    child: Padding(
      padding: const EdgeInsets.all(Dimensions.space8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(Dimensions.space5),
            child: Text(
              MyStrings.to,
              style: semiBoldLarge,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: controller.isTo ? MyColor.getGreyText() : MyColor.primaryColor,
              ),
              borderRadius: BorderRadius.circular(Dimensions.space8),
              color: MyColor.getGreyText(),
            ),
            child: CustomCard(
              isPress: true,
              onPressed: () {
                controller.isFrom = false;
                controller.isTo = true;
                controller.selectDate(context, false); // Pass false for toDate
              },
              width: double.infinity,
              child: Row(
                children: [
                  Image.asset(MyImages.calendar, height: Dimensions.space20),
                  const SizedBox(width: Dimensions.space10),
                  Text(DateConverter.formatValidityDate(controller.toDate.toString())),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  ),
              ],
            )
          :const SizedBox(),
           const SizedBox(height:Dimensions.space20),
           
          controller.invoiceProductsList.isEmpty?Center(
                    child: Image.asset(
                    MyImages.noDataFound,
                    height: Dimensions.space200,
                  )):  Expanded(
              child: ListView.builder(
                itemCount: controller.invoiceProductsList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: Dimensions.space5),
                    child: CustomCard(
                      isPress: true,
                      onPressed: () {
                        Get.toNamed(RouteHelper.invoiceDetailsScreen, arguments: [controller.invoiceProductsList[index].id,controller.invoiceProductsList[index].dateTime.toString(),controller.invoiceProductsList[index].transectionId,true]);
                      },
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(MyStrings.date, style: semiBoldLarge),
                              Text(DateConverter.formatValidityDate(controller.invoiceProductsList[index].dateTime.toString())),
                            ],
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  const Text(MyStrings.trxId, style: semiBoldLarge),
                                  Text(" ${controller.invoiceProductsList[index].transectionId.toString()}"),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  const Text("${MyStrings.totalPrice} ", style: semiBoldLarge),
                                  Text(
                                    " ${controller.invoiceProductsList[index].totalAmount.toString()} ${MyUtils.getCurrency()}",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
