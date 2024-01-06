import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';

class GoogleRegSection extends StatelessWidget {
  const GoogleRegSection({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(Dimensions.space10),
          decoration: BoxDecoration(border: Border.all(color: MyColor.textFieldDisableBorderColor), borderRadius: BorderRadius.circular(Dimensions.space8),color: MyColor.colorWhite,),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                MyImages.googleImage,
                height: Dimensions.space30,
                width: Dimensions.space50,
              ),
              const Text(
                MyStrings.signUpwithGoogle,
                style: TextStyle(
                fontSize: Dimensions.space17,
                color: MyColor.colorBlack
              ),
             )
            ],
          ),
        ),
       ],
     );
   }
}
