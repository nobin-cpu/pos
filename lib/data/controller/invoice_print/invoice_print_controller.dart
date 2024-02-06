import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/shared_preference_helper.dart';
import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/util.dart';
import 'package:flutter_prime/data/model/customers/customer_model.dart';
import 'package:flutter_prime/data/model/invoice_details/invoice_details_model.dart';
import 'package:flutter_prime/view/screens/invoice_print/widgets/bill_to_section.dart';
import 'package:flutter_prime/view/screens/invoice_print/widgets/date_section.dart';
import 'package:flutter_prime/view/screens/invoice_print/widgets/shop_keeper_info_srction.dart';
import 'package:flutter_prime/view/screens/invoice_print/widgets/total_section.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvoicePrintController extends GetxController {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  List<InvoiceDetailsModel> products = [];
  int invoiceId = 0;
  int transectionId = 0;
  String dateTime = "";
  bool isFromVoidScreen = false;
   String shopkeeperName = "";
  String shopAddress = "";
  String phoneNumber = "";

  bool isVatEnable = false;
  bool isVatInPercent = false;
  bool isVatActivateOrNot = false;
  int? customerId = 0;

  String? vatamount = "";
  double? grandTotal = 0.0;
  double? perProductTotal = 0.0;
  double? currentTrxVat = 0.0;

  Future<void> fetchProducts(int invoiceId) async {
    print('my invoiceId: ${invoiceId}');
    await databaseHelper.initializeDatabase();
    this.invoiceId = invoiceId;
    List<InvoiceDetailsModel> productList = await databaseHelper.getProductsByTransactionId(invoiceId);
    products = productList;
    print(products);
    print("this id product");
    update();
  }

  void generatePdf(InvoicePrintController controller) async {
    await Printing.layoutPdf(onLayout: (format) => _generatePdf(format, controller));
    Get.offAllNamed(RouteHelper.bottomNavBar);
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, InvoicePrintController controller) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.tiroBanglaRegular();
    final boldFont = await PdfGoogleFonts.robotoBold();

    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.all(Dimensions.space15),
        pageFormat: format,
        build: (context) {
          final currency = MyUtils.getCurrency();
          return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, mainAxisAlignment: pw.MainAxisAlignment.start, children: [
            pw.Center(child: pw.Text(MyStrings.invoiceDetails)),
            pw.SizedBox(height: Dimensions.space15),
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, mainAxisAlignment: pw.MainAxisAlignment.start, children: [shopKeeperInfo(font, boldFont)]),
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [billTo(font, boldFont), date(font, boldFont)]),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                _buildTableRow([
                  MyStrings.products,
                  MyStrings.price,
                  MyStrings.discount,
                  MyStrings.quantity,
                  MyStrings.total,
                ], font),
                ...controller.products.map((InvoiceDetailsModel product) {
                  return _buildTableRow([
                    product.productId.toString() ?? "",
                    '${MyUtils.getCurrency()}${product.price ?? 0}',
                    '${product.discountAmount ?? 0} ${currency}',
                    '${product.quantity.toString()}${product.uom}',
                    '${MyUtils.getCurrency()}${product.totalAmount ?? 0}',
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
            // pw.Spacer(),
            // pw.Row(
            //   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            //   children: [
            //     pw.Text(MyStrings.grandTotal),
            //     pw.Text(grandTotal.toString()),
            //   ],
            // )
          ]);
        },
      ),
    );
    return pdf.save();
  }

  // int? customerIds;
  String? customerName = "";
  String? customerAddress = "";
  String? customerPhNo = "";
  String? customerPost = "";

  Future<void> getAndPrintCustomerById(int id) async {
    final customer = await getCustomerById(id);
    if (customer != null) {
      customerName = customer.name;
      customerAddress = customer.address;
      customerPhNo = customer.phNo;
      customerPost = customer.post;
      print('Customer Details:');
      print('ID: ${customer.id}');
      print('Name: ${customer.name}');
      print('Address: ${customer.address}');
      print('Phone Number: ${customer.phNo}');
      print('Post: ${customer.post}');
      update();
    } else {
      print('No customer found with ID: $id');
    }
  }

  Future<CustomerModel?> getCustomerById(int id) async {
    await databaseHelper.initializeDatabase();
    print("this is customer id to fetch data${id}");
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      final Map<String, dynamic> customerMap = maps.first;
      return CustomerModel.fromMap(customerMap);
    } else {
      print("No customer found with id: $id");
      return null;
    }
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

  shopKeeperInfo(pw.Font font, pw.Font boldFont) {
    return ShopKeeperInfoSection(
      font: font,
      boldFont: boldFont,
      shopkeeperName: shopkeeperName,
      shopAddress: shopAddress,
      shopPhoneNo: phoneNumber
    ).build();
  }

  billTo(pw.Font font, pw.Font boldFont) {
    return BillToSection(font: font, boldFont: boldFont, customerName: customerName ?? "", customerAddress: customerAddress ?? "", customerpost: customerPhNo ?? "", customerph: customerPost ?? "").build();
  }

  totalSection(pw.Font font, pw.Font boldFont) {
    return TotalSection(
      font: font,
      boldFont: boldFont,
      totalPrice: perProductTotal??0.0,
      grandTotalPrice: grandTotal??0.0,
      vat: currentTrxVat??0.0
    ).build();
  }

  date(pw.Font font, pw.Font boldFont) {
    return DateSection(
      font: font,
      boldFont: boldFont,
      dateTime: dateTime,
    ).build();
  }

  double get totalPrice {
    double total = 0.0;
    for (var product in products) {
      total += double.parse(product.totalAmount.toString());
    }
    return total;
  }

  double get grandTotalPrice {
    double totalPriceWithoutVat = totalPrice;
    double vatAmount = (totalPriceWithoutVat * (double.tryParse(vatamount.toString())! / 100.0));

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
