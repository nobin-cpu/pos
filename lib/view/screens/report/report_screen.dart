import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/date_converter.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/core/utils/util.dart';
import 'package:flutter_prime/data/model/invoice_details/invoice_details_model.dart';
import 'package:flutter_prime/view/components/card/custom_card.dart';
import 'package:flutter_prime/view/components/custom_loader/custom_loader.dart';
import 'package:flutter_prime/view/components/divider/custom_divider.dart';
import 'package:get/get.dart';
import 'package:flutter_prime/data/controller/report/report_controller.dart';
import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final ReportController controller = Get.put(ReportController());

  @override
  void initState() {
    super.initState();
    controller.fetchAllInvoiceDetails();
    //  controller.fetchFilteredInvoiceDetails(controller.startDate);
    controller.calculateGrandTotal();
    controller.calculateTotal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.colorWhite,
      appBar: CustomAppBar(title: "Report"),
      body: GetBuilder<ReportController>(
        builder: (controller) {
          if (controller.isLoading) {
            return Center(child: CustomLoader());
          } else {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.all(Dimensions.space10),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomCard(
                          isPress: true,
                          onPressed: () {
                            controller.isFilteringByMonth = !controller.isFilteringByMonth;
                            controller.update();
                            print("this is vatAmount(((((((((((((((((((((())))))))))))))))))))))${controller.isVatInPercent}");
                          },
                          width: 100,
                          child: Text(controller.isFilteringByMonth ? "Day" : "Month"),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            if (controller.isFilteringByMonth) {
                              controller.moveFilterMonthBackward();
                            } else {
                              controller.moveFilterDateBackward();
                            }
                          },
                          child: Image.asset(
                            MyImages.back,
                            height: Dimensions.space30,
                          ),
                        ),
                      ),
                      Expanded(
                        child: CustomCard(
                          width: 250,
                          child: Center(
                            child: Text(
                              controller.isFilteringByMonth ? DateConverter.formatMonth(controller.startDate) : DateConverter.formatValidityDate(controller.startDate.toString()),
                              style: regularDefault.copyWith(color: MyColor.colorBlack),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            if (controller.isFilteringByMonth) {
                              controller.moveFilterMonthForward();
                            } else {
                              controller.moveFilterDateForward();
                            }
                          },
                          child: Image.asset(
                            MyImages.next,
                            height: Dimensions.space30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomCard(
                  width: double.infinity,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * .45,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(Dimensions.space10),
                          child: Table(
                            border: TableBorder.all(),
                            columnWidths: const <int, TableColumnWidth>{
                              0: IntrinsicColumnWidth(),
                              1: IntrinsicColumnWidth(),
                              2: IntrinsicColumnWidth(),
                              3: IntrinsicColumnWidth(),
                              4: IntrinsicColumnWidth(),
                              5: IntrinsicColumnWidth(),
                            },
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            children: [
                              TableRow(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                ),
                                children: const [
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(Dimensions.space8),
                                      child: Center(child: Text(MyStrings.products)),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(Dimensions.space8),
                                      child: Center(child: Text(MyStrings.onlyPrice)),
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
                                      child: Center(child: Text(MyStrings.subTotal)),
                                    ),
                                  ),
                                 
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(Dimensions.space8),
                                      child: Center(child: Text(MyStrings.total)),
                                    ),
                                  ),
                                ],
                              ),
                              ...controller.groupNames.map((invoice) {
                                  List<InvoiceDetailsModel> products = controller.getProductsByName(invoice);
                               // controller.productVat = int.tryParse(invoice.vatAmount.toString());
                                print("this is product vat from report screen ${controller.productVat}");
                              //  print("this is cheak out time from report screen ${invoice.checkoutTime}");
                                controller.update();
// double subtotal = invoice.totalAmount ?? 0.0;
// double vat = 0.0;

// if (invoice.vatAmount != null) {
//   if (controller.isVatInPercent) {
    
//     vat = (subtotal * (double.parse(invoice.vatAmount!) / 100.0));
//   } else {
    
//     vat = double.parse(invoice.vatAmount!);

    

   
//     subtotal += vat;
//   }
// }

// subtotal += controller.productVat ?? 0.0;


                               return TableRow(
  children: [
    TableCell(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.space8),
        child: Center(child: Text(invoice.toString())),
      ),
    ),
   TableCell(
  child: Padding(
    padding: const EdgeInsets.all(Dimensions.space8),
    child: Center(
      child: Text(
        '${controller.groupperProductSum[invoice]?.toString() ?? '0.0'}${MyUtils.getCurrency()}',
      ),
    ),
  ),
),

    TableCell(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.space8),
        child: Center(child: Text('${controller.groupDiscountSum[invoice]?.toString() ?? '0.0'}${MyUtils.getCurrency()}')),
      ),
    ),
    TableCell(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.space8),
        child: Center(child: Center(child: Text('${controller.groupQuantitySum[invoice]?.toString() ?? '0.0'} ${controller.groupperProductUom[invoice]?.toString()}')),
),
      ),
    ),
    TableCell(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.space8),
        child: Center(child: Text('${controller.groupSubtotalSum[invoice]?.toString() ?? '0.0'}${MyUtils.getCurrency()}')),
      ),
    ),
    TableCell(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.space8),
        child: Center(
          child: Text(
            '${(controller.groupGrandtotalSum[invoice]?.toString()  ?? 0)}${MyUtils.getCurrency()}',
          ),
        ),
      ),
    ),
  ],
);

                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
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
                      Text('${MyUtils.getCurrency()}${controller.totalPrice}', style: regularDefault.copyWith(color: MyColor.getGreyText())),
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
                          '${MyUtils.getCurrency()} ${controller.productVat}',
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
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
