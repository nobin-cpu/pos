import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/date_converter.dart';
import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/core/utils/util.dart';
import 'package:flutter_prime/data/controller/invoice_details/invoice_details_controller.dart';
import 'package:flutter_prime/data/model/product/product_model.dart';
import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';
import 'package:flutter_prime/view/components/buttons/rounded_button.dart';
import 'package:flutter_prime/view/components/card/custom_card.dart';
import 'package:get/get.dart';

class InvoiceDetailsScreen extends StatefulWidget {
  const InvoiceDetailsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<InvoiceDetailsScreen> createState() => _InvoiceDetailsScreenState();
}

class _InvoiceDetailsScreenState extends State<InvoiceDetailsScreen> {
  @override
  void initState() {
    super.initState();
    final controller = Get.put(InvoiceDetailsController());

    int invoiceId = Get.arguments[0];
    controller.dateTime = Get.arguments[1];
    controller.transectionId = Get.arguments[2];
    controller.isFromVoidScreen = Get.arguments[3];
    controller.fetchProducts(invoiceId);
    print(invoiceId);
    print(controller.transectionId);
    print("..................invoice and transection id...................");

  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InvoiceDetailsController>(builder: (controller) {
      return Scaffold(
        appBar: CustomAppBar(
          title:controller.isFromVoidScreen?MyStrings.voidDetails: MyStrings.invoiceDetails,
          action: [
            Text(
              DateConverter.formatValidityDate(controller.dateTime),
              style: semiBoldDefault.copyWith(color: MyColor.colorWhite),
            )
          ],
        ),
        body: GetBuilder<InvoiceDetailsController>(builder: (controller) {
          return   Column(
            children: [
              const SizedBox(height:Dimensions.space20),
            controller.products.isEmpty?Center(child: Image.asset(MyImages.noDataFound,height:Dimensions.space200)):  Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.products.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10,vertical: Dimensions.space5),
                        child: CustomCard(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(controller.products[index].name.toString()),
                                Text("${MyUtils.getCurrency()}${controller.products[index].price}"),
                              ],
                            )),
                      );
                    }),
              )
            ],
          );
        }),
        floatingActionButton:  Row(
          children: [
          controller.isFromVoidScreen?const SizedBox():  Expanded(
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.space10),
                child: RoundedButton(
                    verticalPadding: Dimensions.space5,
                    color: MyColor.colorRed,
                    press: () {
                      print(controller.transectionId);
                      controller.updateVoidStatus();
                    },
                    text: MyStrings.voids),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.space10),
                child: RoundedButton(verticalPadding: Dimensions.space5, press: () {}, text: MyStrings.print),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
    });
  }
}
