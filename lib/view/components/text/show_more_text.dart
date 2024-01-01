import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';

class ShowMoreText extends StatelessWidget {

  final String text;
  final Callback onTap;

  const ShowMoreText({
    Key? key,
    required this.onTap,
    this.text= MyStrings.showMore
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text.tr,
        style: semiBoldDefault.copyWith(color: MyColor.getPrimaryColor(), decoration:TextDecoration.underline),
      ),
    );
  }
}
