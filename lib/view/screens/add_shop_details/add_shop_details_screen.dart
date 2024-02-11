import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/data/controller/add_shop_details/add_shop_details_controller.dart';
import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';
import 'package:flutter_prime/view/components/card/custom_card.dart';
import 'package:get/get.dart';

class AddShopDetailsScreen extends StatefulWidget {
  const AddShopDetailsScreen({super.key});

  @override
  State<AddShopDetailsScreen> createState() => _AddShopDetailsScreenState();
}

class _AddShopDetailsScreenState extends State<AddShopDetailsScreen> {
  @override
  void initState() {
    final controller = Get.put(AddShopDetailsController());

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.getShopDetailsData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: MyStrings.addShopDetails),
      body: GetBuilder<AddShopDetailsController>(
        builder: (controller) => Padding(
          padding: const EdgeInsets.all(Dimensions.space5),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(Dimensions.space8),
                child: CustomCard(
                  width: double.infinity,
                  
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                       
                        children: [
                          const Text("${MyStrings.shopName}:"),
                          const SizedBox(width: Dimensions.space5),
                          Expanded(
                            child: Text(
                              controller.shopName ?? "",
                              style: semiBoldDefault,
                                overflow: TextOverflow.ellipsis,
                            ),
                          ),
                             const   Spacer(),
                          InkWell(
                            onTap: () {
                               controller.showShopDetailsAddBottomSheet(context);
                            },
                            child: Image.asset(MyImages.edit,height: Dimensions.space20,))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
              padding: const EdgeInsets.all(Dimensions.space8),
                child: CustomCard(
                  width: double.infinity,
                  onPressed: () {
                    controller.showShopDetailsAddBottomSheet(context);
                  },
                  isPress: true,
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                      
                        children: [
                         const Text("${MyStrings.shopAddress}:"),
                          const SizedBox(width: Dimensions.space5),
                           Expanded(
                             child: Text(
                              controller.shopAddress ?? "",
                              style: semiBoldDefault,
                                overflow: TextOverflow.ellipsis,
                                                       ),
                           ),
                             const   Spacer(),
                           InkWell(
                            onTap: () {
                               controller.showShopDetailsAddBottomSheet(context);
                            },
                            child: Image.asset(MyImages.edit,height: Dimensions.space20,))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
              padding: const EdgeInsets.all(Dimensions.space8),
                child: CustomCard(
                  width: double.infinity,
                  onPressed: () {
                    controller.showShopDetailsAddBottomSheet(context);
                  },
                  isPress: true,
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                       
                        children: [
                         const Text("${MyStrings.phoneNo}:"),
                          const SizedBox(width: Dimensions.space5),
                           Expanded(
                             child: Text(
                              controller. phoneNumber?? "",
                              overflow: TextOverflow.ellipsis,
                              style: semiBoldDefault,
                                                       ),
                           ),
                          const   Spacer(),
                           InkWell(
                            onTap: () {
                               controller.showShopDetailsAddBottomSheet(context);
                            },
                            child: Image.asset(MyImages.edit,height: Dimensions.space20,))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
