import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/model/invoice/invoice_model.dart';
import 'package:flutter_prime/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:get/get.dart';

class VoidItemsController extends GetxController {
  final DatabaseHelper databaseHelper = DatabaseHelper();

  late DateTime fromDate;
  late DateTime toDate;
  bool isFrom = false;
  bool isTo = false;
  bool showFilter = false;
   List<InvoiceProductModel> invoiceProductsList = []; 
  bool isDiscountInpercent = false;

 Future<void> getInvoiceList(DateTime fromDate, DateTime toDate, bool showVoid) async {
  await databaseHelper.initializeDatabase();
  invoiceProductsList = await databaseHelper.getInvoiceList();

  invoiceProductsList = invoiceProductsList.where((invoice) {
    DateTime invoiceDate = DateTime.parse(invoice.dateTime!);
    bool isWithinDateRange = invoiceDate.isAfter(fromDate) && invoiceDate.isBefore(toDate.add(const Duration(days: 1)));
    
    bool isMatchingStatus = showVoid ? invoice.status == 'NOT VOID' : invoice.status == 'VOID';
    return isWithinDateRange && isMatchingStatus;
  }).toList();

  print("Filtered invoice list: $invoiceProductsList");
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
      if (isFromDate && pickedDate.isAfter(toDate)) {
      
        CustomSnackBar.error(errorList: [MyStrings.fromDateCannotBeAfterDate]);
      } else if (!isFromDate && pickedDate.isBefore(fromDate)) {
       CustomSnackBar.error(errorList: [MyStrings.fromDateCannotBeBeforeDate]);
        
      } else {
        if (isFromDate) {
          fromDate = pickedDate;
        } else {
          toDate = pickedDate;
        }
        loadInvoices();
      }
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
