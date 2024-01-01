import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/style.dart';

class BottomSheetLabelText extends StatelessWidget {

  final String text;
  final TextAlign? textAlign;

  const BottomSheetLabelText({
    Key? key,
    required this.text,
    this.textAlign
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.tr,
      textAlign: textAlign,
      style: regularSmall.copyWith(color: MyColor.contentTextColor, fontWeight: FontWeight.w500)
    );
  }
}
