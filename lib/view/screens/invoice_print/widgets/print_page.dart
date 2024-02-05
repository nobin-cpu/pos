// import 'package:flutter/material.dart';
// import 'package:flutter_prime/core/utils/dimensions.dart';
// import 'package:flutter_prime/core/utils/my_strings.dart';
// import 'package:flutter_prime/core/utils/util.dart';
// import 'package:flutter_prime/data/controller/invoice_print/invoice_print_controller.dart';
// import 'package:flutter_prime/data/model/invoice_details/invoice_details_model.dart';
// import 'package:get/get_state_manager/src/simple/get_state.dart';
// import 'package:pdf/widgets.dart' as pw;

// class Printpage extends StatefulWidget {
//   const Printpage({super.key});

//   @override
//   State<Printpage> createState() => _PrintpageState();
// }

// class _PrintpageState extends State<Printpage> {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<InvoicePrintController>(
//       builder: (controller) => Column(children: [
//             Text(MyStrings.invoiceDetails),
//             SizedBox(height: Dimensions.space15),
//             Table(
//               border: TableBorder.all(),
//               children: [
//                 buildTableRow([
//                   MyStrings.products,
//                   MyStrings.price,
//                   MyStrings.discount,
//                   MyStrings.quantity,
//                   MyStrings.total,
//                 ],font),
//                 ...controller.products.map((InvoiceDetailsModel product) {
//                   return controller.buildTableRow([
//                     product.productId.toString() ?? "",
//                     '${MyUtils.getCurrency()}${product.price ?? 0}',
//                     '${product.discountAmount ?? 0} ${currency}',
//                     '${product.quantity.toString()}${product.uom}',
//                     '${MyUtils.getCurrency()}${product.totalAmount ?? 0}',
//                   ],font);
//                 }).toList(),
//               ],
//             ),
//            Spacer(),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [Text(MyStrings.grandTotal),Text(grandTotal.toString()),],)
//           ]),
//     );;
//   }
// }

// TableRow buildTableRow(List<String> rowData, pw.Font font) {
//   return TableRow(
//     children: rowData.map((data) {
//       return Container(
//         alignment: Alignment.center,
//         padding: EdgeInsets.all(Dimensions.space8),
//         child: Text(
//           data,
//           style: TextStyle(font: font),
//         ),
//       );
//     }).toList(),
//   );
// }