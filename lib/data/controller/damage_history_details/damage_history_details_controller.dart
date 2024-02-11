import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/shared_preference_helper.dart';
import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/controller/stock/stock_controller.dart';
import 'package:flutter_prime/data/model/damage_history_details/damage_history_details_model.dart';
import 'package:flutter_prime/view/screens/invoice_print/widgets/shop_keeper_info_srction.dart';
import 'package:get/get.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DamageHistoryDetailsController extends GetxController {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  bool isLoading = false;

  String dateTime = "";
  String shopkeeperName = "";
  String shopAddress = "";
  String phoneNumber = "";

  // int damageID = 0;

  List<DamageDetailItem> damageDetails = [];

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchDamageDetails(int damageID) async {
    await databaseHelper.initializeDatabase();
    isLoading = true;
    update();

    try {
      damageDetails = await databaseHelper.getDamageDetails(damageID);
      isLoading = false;
      update();
    } catch (e) {
      print('Error loading damage details: $e');
      isLoading = false;
      update();
    }
  }

  void generatePdf(DamageHistoryDetailsController controller) async {
    await Printing.layoutPdf(onLayout: (format) => _generatePdf(format, controller));
    Get.offAllNamed(RouteHelper.bottomNavBar);
  }

  shopKeeperInfo(pw.Font font, pw.Font boldFont) {
    return ShopInfoSection(font: font, boldFont: boldFont, shopkeeperName: shopkeeperName, shopAddress: shopAddress, shopPhoneNo: phoneNumber).build();
  }

  String ? damageReason = "";
  Future<Uint8List> _generatePdf(PdfPageFormat format, DamageHistoryDetailsController controller) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.tiroBanglaRegular();
    final boldFont = await PdfGoogleFonts.robotoBold();

    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.all(Dimensions.space15),
        pageFormat: format,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
            pw.Center(child: pw.Text(MyStrings.damageDetails)),
            pw.SizedBox(height: Dimensions.space15),
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, mainAxisAlignment: pw.MainAxisAlignment.start, children: [shopKeeperInfo(font, boldFont)]),
            pw.SizedBox(height: Dimensions.space15),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                _buildTableRow([
                  MyStrings.products,
                  MyStrings.quantity,
                ]),
                ...controller.damageDetails.map((stock) {
                  damageReason = stock.damageReason?.toString();
                  return _buildTableRow([
                    '${stock.productName.toString() ?? 0}',
                    '${stock.quantity?.toString() ?? 0} ',
                  ]);
                }).toList(),
              ],
            ),
             pw.SizedBox(height: Dimensions.space18),
            pw.Text(MyStrings.damageReason),
             pw.SizedBox(height: Dimensions.space10),
            pw.Container(
              padding:const pw.EdgeInsets.all(Dimensions.space15),
              decoration:pw.BoxDecoration(border:pw. Border.all()),
              child: pw.Text(damageReason!),
            )
          ]);
        },
      ),
    );
    return pdf.save();
  }

  pw.TableRow _buildTableRow(List<String> rowData) {
    final font = PdfGoogleFonts.robotoRegular();
    return pw.TableRow(
      children: rowData.map((data) {
        return pw.Container(
          alignment: pw.Alignment.center,
          padding: pw.EdgeInsets.all(Dimensions.space8),
          child: pw.Text(
            data,
          ),
        );
      }).toList(),
    );
  }

  Future<void> loadDataFromSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    shopkeeperName = preferences.getString(SharedPreferenceHelper.shopNameKey) ?? "";
    shopAddress = preferences.getString(SharedPreferenceHelper.shopAddressKey) ?? "";
    phoneNumber = preferences.getString(SharedPreferenceHelper.phNoKey) ?? "";
    update();
  }
}
