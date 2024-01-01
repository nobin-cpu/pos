import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';

class NoDataWidget extends StatelessWidget {

  final double margin;

  const NoDataWidget({
    Key? key,
    this.margin = 4
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height / margin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(MyImages.noDataFound, height: 120, width: 120),
          const SizedBox(height: Dimensions.space3),
          Text(
            MyStrings.noDataToShow.tr,
            style: regularLarge.copyWith(color: MyColor.getTextColor()),
          )
        ],
      ),
    );
  }
}
