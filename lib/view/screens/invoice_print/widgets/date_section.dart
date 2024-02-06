import 'package:flutter_prime/core/helper/date_converter.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart'as pw;

class DateSection {
  final pw.Font font;
  final pw.Font boldFont;
    final String dateTime; 

  DateSection({required this.font, required this.boldFont,required this.dateTime, });

  pw.Widget build() {
    return pw.Row(
      children: [
        pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              MyStrings.recieptDate,
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
              DateConverter.formatValidityDate(dateTime),
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
