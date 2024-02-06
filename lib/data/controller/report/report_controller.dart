import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/shared_preference_helper.dart';
import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/util.dart';
import 'package:flutter_prime/data/controller/invoice_print/invoice_print_controller.dart';
import 'package:flutter_prime/data/model/customers/customer_model.dart';
import 'package:flutter_prime/view/screens/invoice_print/widgets/bill_to_section.dart';
import 'package:flutter_prime/view/screens/invoice_print/widgets/date_section.dart';
import 'package:flutter_prime/view/screens/invoice_print/widgets/shop_keeper_info_srction.dart';
import 'package:flutter_prime/view/screens/invoice_print/widgets/total_section.dart';
import 'package:get/get.dart';
import 'package:flutter_prime/data/model/invoice_details/invoice_details_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class ReportController extends GetxController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late Database _database;

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

  String shopkeeperName = "";
  String shopAddress = "";
  String phoneNumber = "";
  double? totalVat = 0.0;
   double totalSubtotalSum = 0.0;
    double totalGrandtotalSum = 0.0;

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
    fetchAllInvoiceDetails();
    fetchFilteredInvoiceDetails(startDate);
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

  Future<void> _initDatabase() async {
    _database = await _databaseHelper.database;
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
    groupperProductSum.clear();
    groupperProductUom.clear();

   

    groupedProducts.forEach((productName, products) {
      double subtotalSum = 0.0;
      double discountSum = 0.0;
      double quantitySum = 0.0;
      double grandTotalSum = 0.0;
      double productPrice = 0.0;
      String productUom = "";

      products.forEach((product) {
        subtotalSum += product.totalAmount ?? 0.0;
        discountSum += product.discountAmount ?? 0.0;
        quantitySum += product.quantity ?? 0.0;
        grandTotalSum += product.grandTotal ?? 0.0;
        productPrice = double.tryParse(product.price.toString()) ?? 0.0;
        productUom = product.uom ?? "";
      });

      groupSubtotalSum[productName] = subtotalSum / products.length;
      groupDiscountSum[productName] = discountSum / products.length;
      groupQuantitySum[productName] = quantitySum / products.length;
      groupGrandtotalSum[productName] = grandTotalSum / products.length;
      groupperProductSum[productName] = productPrice;
      groupperProductUom[productName] = productUom;

      //totalSubtotalSum += subtotalSum;
      // totalGrandtotalSum += grandTotalSum; // Remove this line
    });

    totalSubtotalSum = groupSubtotalSum.values.reduce((value, element) => value + element);
    totalGrandtotalSum = groupGrandtotalSum.values.reduce((value, element) => value + element);
    totalVat = totalGrandtotalSum - totalSubtotalSum;
    print("Total Subtotal Sum: $totalSubtotalSum");
    print("Total Grandtotal Sum: $totalGrandtotalSum");
    print("Total vat Sum: $totalVat");
    update();
  }

  String? customerName = "";
  String? customerAddress = "";
  String? customerPhNo = "";
  String? customerPost = "";

  shopKeeperInfo(pw.Font font, pw.Font boldFont) {
    return ShopKeeperInfoSection(font: font, boldFont: boldFont, shopkeeperName: shopkeeperName, shopAddress: shopAddress, shopPhoneNo: phoneNumber).build();
  }

  date(pw.Font font, pw.Font boldFont) {
    return DateSection(font: font, boldFont: boldFont, dateTime: startDate.toString(),).build();
  }

  double calculateTotalGrandtotalSum() {
    double totalGrandtotalSum = 0.0;

    for (var grandtotal in groupGrandtotalSum.values) {
      totalGrandtotalSum += grandtotal;
    }
    update();
    return totalGrandtotalSum;
  }

  String customerID = "";
  String settledvat = "";
  int invoiceId = 0;
  Future<void> fetchFilteredInvoiceDetails(DateTime date) async {
    await _databaseHelper.initializeDatabase();
    try {
      isLoading = true;
      groupedProducts.clear();
      filteredInvoiceDetails = await _databaseHelper.getFilteredInvoiceDetails(
        date,
      );
      for (var invoice in filteredInvoiceDetails) {
        String productName = invoice.name ?? "";
        customerID = invoice.selectedCustomerId ?? "";
        settledvat = invoice.vatAmount.toString() ?? "0"; // Set the settled VAT amount

        if (!groupedProducts.containsKey(productName)) {
          groupedProducts[productName] = [];
        }

        groupedProducts[productName]!.add(invoice);
      }
      calculateGroupSum();

      // Print the VAT amount and settled VAT amount
      print("VAT Amount: $vatAmount");
      print("Settled VAT Amount: $settledvat");

      update();
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
        print("this is vat amount------------------------${invoice.vatAmount}");
        grandTotal += double.parse(invoice.vatAmount.toString());
      }

      grandTotal += productVat!;
    }

    update();
    print(grandTotal);
    print("this is grandtotal");
    return grandTotal.toStringAsFixed(2);
  }

  double calculateTotalVatAmount() {
    double totalVatAmount = 0.0;

    for (var invoice in filteredInvoiceDetails) {
      if (invoice.vatAmount != null) {
        totalVatAmount += double.parse(invoice.vatAmount.toString());
      } else {
        settledvat = "0";
      }
    }

    print("this is total vat from repost controlelr $totalVatAmount");

    return totalVatAmount;
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

  double? printGrandTotal = 0.0;
  double? printTotal = 0.0;

  void generatePdf(ReportController controller) async {
    await Printing.layoutPdf(onLayout: (format) => _generatePdf(format, controller));
    Get.offAllNamed(RouteHelper.bottomNavBar);
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, ReportController controller) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.tiroBanglaRegular();
    final boldFont = await PdfGoogleFonts.robotoBold();

    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.all(Dimensions.space15),
        pageFormat: format,
        build: (context) {
          return pw.Column(children: [
            pw.Center(child: pw.Text(MyStrings.report)),
            pw.SizedBox(height: Dimensions.space15),
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, mainAxisAlignment: pw.MainAxisAlignment.start, children: [shopKeeperInfo(font, boldFont)]),
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [date(font, boldFont)]),
            pw.SizedBox(height: Dimensions.space15),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                _buildTableRow([
                  MyStrings.products,
                  MyStrings.price,
                  MyStrings.discount,
                  MyStrings.quantity,
                  MyStrings.subTotal,
                  MyStrings.total,
                ], font),
                ...controller.groupNames.map((invoice) {
                  return _buildTableRow([
                    invoice.toString() ?? "",
                    '${MyUtils.getCurrency()}${groupperProductSum[invoice]?.toString() ?? 0}',
                    '${controller.groupDiscountSum[invoice]?.toString() ?? 0}${MyUtils.getCurrency()}',
                    '${controller.groupQuantitySum[invoice]?.toString()}${controller.groupperProductUom[invoice]?.toString()}',
                    '${MyUtils.getCurrency()}${controller.groupSubtotalSum[invoice]?.toString() ?? 0}',
                    '${(controller.groupGrandtotalSum[invoice]?.toString() ?? 0)}${MyUtils.getCurrency()}'
                  ], font);
                }).toList(),
              ],
            ),
            pw.SizedBox(height: Dimensions.space25),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                totalSection(font, boldFont),
              ],
            )
          ]);
        },
      ),
    );
    return pdf.save();
  }

  totalSection(pw.Font font, pw.Font boldFont) {
    return TotalSection(font: font, boldFont: boldFont, totalPrice: totalSubtotalSum ?? 0.0, grandTotalPrice: totalGrandtotalSum ?? 0.0, vat: totalVat ?? 0.0).build();
  }

  pw.TableRow _buildTableRow(List<String> rowData, pw.Font font) {
    return pw.TableRow(
      children: rowData.map((data) {
        return pw.Container(
          alignment: pw.Alignment.center,
          padding: pw.EdgeInsets.all(Dimensions.space8),
          child: pw.Text(
            data,
            style: pw.TextStyle(font: font),
          ),
        );
      }).toList(),
    );
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

  Future<void> loadDataFromSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    shopkeeperName = preferences.getString(SharedPreferenceHelper.shopKeeperNameKey) ?? "";
    shopAddress = preferences.getString(SharedPreferenceHelper.shopAddressKey) ?? "";
    phoneNumber = preferences.getString(SharedPreferenceHelper.phNoKey) ?? "";
    update();
  }
}
