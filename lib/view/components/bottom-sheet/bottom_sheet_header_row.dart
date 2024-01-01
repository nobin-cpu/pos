import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/view/components/bottom-sheet/bottom_sheet_close_button.dart';
import 'package:flutter_prime/view/components/text/bottom_sheet_header_text.dart';

class BottomSheetHeaderRow extends StatelessWidget {
  final String header ;
  final double bottomSpace;
  const BottomSheetHeaderRow({Key? key,this.header = '',this.bottomSpace = Dimensions.space10}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 5,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: MyColor.colorGrey.withOpacity(0.2),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BottomSheetHeaderText(text: header.tr),
                const BottomSheetCloseButton()
              ],
            ),
          
            
          
            SizedBox(height: bottomSpace),
          ],
        ),
       
      ],
    );
  }
}
