import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/core/utils/util.dart';
import 'package:flutter_prime/data/controller/confirm_cheakout/confirm_checkout_controller.dart';
import 'package:flutter_prime/data/model/cart/cart_product_model.dart';
import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';
import 'package:get/get.dart';

class ConfirmCheckOutScreen extends StatefulWidget {
  const ConfirmCheckOutScreen({super.key});

  @override
  State<ConfirmCheckOutScreen> createState() => _ConfirmCheckOutScreenState();
}

class _ConfirmCheckOutScreenState extends State<ConfirmCheckOutScreen> {
  @override
  void initState() {
    final controller = Get.put(ConfirmCheakoutController());
    controller.initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConfirmCheakoutController>(
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
                    // DataColumn(
                    //   label: Text(MyStrings.image),
                    // ),
                    DataColumn(label: Text(MyStrings.products)),
                    DataColumn(label: Text(MyStrings.price)),
                    DataColumn(label: Text(MyStrings.quantity)),
                    DataColumn(label: Text(MyStrings.total)),
                  ],
                  rows: controller.cartProductList.map((CartProductModel product) {
                    // double perProductTotal = double.parse(product.price.toString()) * double.parse(product.quantity.toString());
      
                    return DataRow(
                      cells: [
                        // DataCell(
                        //   ClipRRect(
                        //     borderRadius: BorderRadius.circular(Dimensions.space5),
                        //     child: Image.file(
                        //       File(product.imagePath ?? ""),
                        //       height: Dimensions.space40,
                        //       width: Dimensions.space40,
                        //       fit: BoxFit.cover,
                        //     ),
                        //   ),
                        // ),
                        DataCell(Text(product.name ?? "")),
                        DataCell(Text('${MyUtils.getCurrency()}${product.price}')),
                        DataCell(Text(product.quantity.toString())),
                        DataCell(Text('${MyUtils.getCurrency()}${product.totalAmount} ')),
                      ],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: Dimensions.space100)
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.space25, vertical: Dimensions.space20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width / 2, bottom: Dimensions.space10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.space10),
                  color: MyColor.primaryColor,
                ),
                padding: const EdgeInsets.symmetric(vertical: Dimensions.space10, horizontal: Dimensions.space5),
                width: double.infinity,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            MyStrings.total,
                            style: semiBoldLarge.copyWith(color: MyColor.colorWhite),
                          ),
                          Text('${MyUtils.getCurrency()}${controller.totalPrice.toStringAsFixed(2)}', style: regularLarge.copyWith(color: MyColor.colorWhite))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            MyStrings.vat,
                            style: semiBoldLarge.copyWith(color: MyColor.colorWhite),
                          ),
                          Text('${MyUtils.getCurrency()} ${controller.vatAmount}', style: regularLarge.copyWith(color: MyColor.colorWhite))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              print(controller.grandTotalPrice);
                            },
                            child: Text(
                              MyStrings.grandTotal,
                              style: semiBoldLarge.copyWith(color: MyColor.colorWhite),
                            ),
                          ),
                          Text('${MyUtils.getCurrency()}${controller.grandTotalPrice}', style: regularLarge.copyWith(color: MyColor.colorWhite))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // controller.showConfirmPopUp(context);
                  print(controller.grandTotalPrice.toString());
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
                      Image.asset(MyImages.pos, color: MyColor.colorWhite, height: Dimensions.space20),
                      const SizedBox(width: Dimensions.space5),
                      Text(
                        MyStrings.printAndClear,
                        style: semiBoldExtraLarge.copyWith(color: MyColor.colorWhite),
                      ),
                      // Text(' ${MyUtils.getCurrency()}${controller.totalPrice.toStringAsFixed(2)}', style: regularExtraLarge.copyWith(color: MyColor.colorWhite))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
