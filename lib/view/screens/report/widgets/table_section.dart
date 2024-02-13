import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/date_converter.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/util.dart';
import 'package:flutter_prime/data/controller/report/report_controller.dart';
import 'package:get/get.dart';

class TableSection extends StatefulWidget {
  const TableSection({super.key});

  @override
  State<TableSection> createState() => _TableSectionState();
}

class _TableSectionState extends State<TableSection> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(
      builder: (controller) => Padding(
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
                    child: Center(child: Text(MyStrings.grandTotal)),
                  ),
                ),
              ],
            ),
            ...controller.filteredInvoiceList.map((invoice) {
              controller.totalGrandTotalAllProducts = invoice.totalGrandTotalofAllProduct;
              controller.totalVatAllProducts = invoice.totalVatofAllProduct;
              controller.totalAmountAllProducts = invoice.totalPriceofAllProduct;
              
              return TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.space8),
                      child: Center(child: Text(invoice.name.toString())),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.space8),
                      child: Center(
                        child: Text(
                          '${DateConverter.formatValidityDate(invoice.checkoutTime.toString())}${MyUtils.getCurrency()}',
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.space8),
                      child: Center(child: Text('${invoice.discountAmount!.toStringAsFixed(2)}${MyUtils.getCurrency()}')),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.space8),
                      child: Center(child: Text(invoice.quantity!.toStringAsFixed(2))),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.space8),
                      child: Center(
                        child: Text(
                          '${(invoice.totalAmount!.toStringAsFixed(2) ?? 0)}${MyUtils.getCurrency()}',
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.space8),
                      child: Center(
                        child: Text(
                          '${(invoice.grandTotal ?? 0)}${MyUtils.getCurrency()}',
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
    );
  }
}
