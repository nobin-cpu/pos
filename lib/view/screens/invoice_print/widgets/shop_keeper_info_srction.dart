import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ShopKeeperInfoSection {
  final pw.Font font;
  final pw.Font boldFont;

  ShopKeeperInfoSection({required this.font, required this.boldFont});

  pw.Widget build() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        pw.Text(
          "John Smith",
          style: pw.TextStyle(
            font: font,
            color: PdfColors.orange400,
            fontSize: 18,
          ),
        ),
        pw.SizedBox(height: Dimensions.space18),
        pw.Text(
          "4490 Oak Drive",
          style: pw.TextStyle(
            font: font,
            fontSize: 12,
          ),
        ),
        pw.Text(
          "Albany, NY 12210",
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
