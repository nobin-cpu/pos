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
import 'package:flutter_prime/view/components/card/custom_card.dart';
import 'package:flutter_prime/view/components/checkbox/custom_check_box.dart';
import 'package:flutter_prime/view/components/custom_radio_button.dart';
import 'package:flutter_prime/view/components/divider/custom_divider.dart';
import 'package:flutter_prime/view/components/snack_bar/show_custom_snackbar.dart';
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
    return GetBuilder<ConfirmCheakoutController>(builder: (controller) {
      return Scaffold(
        appBar: const CustomAppBar(title: MyStrings.checkout),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Table(
            border: TableBorder.all(),
            columnWidths: const {
              0: IntrinsicColumnWidth(),
              1: IntrinsicColumnWidth(),
              2: IntrinsicColumnWidth(),
              3: IntrinsicColumnWidth(),
              4: IntrinsicColumnWidth(),
            },
            children: [
              const TableRow(
                decoration: BoxDecoration(),
                children: [
                  TableCell(child: Padding(padding: EdgeInsets.all(Dimensions.space8), child: Center(child: Text(MyStrings.products)))),
                  TableCell(child: Padding(padding: EdgeInsets.all(Dimensions.space8), child: Center(child: Text(MyStrings.price)))),
                  TableCell(child: Padding(padding: EdgeInsets.all(Dimensions.space8), child: Center(child: Text(MyStrings.discount)))),
                  TableCell(child: Padding(padding: EdgeInsets.all(Dimensions.space8), child: Center(child: Text(MyStrings.quantity)))),
                  TableCell(child: Padding(padding: EdgeInsets.all(Dimensions.space8), child: Center(child: Text(MyStrings.total)))),
                ],
              ),
              ...controller.cartProductList.map((CartProductModel product) {
                double perProductTotal = double.parse(product.price.toString()) * double.parse(product.quantity.toString());

                return TableRow(
                  children: [
                    TableCell(child: Padding(padding: const EdgeInsets.all(Dimensions.space8), child: Center(child: Text(product.name ?? "")))),
                    TableCell(child: Padding(padding: const EdgeInsets.all(Dimensions.space8), child: Center(child: Text('${MyUtils.getCurrency()}${product.price}')))),
                    TableCell(child: Padding(padding: const EdgeInsets.all(Dimensions.space8), child: Center(child: Text('${MyUtils.getCurrency()}${product.discountAmount}')))),
                    TableCell(child: Padding(padding: const EdgeInsets.all(Dimensions.space8), child: Center(child: Text(product.quantity.toString() + product.uom.toString())))),
                    TableCell(child: Padding(padding: const EdgeInsets.all(Dimensions.space8), child: Center(child: Text('${MyUtils.getCurrency()}${product.totalAmount} ')))),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.space25, vertical: Dimensions.space20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              CustomCard(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(MyStrings.billAndPayment,style: semiBoldMediumLarge),
                     const SizedBox(height: Dimensions.space10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          MyStrings.total,
                          style: regularDefault.copyWith(color: MyColor.getGreyText()),
                        ),
                        Text(
                          '${MyUtils.getCurrency()}${controller.totalPrice.toStringAsFixed(2)}',
                            style: regularDefault.copyWith(color: MyColor.getGreyText())
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.space10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                         Text(
                          MyStrings.vat,
                           style: regularDefault.copyWith(color: MyColor.getGreyText())
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${MyUtils.getCurrency()} ${controller.isVatEnable ? controller.vatAmount : MyStrings.zero}',
                             style: regularDefault.copyWith(color: MyColor.getGreyText()),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    const CustomDivider(space: Dimensions.space5),
                     const SizedBox(height: Dimensions.space10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          MyStrings.grandTotal,
                          style: regularDefault,
                        ),
                        Text(
                          '${MyUtils.getCurrency()}${controller.isVatEnable ? controller.grandTotalPrice : controller.totalPrice}',
                          style: regularLarge,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Dimensions.space10),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(MyStrings.selectPaymentType,style: semiBoldMediumLarge)),
            Row(
  children: [
    Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.space10),
        child: CustomCard(
          radius: Dimensions.space5,
          isPress: true,
          onPressed: () {
            controller.paidOnline = true;
            controller.paidinCash = false;
            controller.update();
          },
          backgroundColor: controller.paidinCash ? MyColor.getGreyText() : MyColor.colorBlack,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
  children: [
    SizedBox(
      height:Dimensions.space10,
      child: Radio(
        
        value: true,
        groupValue: controller.paidOnline,
        onChanged: (bool? value) {
          controller.changeonlinePaid();
          controller.paidinCash = false;
          controller.update();
        },
      ),
    ),
    Text(
      MyStrings.paidOnline,
      style: regularMediumLarge.copyWith(color: MyColor.colorWhite),
    ),
  ],
),

        ),
      ),
    ),
    const SizedBox(width: Dimensions.space10),
    Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.space10),
        child: CustomCard(
          radius: Dimensions.space5,
          isPress: true,
          onPressed: () {
            controller.paidinCash = true;
            controller.paidOnline = false;
            controller.update();
          },
          backgroundColor: controller.paidOnline ? MyColor.getGreyText() : MyColor.colorBlack,
          width: double.infinity,
          child: FittedBox(
            fit: BoxFit.cover,
            child: Row(
              children: [
                 SizedBox(
                height:Dimensions.space10,
                child: Radio(
                    
                    value: true,
                    groupValue: controller.paidinCash,
                    onChanged: (bool? value) {
            controller.changeCashPaid();
           
            controller.update();
                    },
                ),
              ),
                Text(
                  MyStrings.paidByCash,
                  style: regularMediumLarge.copyWith(color: MyColor.colorWhite),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  ],
),

              InkWell(
                onTap: () {
                  if (controller.paidOnline || controller.paidinCash) {
                    if (controller.paidOnline) {
                      controller.completeCheckout(MyStrings.paidOnline);
                    }
                    if (controller.paidinCash) {
                      controller.completeCheckout(MyStrings.paidByCash);
                    }
                  } else {
                    CustomSnackBar.error(errorList: [MyStrings.selectPaymentGatewat]);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.space10),
                    color: (controller.paidOnline || controller.paidinCash) ? MyColor.primaryColor : MyColor.getGreyText(),
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
    });
  }
}
