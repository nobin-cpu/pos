import 'package:flutter/material.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/data/controller/invoice_print/invoice_print_controller.dart';
import 'package:flutter_prime/view/components/will_pop_widget.dart';
import 'package:get/get.dart';

class InvoicePrintScreen extends StatefulWidget {
  const InvoicePrintScreen({Key? key}) : super(key: key);

  @override
  State<InvoicePrintScreen> createState() => _InvoicePrintScreenState();
}

class _InvoicePrintScreenState extends State<InvoicePrintScreen> {
  @override
  void initState() {
    super.initState();
    final controller = Get.put(InvoicePrintController());
    int invoiceId = Get.arguments[0];
    controller.dateTime = Get.arguments[1];
    controller.transectionId = Get.arguments[2];
    controller.isFromVoidScreen = Get.arguments[3];
    controller.grandTotal = Get.arguments[4];
    controller.customerId = Get.arguments[5];
    controller.fetchProducts(invoiceId);
    controller.generatePdf(controller);
    controller.getCustomerById(controller.customerId??0);
    controller.getAndPrintCustomerById(controller.customerId??0);
    print(invoiceId);
    print(controller.transectionId);
    print("..................invoice and transection id from print s...................${invoiceId}");
  }

  @override
  Widget build(BuildContext context) {
    return const WillPopWidget(
      nextRoute: RouteHelper.invoiceDetailsScreen,
      child: Scaffold(),
    );
  }
}
