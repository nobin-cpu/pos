
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/core/utils/util.dart';
import 'package:flutter_prime/data/controller/cart/cart_screen_controller.dart';
import 'package:flutter_prime/data/model/cart/cart_product_model.dart';
import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';
import 'package:flutter_prime/view/components/card/custom_card.dart';
import 'package:flutter_prime/view/components/divider/custom_divider.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    final controller = Get.put(CartScreenController());
    controller.initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartScreenController>(
      builder: (controller) => Scaffold(
        appBar: const CustomAppBar(
          title: MyStrings.cart,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            controller.cartProductList.isEmpty?Center(child: Image.asset(MyImages.emptyCartImage,height: Dimensions.space200,)):
            Expanded(
              child: ListView.builder(
                itemCount: controller.cartProductList.length,
                itemBuilder: (context, index) {
                  CartProductModel cartProductModel = controller.cartProductList[index];
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: Dimensions.space12, right: Dimensions.space12, top: Dimensions.space10),
                        child: InkWell(
                          onTap: () {
                            print("object");
                            controller.showEditOrDeleteBottomSheet(context, controller.cartProductList[index],index);
                          },
                          child: Stack(
                            children: [
                              CustomCard(
                                  paddingLeft: Dimensions.space5,
                                  paddingRight: Dimensions.space5,
                                  paddingTop: Dimensions.space5,
                                  paddingBottom: Dimensions.space5,
                                  backgroundColor: MyColor.colorLightGrey,
                                  width: double.infinity,
                                  child: ListTile(
                                    title: Text(
                                      cartProductModel.name ?? "",
                                      style: semiBoldExtraLarge,
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${MyStrings.unitPrice} ${cartProductModel.price}${MyUtils.getCurrency()}/${cartProductModel.uom}',
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('${MyStrings.quantity} ${cartProductModel.quantity}'),
                                          ],
                                        ),
                                      ],
                                    ),
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(Dimensions.space3),
                                      child: Image.file(
                                        File(cartProductModel.imagePath ?? ""),
                                        height: Dimensions.space70,
                                        width: Dimensions.space70,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    onTap: () {
                                      print("object");
                                      // controller.showQuantityDialog(product, context, index);
                                    },
                                  )),
                              Positioned(
                                top: Dimensions.space0,
                                right: Dimensions.space0,
                                child: Padding(
                                  padding: const EdgeInsets.all(Dimensions.space10),
                                  child: InkWell(
                                    onTap: () {
                                      print("object");
                                      controller.showEditOrDeleteBottomSheet(context, controller.cartProductList[index],index);
                                    },
                                    child: Image.asset(
                                      MyImages.edit,
                                      height: Dimensions.space20,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: Dimensions.space0,
                                right: Dimensions.space0,
                                child: Padding(
                                  padding: const EdgeInsets.all(Dimensions.space10),
                                  child: Container(
                                    padding: const EdgeInsets.all(Dimensions.space5),
                                    decoration: BoxDecoration(color: MyColor.primaryColor, borderRadius: BorderRadius.circular(Dimensions.space15)),
                                    child: Text(
                                      MyUtils.getCurrency() + cartProductModel.totalAmount.toString(),
                                      style: semiBoldLarge.copyWith(color: MyColor.colorWhite),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: Dimensions.space5, left: Dimensions.space20, right: Dimensions.space20),
                        child: CustomDivider(
                          space: Dimensions.space5,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              height: 90,
              color: MyColor.transparentColor,
            )
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.space25, vertical: Dimensions.space20),
          child: InkWell(
            onTap: () {
              Get.offAndToNamed(RouteHelper.cheakOutScreen,);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.space10),
                color: MyColor.primaryColor,
              ),
              padding:const EdgeInsets.symmetric(vertical: Dimensions.space15),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(MyImages.checkout,color: MyColor.colorWhite,height: Dimensions.space20),
                  const SizedBox(width: Dimensions.space5),
                  Text(
                    MyStrings.checkout,
                    style: semiBoldExtraLarge.copyWith(color: MyColor.colorWhite),
                  ),
                  Text(' ${MyUtils.getCurrency()}${controller.totalPrice.toStringAsFixed(2)}', style: regularExtraLarge.copyWith(color: MyColor.colorWhite))
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
