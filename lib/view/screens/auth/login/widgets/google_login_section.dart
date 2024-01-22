import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/controller/auth/login_controller.dart';
import 'package:flutter_prime/view/components/custom_loader/custom_loader.dart';
import 'package:get/get.dart';

class GoogleLoginSection extends StatelessWidget {
  const GoogleLoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
               controller.handleGoogleSignIn();
            },
            child: Container(
              padding: const EdgeInsets.all(Dimensions.space10),
              decoration: BoxDecoration(
                border: Border.all(color: MyColor.textFieldDisableBorderColor),
                borderRadius: BorderRadius.circular(Dimensions.space8),
                color: MyColor.colorWhite,
              ),
              child: controller.loading? const Padding(
                padding:  EdgeInsets.all(Dimensions.space5),
                child:  CustomLoader(),
              ) :Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    MyImages.googleImage,
                    height: Dimensions.space30,
                    width: Dimensions.space50,
                  ),
                  const Text(
                    MyStrings.loginwithGoogle,
                    style: TextStyle(fontSize: Dimensions.space17, fontWeight: FontWeight.w400, color: MyColor.colorBlack),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
