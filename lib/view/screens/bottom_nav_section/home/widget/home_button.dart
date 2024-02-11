import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/core/utils/util.dart';

class HomeButtonContainer extends StatelessWidget {
  final String imagePath;
  final String text;
  final String description;
  final VoidCallback onPressed;
  final Color color;

  const HomeButtonContainer({
    Key? key,
    required this.imagePath,
    required this.text,
    required this.description,
    required this.onPressed, required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      //  customBorder: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * .9),
      //             ),
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
      
              width: double.infinity,
              margin: const EdgeInsets.all(Dimensions.space8),
              padding: const EdgeInsets.all(Dimensions.space15),
              decoration: BoxDecoration(
                boxShadow: MyUtils.getCardShadow(),
                borderRadius: BorderRadius.circular(Dimensions.space10),
                color: color,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Image.asset(
                imagePath,
                height: Dimensions.space30,
                color: MyColor.colorBlack,
              ),
              const SizedBox(height: Dimensions.space10),
              Text(
              text,
              style: semiBoldExtraLarge
              ),
            Expanded(
              child: Text(
              description,
              style: regularDefault,
                        ),
            ),
          ],)
            ),
          ),
          
        ],
      ),
    );
  }
}
