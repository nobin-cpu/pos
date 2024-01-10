import 'package:flutter/material.dart';
import 'package:flutter_prime/core/route/route.dart';
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
  const CheckoutScreen({super.key});

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
                child: Table(
                  border: TableBorder.all(),
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: IntrinsicColumnWidth(),
                    2: IntrinsicColumnWidth(),
                    3: IntrinsicColumnWidth(),
                    4: IntrinsicColumnWidth(),
                    5: IntrinsicColumnWidth(),
                  },
                  children: [
                    const TableRow(
                      decoration: BoxDecoration(),
                      children: [
                        TableCell(child: Padding(padding: EdgeInsets.all(Dimensions.space8), child: Center(child: Text(MyStrings.products)))),
                        TableCell(child: Padding(padding:  EdgeInsets.all(Dimensions.space8), child: Center(child: Text(MyStrings.price)))),
                        
                        TableCell(child: Padding(padding: EdgeInsets.all(Dimensions.space8), child: Center(child: Text(MyStrings.discount)))),
                        TableCell(child: Padding(padding:  EdgeInsets.all(Dimensions.space8), child: Center(child: Text(MyStrings.quantity)))),
                        TableCell(child: Padding(padding:  EdgeInsets.all(Dimensions.space8), child: Center(child: Text(MyStrings.total)))),
                        TableCell(child: Padding(padding: EdgeInsets.all(Dimensions.space8), child: Center(child: Text("")))),
                      ],
                    ),
                    ...controller.cartProductList.map((CartProductModel product) {
                      double perProductTotal = double.parse(product.price.toString()) * double.parse(product.quantity.toString());

                      return TableRow(
                        children: [
                          TableCell(child: Padding(padding: const EdgeInsets.all(Dimensions.space8), child: Center(child: Text(product.name ?? "")))),
                          TableCell(child: Padding(padding:  const EdgeInsets.all(Dimensions.space8), child: Center(child: Text('${MyUtils.getCurrency()}${product.price}')))),
                          
                          TableCell(child: Padding(padding:  const EdgeInsets.all(Dimensions.space8), child: Center(child: Text("${product.discountAmount}${controller.percentDiscount == true ? MyUtils.getPercentSymbol() : MyUtils.getCurrency()}")))),
                         TableCell(child: Padding(padding:  const EdgeInsets.all(Dimensions.space8), child: Center(child: Text(product.quantity.toString() + product.uom.toString())))),
                          TableCell(child: Padding(padding:  const EdgeInsets.all(Dimensions.space8), child: Center(child: Text('${MyUtils.getCurrency()}${product.totalAmount} ')))),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(Dimensions.space8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      controller.checkOutProductBottomSheet(context, product);
                                    },
                                    child: Image.asset(
                                      MyImages.edit,
                                      height: Dimensions.space20,
                                    ),
                                  ),
                                  
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
              const SizedBox(height: Dimensions.space100),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.space25, vertical: Dimensions.space20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Get.toNamed(RouteHelper.invoiceScreen);
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
