import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/style.dart';

import '../../../../components/image/custom_svg_picture.dart';

class MenuItems extends StatelessWidget {

  final String imageSrc;
  final String label;
  final VoidCallback onPressed;
  final bool isSvgImage;

  const MenuItems({
    Key? key,
    required this.imageSrc,
    required this.label,
    required this.onPressed,
    this.isSvgImage = true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: Dimensions.space5, horizontal: Dimensions.space10),
        color: MyColor.transparentColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 35, width: 35,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(color: MyColor.screenBgColor, shape: BoxShape.circle),
                  child: isSvgImage ?
                  CustomSvgPicture(image:
                    imageSrc,
                    color: MyColor.colorBlack,
                    height: 17.5, width: 17.5
                  ) :
                  Image.asset(
                    imageSrc,
                    color: MyColor.colorBlack,
                    height: 17.5, width: 17.5
                  ),
                ),
                const SizedBox(width: Dimensions.space15),
                Text(label.tr, style: regularDefault.copyWith(color: MyColor.colorBlack))
              ],
            ),
            Container(
              height: 30, width: 30,
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: MyColor.transparentColor, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_forward_ios_rounded, color: MyColor.colorBlack, size: 15),
            ),
          ],
        ),
      ),
    );
  }
}
