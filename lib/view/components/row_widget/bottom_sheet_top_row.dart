import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/view/components/divider/custom_divider.dart';
import 'package:get/get.dart';

import '../../../core/utils/my_color.dart';
import '../buttons/custom_circle_animated_button.dart';

class BottomSheetTopRow extends StatelessWidget {

  final String header;
  final double bottomSpace;
  final Color bgColor;

  const BottomSheetTopRow({
    Key? key,
    required this.header,
    this.bottomSpace = 10,
    this.bgColor = MyColor.containerBgColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(header.tr, style: regularDefault.copyWith(fontWeight: FontWeight.w600)),
            CustomCircleAnimatedButton(
              onTap: (){
                Get.back();
              },
              height: 30,
              width: 30,
              backgroundColor: bgColor,
              child: const Icon(Icons.clear, color: MyColor.colorBlack, size: 15),
            )
          ],
        ),
        const CustomDivider(),
      ],
    );
  }
}
