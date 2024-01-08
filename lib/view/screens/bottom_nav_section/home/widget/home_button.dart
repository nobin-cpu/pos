import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/util.dart';

class HomeButtonContainer extends StatelessWidget {
  final String imagePath;
  final String text;
  final VoidCallback onPressed;
  final Color color;

  const HomeButtonContainer({
    Key? key,
    required this.imagePath,
    required this.text,
    required this.onPressed, required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(Dimensions.space5),
            padding: const EdgeInsets.all(Dimensions.space15),
            decoration: BoxDecoration(
              boxShadow: MyUtils.getCardShadow(),
              shape: BoxShape.circle,
              color: color,
            ),
            child: Image.asset(
              imagePath,
              height: Dimensions.space50,
              color: MyColor.colorWhite.withOpacity(0.9),
            ),
          ),
          Text(
            text,
            style: const TextStyle(
              color: MyColor.colorBlack,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
