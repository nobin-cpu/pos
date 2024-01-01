import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/core/utils/util.dart';
import 'package:flutter_prime/data/controller/checkout/cheakout_controller.dart';
import 'package:flutter_prime/data/model/cart/cart_product_model.dart';
import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';
import 'package:get/get.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  void initState() {
    final controller = Get.put(CheakoutController());
    controller.initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheakoutController>(
      builder: (controller) => Scaffold(
        appBar: const CustomAppBar(title: MyStrings.checkout),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SingleChildScrollView(
                
          scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(
                      label: Text(MyStrings.image),
                    ),
                    DataColumn(label: Text(MyStrings.products)),
                    DataColumn(label: Text(MyStrings.price)),
                    DataColumn(label: Text(MyStrings.quantity)),
                    DataColumn(label: Text(MyStrings.total)),
                    DataColumn(label: Text(MyStrings.actions)),
                  ],
                  rows: controller.cartProductList.map((CartProductModel product) {
                        
                        double perProductTotal =double.parse(product.  price.toString()) * double.parse(product.  quantity.toString());
                          
                    return DataRow(
                      cells: [
                        DataCell(
                          ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.space5),
                            child: Image.file(
                              File(product.imagePath ?? ""),
                              height: Dimensions.space40,
                              width: Dimensions.space40,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        DataCell(Text(product.name ?? "")),
                        DataCell(Text('${MyUtils.getCurrency()}${product.price}')),
                        DataCell(Text(product.quantity.toString())),
                        DataCell(Text('${MyUtils.getCurrency()}$perProductTotal ')),
                        DataCell(
                          Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    controller.showEditOrDeleteBottomSheet(
                                      context,
                                      product,
                                    );
                                  },
                                  child: Image.asset(
                                    MyImages.edit,
                                    height: Dimensions.space20,
                                  )),
                              const SizedBox(width: Dimensions.space10),
                              InkWell(
                                  onTap: () {
                                    controller.deleteCartItem(product.id);
                                  },
                                  child: Image.asset(
                                    MyImages.delete,
                                    height: Dimensions.space20,
                                    color: MyColor.colorRed,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 100,)
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.space25, vertical: Dimensions.space20),
          child: InkWell(
            onTap: () {
              controller.showConfirmPopUp(context);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.space10),
                color: MyColor.primaryColor,
              ),
              padding: const EdgeInsets.symmetric(vertical: Dimensions.space15),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(MyImages.checkout, color: MyColor.colorWhite, height: Dimensions.space20),
                  const SizedBox(width: Dimensions.space5),
                  Text(
                    MyStrings.confirmCheckout,
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
