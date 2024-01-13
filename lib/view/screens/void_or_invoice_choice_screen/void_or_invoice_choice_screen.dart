import 'package:flutter/material.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/view/components/bottom-nav-bar/bottom_nav_bar.dart';
import 'package:flutter_prime/view/components/card/custom_card.dart';
import 'package:get/get.dart';

class VoidOrInvoiceScreen extends StatefulWidget {
  const VoidOrInvoiceScreen({super.key});

  @override
  State<VoidOrInvoiceScreen> createState() => _VoidOrInvoiceScreenState();
}

class _VoidOrInvoiceScreenState extends State<VoidOrInvoiceScreen> {
  @override
  Widget build(BuildContext context) {
    bool hasBottomNavBar = (ModalRoute.of(context)?.settings.name == BottomNavBar().toString());
    print(hasBottomNavBar);
    print("this is condition");
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: Dimensions.space50),
          InkWell(
            onTap: () {  Get.toNamed(RouteHelper.voidItemsScreen);},
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Dimensions.space20, Dimensions.space20, Dimensions.space20, Dimensions.space0),
              child: CustomCard(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.space15),
                  child: Center(
                      child: Image.asset(
                    MyImages.voids,
                    color: MyColor.colorBlack,
                    height: Dimensions.space80,
                  )),
                ),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.space10),
          const Text(
            MyStrings.voids,
            style: regularExtraLarge,
          ),
          InkWell(
            onTap: () {
              Get.toNamed(RouteHelper.invoiceScreen);
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Dimensions.space20, Dimensions.space20, Dimensions.space20, Dimensions.space0),
              child: CustomCard(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.space15),
                  child: Center(
                      child: Image.asset(
                    MyImages.invoice,
                    color: MyColor.colorBlack,
                    height: Dimensions.space80,
                  )),
                ),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.space10),
          const Text(
            MyStrings.invoice,
            style: regularExtraLarge,
          )
        ],
      ),
    );
  }
}
