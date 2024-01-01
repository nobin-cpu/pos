import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';

class CustomDivider extends StatelessWidget {

  final double space;
  final Color color;

  const CustomDivider({
    Key? key,
    this.space = Dimensions.space20,
    this.color = MyColor.colorBlack
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: space),
        Divider(color: color.withOpacity(0.2), height: 0.5, thickness: 0.5),
        SizedBox(height: space),
      ],
    );
  }
}
