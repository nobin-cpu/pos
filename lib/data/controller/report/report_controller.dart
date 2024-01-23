import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/shared_preference_helper.dart';
import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:get/get.dart';
import 'package:flutter_prime/data/model/invoice_details/invoice_details_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportController extends GetxController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  bool isLoading = true;

  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  late DateTime _startDate;
  late DateTime _endDate;

  String? vatAmount = "";
  bool isVatEnable = false;
  bool isVatInPercent = false;
  bool isFilteringByMonth = false;
  double vat = 0.0;
  int? productVat = 0;


  DateTime get startDate => _startDate;

  void setStartDate(DateTime date) {
    _startDate = date;
    update();
  }

  DateTime get endDate => _endDate;

  void setEndDate(DateTime date) {
    _endDate = date;
    update();
  }

  @override
  void onInit() {
    _startDate = DateTime.now();
    _endDate = DateTime.now();

    super.onInit();
  }

  List<InvoiceDetailsModel> allInvoiceDetails = [];
  List<InvoiceDetailsModel> filteredInvoiceDetails = [];

  Future<void> fetchAllInvoiceDetails() async {
    await _databaseHelper.initializeDatabase();
    try {
      isLoading = true;
      allInvoiceDetails = await _databaseHelper.getAllInvoiceDetails();
    } catch (e) {
      print("Error during fetchAllInvoiceDetails: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Map<String, List<InvoiceDetailsModel>> groupedProducts = {};
  Map<String, double> groupSum = {};

  Map<String, double> groupSubtotalSum = {};
  Map<String, double> groupDiscountSum = {};
  Map<String, double> groupQuantitySum = {};
  Map<String, double> groupGrandtotalSum = {};
  Map<String, double> groupperProductSum = {};
  Map<String, String> groupperProductUom = {};

  void calculateGroupSum() {
    groupSubtotalSum.clear();
    groupDiscountSum.clear();
    groupQuantitySum.clear();
    groupGrandtotalSum.clear();

    for (var productName in groupNames) {
      List<InvoiceDetailsModel> products = getProductsByName(productName);

      double subtotalSum = 0.0;
      double discountSum = 0.0;
      double quantitySum = 0.0;
      double perProductgrandTotal = 0.0;
      
       double perProductPrice = 0.0;
       String perProductUom ="";

      for (var product in products) {
        subtotalSum += product.totalAmount ?? 0.0;
        discountSum += product.discountAmount ?? 0.0;
        quantitySum += product.quantity ?? 0.0;
        perProductgrandTotal += product.grandTotal ?? 0.0;
         perProductPrice = double.tryParse(product.price.toString()) ?? 0.0;
         perProductUom = product.uom??"";
   
      }

      groupSubtotalSum[productName] = subtotalSum;
      groupDiscountSum[productName] = discountSum;
      groupQuantitySum[productName] = quantitySum;
      groupGrandtotalSum[productName] = perProductgrandTotal;
      groupperProductSum[productName] = perProductPrice;
      groupperProductUom[productName] = perProductUom;

    }
    update();
  }

  Future<void> fetchFilteredInvoiceDetails(DateTime date) async {
    try {
      isLoading = true;
      groupedProducts.clear();
      filteredInvoiceDetails = await _databaseHelper.getFilteredInvoiceDetails(
        date,
      );
      for (var invoice in filteredInvoiceDetails) {
        String productName = invoice.name ?? "";

        if (!groupedProducts.containsKey(productName)) {
          groupedProducts[productName] = [];
        }

        groupedProducts[productName]!.add(invoice);
      }
      calculateGroupSum();
    } catch (e) {
      print("Error during fetchFilteredInvoiceDetails: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  List<String> get groupNames {
    return groupedProducts.keys.toList();
  }

  List<InvoiceDetailsModel> getProductsByName(String name) {
    return groupedProducts[name] ?? [];
  }

  double grandTotal = 0.0;
  String calculateGrandTotal() {
    print("this is vattttttttttttttt${vatAmount}");
    grandTotal = 0.0;

    for (var invoice in allInvoiceDetails) {
      grandTotal += invoice.totalAmount!;

      if (invoice.vatAmount != null) {
        grandTotal += double.parse(invoice.vatAmount.toString());
      }

      grandTotal += productVat!;
    }

    update();
    print(grandTotal);
    print("this is grandtotal");
    return grandTotal.toStringAsFixed(2);
  }

  String calculateTotal() {
    double totalAmount = 0.0;

    for (var invoice in allInvoiceDetails) {
      totalAmount += invoice.totalAmount!;
    }
    print(totalAmount);
    print("this is grandtotal");
    update();
    return totalAmount.toStringAsFixed(2);
  }

  Future showDatePickers(BuildContext context, bool isStartDate) async {
    DateTime selectedDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? startDate : endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      isStartDate ? setStartDate(picked) : setEndDate(picked);
    }
  }

  Future<void> fetchMonthWiseInvoiceDetails(DateTime date) async {
    try {
      isLoading = true;

      filteredInvoiceDetails = await _databaseHelper.getMonthWiseInvoiceDetails(
        date.year,
        date.month,
      );
    } catch (e) {
      print("Error during fetchMonthWiseInvoiceDetails: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  void moveFilterMonth() {
    setStartDate(DateTime(_startDate.year, _startDate.month, 1));
    setEndDate(DateTime(_startDate.year, _startDate.month + 1, 0));

    fetchFilteredInvoiceDetails(startDate);
  }

  void moveFilterDateForward() {
    setStartDate(startDate.add(Duration(days: 1)));
    setEndDate(endDate.add(Duration(days: 1)));

    fetchFilteredInvoiceDetails(startDate);
  }

  void moveFilterDateBackward() {
    setStartDate(startDate.subtract(Duration(days: 1)));
    setEndDate(endDate.subtract(Duration(days: 1)));

    fetchFilteredInvoiceDetails(startDate);
  }

  void moveFilterMonthForward() {
    setStartDate(_startDate.add(Duration(days: 30)));
    setEndDate(_endDate.add(Duration(days: 30)));

    fetchFilteredInvoiceDetails(startDate);
  }

  void moveFilterMonthBackward() {
    setStartDate(_startDate.subtract(Duration(days: 30)));
    setEndDate(_endDate.subtract(Duration(days: 30)));

    fetchFilteredInvoiceDetails(startDate);
  }

  double get totalPrice {
    return filteredInvoiceDetails.fold(0.0, (sum, item) => sum + (item.totalAmount ?? 0.0));
  }

  double get grandTotalPrice {
    double totalPriceWithoutVat = totalPrice;
    double vatAmount = (totalPriceWithoutVat * (vat / 100.0));

    return totalPriceWithoutVat + vatAmount;
  }

  //  Map<String, ProductSummary> productSummaries = {};

  // void groupAndSummarizeInvoiceDetails() {
  //   productSummaries.clear();

  //   for (var invoice in filteredInvoiceDetails) {
  //     String productName = invoice.name ?? "";

  //     if (!productSummaries.containsKey(productName)) {
  //       productSummaries[productName] = ProductSummary();
  //     }

  //     ProductSummary summary = productSummaries[productName]!;
  //     summary.discountAmount += double.parse(invoice.discountAmount.toString() ?? "0.0");
  //     summary.quantity += double.parse(invoice.quantity.toString() ?? "0.0");
  //     summary.subtotal += double.parse(invoice.totalAmount.toString() ?? "0.0");
  //     summary.total += double.parse(invoice.grandTotal.toString() ?? "0.0");
  //   }
  //   update();
  // }
}
// class ProductSummary {
//   double discountAmount = 0.0;
//   double quantity = 0.0;
//   double subtotal = 0.0;
//   double total = 0.0;
// }