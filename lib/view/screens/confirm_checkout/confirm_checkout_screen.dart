import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/core/utils/util.dart';
import 'package:flutter_prime/data/controller/confirm_cheakout/confirm_checkout_controller.dart';
import 'package:flutter_prime/data/model/cart/cart_product_model.dart';
import 'package:flutter_prime/data/model/customers/customer_model.dart';
import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';
import 'package:flutter_prime/view/components/card/custom_card.dart';
import 'package:flutter_prime/view/components/divider/custom_divider.dart';
import 'package:flutter_prime/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutter_prime/view/components/text-form-field/custom_drop_down_button_with_text_field2.dart';
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
      print("this is vat status${controller.isVatInPercent}");
      print("this is vat status${controller.isVatEnable}");

      return Scaffold(
       
        appBar: const CustomAppBar(title: MyStrings.checkout),
        body: Column(
          children: [
            CustomCard(
              width: double.infinity,
              child: FittedBox(
                fit: BoxFit.cover,
                child: Container(
                  margin:const EdgeInsets.only(bottom: Dimensions.space40),
                  padding:const EdgeInsets.only(bottom: Dimensions.space30),
                  height: MediaQuery.of(context).size.height * .35,
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.space10),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
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
                              TableCell(child: Padding(padding: EdgeInsets.all(Dimensions.space8), child: Center(child: Text(MyStrings.priceTable)))),
                              TableCell(child: Padding(padding: EdgeInsets.all(Dimensions.space8), child: Center(child: Text(MyStrings.discount)))),
                              TableCell(child: Padding(padding: EdgeInsets.all(Dimensions.space8), child: Center(child: Text(MyStrings.quantity)))),
                              TableCell(child: Padding(padding: EdgeInsets.all(Dimensions.space8), child: Center(child: Text(MyStrings.subTotal)))),
                            ],
                          ),
                          ...controller.cartProductList.map((CartProductModel product) {

                            return TableRow(
                              children: [
                                TableCell(child: Padding(padding: const EdgeInsets.all(Dimensions.space8), child: Center(child: Text(product.name ?? "")))),
                                TableCell(child: Padding(padding: const EdgeInsets.all(Dimensions.space8), child: Center(child: Text('${MyUtils.getCurrency()}${product.price}')))),
                                TableCell(child: Padding(padding: const EdgeInsets.all(Dimensions.space8), child: Center(child: Text('${product.discountAmount}${product.isDiscountInPercent == 1 ? MyUtils.getPercentSymbol() : MyUtils.getCurrency()}')))),
                                TableCell(child: Padding(padding: const EdgeInsets.all(Dimensions.space8), child: Center(child: Text(product.quantity.toString() + product.uom.toString())))),
                                TableCell(child: Padding(padding: const EdgeInsets.all(Dimensions.space8), child: Center(child: Text('${MyUtils.getCurrency()}${product.totalAmount} ')))),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
           
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(boxShadow: MyUtils.getCardShadow()),
              child: CustomCard(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(MyStrings.billAndPayment, style: semiBoldMediumLarge),
                    const SizedBox(height: Dimensions.space10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          MyStrings.total,
                          style: regularDefault.copyWith(color: MyColor.getGreyText()),
                        ),
                        Text('${MyUtils.getCurrency()}${controller.totalPrice.toStringAsFixed(2)}', style: regularDefault.copyWith(color: MyColor.getGreyText())),
                      ],
                    ),
                    const SizedBox(height: Dimensions.space10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(MyStrings.vat, style: regularDefault.copyWith(color: MyColor.getGreyText())),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${controller.isVatInPercent ? MyUtils.getPercentSymbol() : MyUtils.getCurrency()} ${controller.isVatEnable ? controller.vatAmount : MyStrings.zero}',
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
            ),
            const SizedBox(height: Dimensions.space10),
            CustomCard(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(Dimensions.space5),
                          ),
                          child: DropdownButtonFormField<CustomerModel>(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: MyStrings.selectACustomer,
                            ),
                            value: controller.selectedCustomer,
                            onChanged: (CustomerModel? value) {
                              controller.selectedCustomer = value;
                              controller.customerid = value!.id;

                            
                            },
                            items: controller.customerList.map((CustomerModel customer) {
                              return DropdownMenuItem<CustomerModel>(
                                  value: customer,
                                  child: Row(
                                    children: [
                                      Text(customer.name),
                                      const SizedBox(
                                        width: Dimensions.space5,
                                      ),
                                      Text("(${customer.address})", style: regularDefault)
                                    ],
                                  ));
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(width: Dimensions.space15),
                      InkWell(
                          onTap: () {
                            controller.showAddCustomersBottomSheet(context);
                          },
                          child: Image.asset(
                            MyImages.add,
                            height: 15,
                          ))
                    ],
                  )),
                  const SizedBox(width: Dimensions.space10),
                ],
              ),
            ),
            const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: Dimensions.space8),
                  child: Text(MyStrings.selectPaymentType, style: semiBoldMediumLarge),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: CustomCard(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.space10),
                        child: Container(
                          decoration: BoxDecoration(boxShadow: MyUtils.getCardShadow()),
                          child: CustomCard(
                            radius: Dimensions.space5,
                            isPress: true,
                            onPressed: () {
                              if (controller.selectedCustomer != null) {
                                controller.paidOnline = true;
                                controller.paidinCash = false;
                                controller.update();
                              } else {
                                CustomSnackBar.error(errorList: [MyStrings.selectACustomer]);
                              }
                            },
                            width: double.infinity,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: Dimensions.space10,
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
                                  const Text(
                                    MyStrings.paidOnline,
                                    style: regularMediumLarge,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: Dimensions.space10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.space10),
                        child: Container(
                          decoration: BoxDecoration(boxShadow: MyUtils.getCardShadow()),
                          child: CustomCard(
                            radius: Dimensions.space5,
                            isPress: true,
                            onPressed: () {
                              if (controller.selectedCustomer != null) {
                                controller.paidinCash = true;
                                controller.paidOnline = false;
                                controller.update();
                              } else {
                                CustomSnackBar.error(errorList: [MyStrings.selectACustomer]);
                              }
                            },
                            width: double.infinity,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: Dimensions.space10,
                                    child: Radio(
                                      value: true,
                                      groupValue: controller.paidinCash,
                                      onChanged: (bool? value) {
                                        controller.changeCashPaid();

                                        controller.update();
                                      },
                                    ),
                                  ),
                                  const Text(
                                    MyStrings.paidByCash,
                                    style: regularMediumLarge,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                if (controller.paidOnline || controller.paidinCash) {
                  if (controller.paidOnline) {
                    controller.generatePdf();
                    controller.completeCheckout(MyStrings.paidOnline);
                  }
                  if (controller.paidinCash) {
                    controller.generatePdf();
                    controller.completeCheckout(MyStrings.paidByCash);
                  }
                  
                 
                 
                } else {
                  CustomSnackBar.error(errorList: [MyStrings.selectPaymentGatewat]);
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: Dimensions.space15, vertical: Dimensions.space10),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
    });
  }
}
