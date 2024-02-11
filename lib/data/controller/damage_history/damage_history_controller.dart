import 'dart:typed_data';

import 'package:flutter_prime/core/helper/date_converter.dart';
import 'package:flutter_prime/core/helper/shared_preference_helper.dart';
import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/util.dart';
import 'package:flutter_prime/data/model/damage_history/damage_history_model.dart';
import 'package:flutter_prime/data/model/damage_history_details/damage_history_details_model.dart';
import 'package:flutter_prime/view/screens/invoice_print/widgets/date_section.dart';
import 'package:flutter_prime/view/screens/invoice_print/widgets/shop_keeper_info_srction.dart';
import 'package:flutter_prime/view/screens/invoice_print/widgets/total_section.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class DamageHistoryController extends GetxController {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  bool isLoading = false;
  List<DamageHistoryItem> damageHistory = [];
  List<DamageDetailItem> damageDetails = [];
  late DateTime selectedDate = DateTime.now();
  bool isFilteringByMonth = false; 

    String shopkeeperName = "";
  String shopAddress = "";
  String phoneNumber = "";

  DateTime get startDate => selectedDate;

  @override
  void onInit() {
    super.onInit();
    loadDamageHistory();
  }

  void loadDamageHistory() async {
    await databaseHelper.initializeDatabase();
    isLoading = true;
    update();

    try {
      damageHistory = await databaseHelper.getDamageHistory();
    } catch (e) {
      print('Error loading damage history: $e');
    } finally {
      isLoading = false;
      update();
    }
  }

void fetchDamageDetails(DateTime selectedDate) async {
  await databaseHelper.initializeDatabase();
  isLoading = true;
  update();

  try {
    if (isFilteringByMonth) {
      selectedDate = DateTime(selectedDate.year, selectedDate.month, 1);
    }
    damageDetails = await databaseHelper.getAllDamageItems(selectedDate, isFilteringByMonth);
  } catch (e) {
    print('Error loading damage details: $e');
  } finally {
    isLoading = false;
    update();
  }
}


  void moveFilterDateBackward() {
    selectedDate = selectedDate.subtract(Duration(days: 1));
    fetchDamageDetails(selectedDate);
  }

  void moveFilterDateForward() {
    selectedDate = selectedDate.add(Duration(days: 1));
    fetchDamageDetails(selectedDate);
  }

  void moveFilterMonthBackward() {
    selectedDate = DateTime(selectedDate.year, selectedDate.month - 1, selectedDate.day);
    fetchDamageDetails(selectedDate);
  }

  void moveFilterMonthForward() {
    selectedDate = DateTime(selectedDate.year, selectedDate.month + 1, selectedDate.day);
    fetchDamageDetails(selectedDate);
  }



shopKeeperInfo(pw.Font font, pw.Font boldFont) {
    return ShopInfoSection(font: font, boldFont: boldFont, shopkeeperName: shopkeeperName, shopAddress: shopAddress, shopPhoneNo: phoneNumber).build();
  }

  date(pw.Font font, pw.Font boldFont) {
    return DateSection(font: font, boldFont: boldFont, dateTime: startDate.toString(),).build();
  }




  void generatePdf(DamageHistoryController controller) async {
    await Printing.layoutPdf(onLayout: (format) => _generatePdf(format, controller));
    Get.offAllNamed(RouteHelper.bottomNavBar);
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, DamageHistoryController controller) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.tiroBanglaRegular();
    final boldFont = await PdfGoogleFonts.robotoBold();

    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.all(Dimensions.space15),
        pageFormat: format,
        build: (context) {
          return pw.Column(children: [
            pw.Center(child: pw.Text(MyStrings.damageHistory)),
            pw.SizedBox(height: Dimensions.space15),
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, mainAxisAlignment: pw.MainAxisAlignment.start, children: [shopKeeperInfo(font, boldFont)]),
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [date(font, boldFont)]),
            pw.SizedBox(height: Dimensions.space15),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                _buildTableRow([
                  MyStrings.date,
                  MyStrings.name,
                  MyStrings.quantity,
                ], font),
                ...controller.damageDetails.map((invoice) {
                  return _buildTableRow([
                    DateConverter.formatValidityDate(invoice.creationTime)?? "",
                    '${invoice.productName}',
                    '${invoice.quantity}',
                  ], font);
                }).toList(),
              ],
            ),
            pw.SizedBox(height: Dimensions.space25),
            
          ]);
        },
      ),
    );
    return pdf.save();
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

 
    Future<void> loadDataFromSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    shopkeeperName = preferences.getString(SharedPreferenceHelper.shopNameKey) ?? "";
    shopAddress = preferences.getString(SharedPreferenceHelper.shopAddressKey) ?? "";
    phoneNumber = preferences.getString(SharedPreferenceHelper.phNoKey) ?? "";
    update();
  }


}

