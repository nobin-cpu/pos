import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/date_converter.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/core/utils/util.dart';
import 'package:flutter_prime/data/controller/invoice_details/invoice_details_controller.dart';
import 'package:flutter_prime/data/model/invoice_details/invoice_details_model.dart';
import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';
import 'package:flutter_prime/view/components/buttons/rounded_button.dart';
import 'package:flutter_prime/view/components/card/custom_card.dart';
import 'package:flutter_prime/view/components/divider/custom_divider.dart';
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

    controller.invoiceId = Get.arguments[0];
    controller.dateTime = Get.arguments[1];
    controller.transectionId = Get.arguments[2];
    controller.isFromVoidScreen = Get.arguments[3];
    controller.fetchProducts(controller.invoiceId);
    controller.getVatActivationValue();

    print(controller.transectionId);
    print("..................invoice and transection id...................${controller.invoiceId}");
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InvoiceDetailsController>(builder: (controller) {
      return Scaffold(
        appBar: CustomAppBar(
          title: controller.isFromVoidScreen ? MyStrings.voidDetails : MyStrings.invoiceDetails,
          action: [
            Text(
              DateConverter.formatValidityDate(controller.dateTime),
              style: semiBoldDefault.copyWith(color: MyColor.colorWhite),
            )
          ],
        ),
        body: GetBuilder<InvoiceDetailsController>(builder: (controller) {
          return Column(
            children: [
              CustomCard(
                width: double.infinity,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .45,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Table(
                          border: TableBorder.all(),
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: IntrinsicColumnWidth(),
                            2: IntrinsicColumnWidth(),
                            3: IntrinsicColumnWidth(),
                            4: IntrinsicColumnWidth(),
                            // 5: IntrinsicColumnWidth(),
                          },
                          children: [
                            const TableRow(
                              decoration: BoxDecoration(),
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(Dimensions.space8),
                                    child: Center(child: Text(MyStrings.products)),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(Dimensions.space8),
                                    child: Center(child: Text(MyStrings.price)),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(Dimensions.space8),
                                    child: Center(child: Text(MyStrings.discount)),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(Dimensions.space8),
                                    child: Center(child: Text(MyStrings.quantity)),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(Dimensions.space8),
                                    child: Center(child: Text(MyStrings.total)),
                                  ),
                                ),
                                // TableCell(
                                //   child: Padding(
                                //     padding: EdgeInsets.all(Dimensions.space8),
                                //     child: Center(child: Text("")),
                                //   ),
                                // ),
                              ],
                            ),
                            ...controller.products.map((InvoiceDetailsModel product) {
                              print("this is vat amount ${controller.isVatActivateOrNot}");
                              //  double perProductTotal = double.parse(product.price.toString()) * double.parse(product.quantity.toString());
                              print("this is product price ${product.price}");
                              return TableRow(
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(Dimensions.space8),
                                      child: Center(child: Text(product.productId.toString() ?? "")),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(Dimensions.space8),
                                      child: Center(child: Text('${MyUtils.getCurrency()}${product.price ?? 0}')),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(Dimensions.space8),
                                      child: Center(child: Text('${product.discountAmount ?? 0}${MyUtils.getCurrency()}')),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(Dimensions.space8),
                                      child: Center(child: Text("${product.quantity.toString()}${product.uom}")),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(Dimensions.space8),
                                      child: Center(child: Text('${MyUtils.getCurrency()}${product.totalAmount ?? 0} ')),
                                    ),
                                  ),
                                  // TableCell(
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.all(Dimensions.space8),
                                  //     child: Row(
                                  //       mainAxisAlignment: MainAxisAlignment.center,
                                  //       children: [
                                  //         InkWell(
                                  //           onTap: () {
                                  //            // controller.productEditDialog(context, product);
                                  //           },
                                  //           child: Image.asset(
                                  //             MyImages.edit,
                                  //             height: Dimensions.space20,
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
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
          );
        }),
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
              children: [
                Text(MyStrings.vat, style: regularDefault.copyWith(color: MyColor.getGreyText())),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${ MyUtils.getPlusSymbol()}${controller.products.isNotEmpty ? controller.products.first.settledVat ?? "0" : "0"}${ MyUtils.getCurrency()}',
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
                  '${MyUtils.getCurrency()}${controller.isVatActivateOrNot ? controller.grandTotalPrice : controller.totalPrice}',
                  style: regularLarge,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    const SizedBox(height: Dimensions.space10),
    Row(
      children: [
        controller.isFromVoidScreen
            ? const SizedBox()
            : Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.space10),
                  child: RoundedButton(
                    verticalPadding: Dimensions.space5,
                    color: MyColor.colorRed,
                    press: () {
                      print(controller.transectionId);
                      controller.updateVoidStatus();
                    },
                    text: MyStrings.voids,
                  ),
                ),
              ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.space10),
            child: RoundedButton(
                verticalPadding: Dimensions.space5,
                press: () {
                  Get.toNamed(RouteHelper.invoicePrintScreen, arguments: [controller.invoiceId, controller.dateTime, controller.transectionId, true, controller.isVatActivateOrNot ? controller.grandTotalPrice : controller.totalPrice, controller.customerId, controller.totalPrice, controller.settledVatForCurrentTrx]);
                },
                text: MyStrings.print),
          ),
        ),
      ],
    )
  ],
),
floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      );
    });
  }
}
// controller.products.isNotEmpty && controller.products.first.settledVatFormat == 1 ? MyUtils.getPercentSymbol() :