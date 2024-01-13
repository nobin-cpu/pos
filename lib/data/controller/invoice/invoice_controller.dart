import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/data/model/invoice/invoice_model.dart';
import 'package:get/get.dart';

class InvoiceController extends GetxController {
  final DatabaseHelper databaseHelper = DatabaseHelper();

  late DateTime fromDate;
  late DateTime toDate;
  bool isFrom = false;
  bool isTo = false;
  bool showFilter = false;
  List<InvoiceProductModel> invoiceProductList = [];
  bool isDiscountInpercent = false;

  Future<void> getInvoiceList(DateTime fromDate, DateTime toDate) async {
    await databaseHelper.initializeDatabase();
    invoiceProductList = await databaseHelper.getInvoiceList();

    invoiceProductList = invoiceProductList.where((invoice) {
      DateTime invoiceDate = DateTime.parse(invoice.dateTime!);
      return invoiceDate.isAfter(fromDate) && invoiceDate.isBefore(toDate.add(Duration(days: 1)));
    }).toList();

    print("Filtered invoice list: $invoiceProductList");
    update();
  }

  Future<void> selectDate(BuildContext context, bool isFromDate) async {
    DateTime currentDate = isFromDate ? fromDate : toDate;
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null && selectedDate != currentDate) {
      if (isFromDate) {
        fromDate = selectedDate;
      } else {
        toDate = selectedDate;
      }
      loadInvoices();
    }
  }

  void loadInvoices() {
    getInvoiceList(fromDate, toDate);
  }

  showFilterSection() {
    showFilter = !showFilter;
    update();
  }
}
