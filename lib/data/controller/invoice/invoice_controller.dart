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

 Future<void> getInvoiceList(DateTime fromDate, DateTime toDate, bool showVoid) async {
  await databaseHelper.initializeDatabase();
  invoiceProductList = await databaseHelper.getInvoiceList();

  invoiceProductList = invoiceProductList.where((invoice) {
    DateTime invoiceDate = DateTime.parse(invoice.dateTime!);
    bool isWithinDateRange = invoiceDate.isAfter(fromDate) && invoiceDate.isBefore(toDate.add(Duration(days: 1)));
    bool isMatchingStatus = showVoid ? invoice.status == 'VOID' : invoice.status == 'NOT VOID';
    return isWithinDateRange && isMatchingStatus;
  }).toList();

  print("Filtered invoice list: $invoiceProductList");
  update();
}


 Future<void> selectDate(BuildContext context, bool isFromDate) async {
  DateTime selectedDate = isFromDate ? fromDate : toDate;
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: selectedDate,
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );

  if (pickedDate != null && pickedDate != selectedDate) {
    if (isFromDate) {
     fromDate = pickedDate;
    } else {
      toDate = pickedDate;
    }
    loadInvoices();
  }
}


 void loadInvoices() {
  getInvoiceList(fromDate, toDate, false);
}

  showFilterSection() {
    showFilter = !showFilter;
    update();
  }
}
