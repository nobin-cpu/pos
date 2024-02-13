import 'package:flutter/material.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';
import 'package:flutter_prime/view/components/card/custom_card.dart';
import 'package:get/get.dart';

class IssueScreen extends StatefulWidget {
  const IssueScreen({super.key});

  @override
  State<IssueScreen> createState() => _IssueScreenState();
}

class _IssueScreenState extends State<IssueScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: MyStrings.issue),
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.space8),
              child: CustomCard(
                isPress: true,
                onPressed: () {
                  Get.toNamed(RouteHelper.damageScreen);
                },
                width: double.infinity,
                child: const Padding(
                    padding: EdgeInsets.all(Dimensions.space5),
                    child: Text(
                      MyStrings.damage,
                      style: regularLarge,
                    )),
              ),
            ),
          ),
           Expanded(
            child: Padding(
              padding:const EdgeInsets.all(Dimensions.space8),
              child: CustomCard(
                isPress: true,
                onPressed: () {
                  Get.toNamed(RouteHelper.damageHistoryScreen);
                },
                width: double.infinity,
                child:const Padding(
                    padding: EdgeInsets.all(Dimensions.space5),
                    child: Text(
                      MyStrings.damageHistory,
                      style: regularLarge,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
