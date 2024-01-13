import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_prime/core/helper/date_converter.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
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
    super.initState();

    final controller = Get.put(VoidItemsController());
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      appBar: CustomAppBar(
        title: MyStrings.voids,
        action: [
          
        ],
      ),
      body:  GetBuilder<VoidItemsController>(
       builder: (controller) =>Column(
          children: [
            
            const SizedBox(height: Dimensions.space20),
            Expanded(
              child: ListView.builder(
                itemCount: controller.voidedItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: Dimensions.space5),
                    child: CustomCard(
                      isPress: true,
                      onPressed: () {
                        //Get.toNamed(RouteHelper.invoiceDetailsScreen, arguments: [controller.invoiceProductList[index].id, controller.invoiceProductList[index].dateTime.toString(), controller.invoiceProductList[index].transectionId]);
                      },
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(MyStrings.date, style: semiBoldLarge),
                              Text(DateConverter.formatValidityDate(controller.voidedItems[index].dateTime.toString())),
                            ],
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  const Text(MyStrings.trxId, style: semiBoldLarge),
                                  Text(" ${controller.voidedItems[index].transectionId.toString()}"),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  const Text("${MyStrings.totalPrice} ", style: semiBoldLarge),
                                  Text(
                                    " ${controller.voidedItems[index].totalAmount.toString()} ${MyUtils.getCurrency()}",
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
      ),
    );
  }
}
