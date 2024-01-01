import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/style.dart';

class LabelText extends StatelessWidget {

  final bool isRequired;
  final String text;
  final TextAlign? textAlign;

  const LabelText({
    Key? key,
    required this.text,
    this.textAlign,
    this.isRequired = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isRequired?Row(
      children: [
        Text(
        text.tr,
        textAlign: textAlign,
        style: semiBoldLarge.copyWith(color: MyColor.getLabelTextColor())
        ),
        const SizedBox(width: 2,),
        Text('*',style: semiBoldDefault.copyWith(color: MyColor.colorRed),)
      ],
     ) :
    Text(
      text.tr,
      textAlign: textAlign,
      style: semiBoldLarge.copyWith(color: MyColor.getLabelTextColor()),
    );
  }
}
