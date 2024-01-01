import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/style.dart';

class RoundedBorderContainer extends StatelessWidget {

  const RoundedBorderContainer({Key? key,
    required this.text,
    this.borderColor= MyColor.primaryColor,
    this.bgColor= MyColor.primaryColor,
    this.horizontalPadding=12,
    this.verticalPadding=5,
    this.textColor= MyColor.primaryColor}) : super(key: key);

  final Color bgColor,textColor,borderColor;
  final double horizontalPadding,verticalPadding;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding,vertical: verticalPadding),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
        border:Border.all(color: borderColor,width: 1.5)
      ),
      child: Text(
        text.tr,
        style: boldDefault.copyWith(color:textColor,fontSize: Dimensions.fontSmall)
      ),
    );
  }
}
