import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/data/controller/damage_history_details/damage_history_details_controller.dart';
import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';
import 'package:flutter_prime/view/components/card/custom_card.dart';
import 'package:flutter_prime/view/components/custom_loader/custom_loader.dart';
import 'package:get/get.dart';

class DamageHistoryDetailsScreen extends StatefulWidget {
  const DamageHistoryDetailsScreen({Key? key}) : super(key: key);

  @override
  State<DamageHistoryDetailsScreen> createState() => _DamageHistoryDetailsScreenState();
}

class _DamageHistoryDetailsScreenState extends State<DamageHistoryDetailsScreen> {
  final controller = Get.put(DamageHistoryDetailsController());

  @override
  void initState() {
    super.initState();

    int damageID = Get.arguments[0];
    print("thisd si damage id ${damageID}");
    controller.fetchDamageDetails(damageID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: MyStrings.damageDetails),
      body: GetBuilder<DamageHistoryDetailsController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(
              child: CustomLoader(),
            );
          } else {
            return ListView.builder(
              itemCount: controller.damageDetails.length,
              itemBuilder: (context, index) {
                final damageDetail = controller.damageDetails[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(Dimensions.space8),
                      child: CustomCard(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(damageDetail.productName),
                              Text("${MyStrings.quantity}: ${damageDetail.quantity}"),
                            ],
                          )),
                    ),
              damageDetail.damageReason!.isNotEmpty ?     const Padding(
                      padding:  EdgeInsets.symmetric(horizontal: Dimensions.space10),
                      child: Text(MyStrings.damageReason,style: semiBoldLarge,),
                    ):const SizedBox(),
                   damageDetail.damageReason!.isNotEmpty ? Padding(
                     padding: const EdgeInsets.all(Dimensions.space8),
                     child: CustomCard(
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(damageDetail.damageReason!),
                            ],
                          )),
                   ) :const SizedBox(),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
