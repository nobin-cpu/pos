import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class BillToSection {
  final pw.Font font;
  final pw.Font boldFont;
  final String customerName; 
  final String customerAddress; 
    final String customerph; 
  final String customerpost; 


  BillToSection( {required this.font, required this.boldFont, required this.customerName,required this.customerAddress,required this.customerph,required this.customerpost}); 
  pw.Widget build() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        pw.Text(
          MyStrings.billTo,
          style: pw.TextStyle(
            font: boldFont,
            color: PdfColors.orange400,
            fontSize: 18,
          ),
        ),
        pw.SizedBox(height: Dimensions.space18),
        pw.Text(
          customerName, 
          style: pw.TextStyle(
            font: boldFont,
            fontSize: 12,
          ),
        ),
        pw.Text(
          customerAddress+customerpost,
          style: pw.TextStyle(
            font: boldFont,
            fontSize: 12,
          ),
        ),
        pw.Text(
          customerph,
          style: pw.TextStyle(
            font: boldFont,
            fontSize: 12,
          ),
        ),
        pw.SizedBox(height: Dimensions.space18),
      ],
    );
  }
}
