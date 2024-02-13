import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ShopInfoSection {
  final pw.Font font;
  final pw.Font boldFont;
  final String shopkeeperName;
  final String shopAddress;
  final String shopPhoneNo;

  ShopInfoSection({required this.font, required this.boldFont, required this.shopkeeperName, required this.shopAddress, required this.shopPhoneNo});

  pw.Widget build() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        pw.Text(
          shopkeeperName,
          style: pw.TextStyle(
            font: font,
            color: PdfColors.orange400,
            fontSize: 18,
          ),
        ),
        pw.SizedBox(height: Dimensions.space18),
        pw.Text(
          shopAddress,
          style: pw.TextStyle(
            font: font,
            fontSize: 12,
          ),
        ),
        pw.SizedBox(height: Dimensions.space8),
        pw.Text(
          shopPhoneNo,
          style: pw.TextStyle(
            font: font,
            fontSize: 12,
          ),
        ),
        pw.Divider(),
        pw.SizedBox(height: Dimensions.space18),
      ],
    );
  }
}
