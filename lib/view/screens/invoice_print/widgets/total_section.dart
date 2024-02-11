import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:pdf/widgets.dart' as pw;

class TotalSection {
  final pw.Font font;
  final pw.Font boldFont;
  final double totalPrice;
  final double grandTotalPrice;
  final double vat;

  TotalSection({required this.font, required this.boldFont, required this.totalPrice, required this.grandTotalPrice, required this.vat});

  pw.Widget build() {
    print("this is from total section${grandTotalPrice.toString()}");
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
              totalPrice.toStringAsFixed(2),
              style: pw.TextStyle(
                font: font,
                fontSize: 12,
              ),
            ),
            pw.SizedBox(height: Dimensions.space10),
            pw.Text(
              vat.toStringAsFixed(2),
              style: pw.TextStyle(
                font: font,
                fontSize: 12,
              ),
            ),
            pw.SizedBox(height: Dimensions.space15),
            pw.Text(
              grandTotalPrice.toStringAsFixed(2),
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
