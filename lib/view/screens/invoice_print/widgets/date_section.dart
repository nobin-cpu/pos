import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart'as pw;

class DateSection {
  final pw.Font font;
  final pw.Font boldFont;

  DateSection({required this.font, required this.boldFont});

  pw.Widget build() {
    return pw.Row(
      children: [
        pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              "Receipt Date",
              style: pw.TextStyle(
                font: font,
                color: PdfColors.orange400,
                fontSize: 12,
              ),
            ),
            pw.SizedBox(height: Dimensions.space10),
            pw.Text(
              "P.O.#",
              style: pw.TextStyle(
                font: font,
                color: PdfColors.orange400,
                fontSize: 12,
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
          ],
        ),
        pw.SizedBox(height: Dimensions.space18),
      ],
    );
  }
}
