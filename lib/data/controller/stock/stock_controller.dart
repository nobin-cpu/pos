import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_prime/core/helper/shared_preference_helper.dart';
import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/util.dart';
import 'package:flutter_prime/data/model/product/product_model.dart';
import 'package:flutter_prime/view/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:flutter_prime/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutter_prime/view/screens/invoice_print/widgets/date_section.dart';
import 'package:flutter_prime/view/screens/invoice_print/widgets/shop_keeper_info_srction.dart';
import 'package:flutter_prime/view/screens/stock/widgets/update_stock_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StockController extends GetxController {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  TextEditingController productNamecontroller = TextEditingController();
  TextEditingController stockcontroller = TextEditingController();
  List<ProductModel> products = [];
  List<ProductModel> productList = [];
  String selectedProductId = "";

    String shopkeeperName = "";
  String shopAddress = "";
  String phoneNumber = "";

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> loadProducts() async {
    await databaseHelper.initializeDatabase();
    productList.clear();
    products.clear();
    update();

    try {
      products = await databaseHelper.getProductList();
      productList.add(ProductModel(name: MyStrings.selectOne, id: -1));
      productList.addAll(products);
      print("this is product List=============================================== ${productList.length}");
      update();
    } catch (e) {
      print('Error loading product data: $e');
    }
  }

  updateStockQuantity() async {
    try {
      String productId = selectedProductId;
      String stock = await databaseHelper.getProductStock(selectedProductId);

      int newStock = int.parse(stock) + int.parse(stockcontroller.text);
      await updateProductStock(int.parse(productId), newStock.toString());

      print("Updated stock for product $productId: $newStock");

      loadProducts();
      update();
      Get.back();
    } catch (e) {
      print('Error completing checkout: $e');
      CustomSnackBar.error(errorList: [MyStrings.accountName]);
    }
  }

  Future<void> updateProductStock(int productId, String newStock) async {
    try {
      await databaseHelper.updateProductStock(productId, newStock);
    } catch (e) {
      print('Error updating product stock: $e');
    }
  }

  showupdateStockBottomSheet(BuildContext context) {
    stockcontroller.clear();
    productNamecontroller.clear();
    CustomBottomSheet(child: const UpdateStockBottomSheet()).customBottomSheet(context);
  }

  
 
void generatePdf(StockController controller) async {
  await Printing.layoutPdf(onLayout: (format) => _generatePdf(format, controller));
  Get.offAllNamed(RouteHelper.bottomNavBar);
}
shopKeeperInfo(pw.Font font, pw.Font boldFont) {
    return ShopKeeperInfoSection(font: font, boldFont: boldFont, shopkeeperName: shopkeeperName, shopAddress: shopAddress, shopPhoneNo: phoneNumber).build();
  }


Future<Uint8List> _generatePdf(PdfPageFormat format, StockController controller) async {
  final pdf = pw.Document();
     final font = await PdfGoogleFonts.tiroBanglaRegular();
    final boldFont = await PdfGoogleFonts.robotoBold();

  pdf.addPage(
    pw.Page(
      margin: pw.EdgeInsets.all(Dimensions.space15),
      pageFormat: format,
      build: (context) {
        return pw.Column(children: [
           pw.Center(child: pw.Text(MyStrings.stockReport)),
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
              ...controller.products.map((stock) {
                return _buildTableRow([
                  '${stock.name.toString() ?? 0}',
                  '${stock.stock?.toString() ?? 0} ${stock.uom}',
                ]);
              }).toList(),
            ],
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
    shopkeeperName = preferences.getString(SharedPreferenceHelper.shopKeeperNameKey) ?? "";
    shopAddress = preferences.getString(SharedPreferenceHelper.shopAddressKey) ?? "";
    phoneNumber = preferences.getString(SharedPreferenceHelper.phNoKey) ?? "";
    update();
  }
}
