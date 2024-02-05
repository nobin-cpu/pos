import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart'as pw;

class TotalSection {
  final pw.Font font;
  final pw.Font boldFont;

  TotalSection({required this.font, required this.boldFont});

  pw.Widget build() {
    return pw.Row(
      children: [
        pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              MyStrings.total,
              style: pw.TextStyle(
                font: font,
                fontSize: 12,
              ),
            ),
            pw.SizedBox(height: Dimensions.space10),
            pw.Text(
              MyStrings.vat,
              style: pw.TextStyle(
                font: font,
                fontSize: 12,
              ),
            ),
            
             pw.SizedBox(height: Dimensions.space15),
            pw.Text(
              MyStrings.grandTotal,
              style: pw.TextStyle(
                font: font,
                fontSize: 16,
              ),
            ),
          ],
        ),
        pw.SizedBox(width: Dimensions.space20),
        pw.Column(
         crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              "11/12/2025",
              style: pw.TextStyle(
                font: font,
                fontSize: 12,
              ),
            ),
             pw.SizedBox(height: Dimensions.space10),
            pw.Text(
              "1112/2021",
              style: pw.TextStyle(
                font: font,
                fontSize: 12,
              ),
            ),
            pw.SizedBox(height: Dimensions.space15),
            pw.Text(
              "2021",
              style: pw.TextStyle(
                font: font,
                fontSize: 16,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: Dimensions.space18),
      ],
    );
  }
}
