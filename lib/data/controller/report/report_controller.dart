import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/shared_preference_helper.dart';
import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/util.dart';
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

  bool isFilteringByMonth = false;

  String shopkeeperName = "";
  String shopAddress = "";
  String phoneNumber = "";

  String? customerName = "";
  String? customerAddress = "";
  String? customerPhNo = "";
  String? customerPost = "";

  double? totalGrandTotalAllProducts = 0.0;
  double? totalVatAllProducts = 0.0;
  double? totalAmountAllProducts = 0.0;

  DateTime get startDate => _startDate;

  void setStartDate(DateTime date) {
    _startDate = date;
    update();
  }

  changeDatetoMonthCard() {
    isFilteringByMonth = !isFilteringByMonth;
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

  List<InvoiceDetailsModel> filteredInvoiceList = [];

  Future<void> _initDatabase() async {
    _database = await _databaseHelper.database;
  }

  shopKeeperInfo(pw.Font font, pw.Font boldFont) {
    return ShopInfoSection(font: font, boldFont: boldFont, shopkeeperName: shopkeeperName, shopAddress: shopAddress, shopPhoneNo: phoneNumber).build();
  }

  date(pw.Font font, pw.Font boldFont) {
    return DateSection(
      font: font,
      boldFont: boldFont,
      dateTime: startDate.toString(),
    ).build();
  }

  Future<void> fetchFilteredInvoiceDetails(DateTime date) async {
    await _databaseHelper.initializeDatabase();
    try {
      await _initDatabase();
      isLoading = true;
      filteredInvoiceList.clear();

      filteredInvoiceList = await _databaseHelper.getFilteredInvoiceList(date, isFilteringByMonth);

      print("Settled VAT Amount: $filteredInvoiceList");
      print("Sent date: $date");

      update();
    } catch (e) {
      print("Error during fetchFilteredInvoiceDetails: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> getTotalValues() async {
    for (var item in filteredInvoiceList) {
      item.totalGrandTotalofAllProduct = totalGrandTotalAllProducts;
      item.totalPriceofAllProduct = totalAmountAllProducts;
      item.totalVatofAllProduct = totalVatAllProducts;
    }
    update();
  }

  void generatePdf() async {
    await Printing.layoutPdf(onLayout: (format) => _generatePdf(format));
    Get.offAllNamed(RouteHelper.bottomNavBar);
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
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
                  // MyStrings.discount,
                  MyStrings.quantity,
                  MyStrings.subTotal,
                  MyStrings.total,
                ], font),
                ...filteredInvoiceList.map((invoice) {
                  return _buildTableRow([invoice.name.toString() ?? "", '${MyUtils.getCurrency()}${invoice.price ?? 0}', '${invoice.quantity ?? 0}${MyUtils.getCurrency()}', '${MyUtils.getCurrency()}${invoice.totalAmount ?? 0}', '${(invoice.grandTotal ?? 0)}${MyUtils.getCurrency()}'], font);
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
    return TotalSection(font: font, boldFont: boldFont, totalPrice: totalAmountAllProducts ?? 0.0, grandTotalPrice: totalGrandTotalAllProducts ?? 0.0, vat: totalVatAllProducts ?? 0.0).build();
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
     print("this is month end from controller ");
  }

  void moveFilterMonthForward() {
    final lastDayOfMonth = DateTime(_startDate.year, _startDate.month + 1, 0);

    final nextMonthStartDate = lastDayOfMonth.add(Duration(days: 1));

    setStartDate(nextMonthStartDate);
    setEndDate(DateTime(nextMonthStartDate.year, nextMonthStartDate.month + 1, 0));

    fetchFilteredInvoiceDetails(startDate);
    print("this is month from controller ${startDate}");
    update();
  }

  void moveFilterMonthBackward() {
    final previousMonthStartDate = DateTime(_startDate.year, _startDate.month - 1, 1);

    final lastDayOfPreviousMonth = DateTime(_startDate.year, _startDate.month, 0);

    setStartDate(previousMonthStartDate);
    setEndDate(lastDayOfPreviousMonth);

    fetchFilteredInvoiceDetails(startDate);
  }

  Future<void> loadDataFromSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    shopkeeperName = preferences.getString(SharedPreferenceHelper.shopNameKey) ?? "";
    shopAddress = preferences.getString(SharedPreferenceHelper.shopAddressKey) ?? "";
    phoneNumber = preferences.getString(SharedPreferenceHelper.phNoKey) ?? "";
    update();
  }
}
