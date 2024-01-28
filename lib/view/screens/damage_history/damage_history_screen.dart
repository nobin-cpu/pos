import 'package:flutter/material.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';
import 'package:flutter_prime/data/controller/damage_history/damage_history_controller.dart';
import 'package:flutter_prime/data/model/product/product_model.dart';
import 'package:flutter_prime/view/components/card/custom_card.dart';
import 'package:flutter_prime/view/components/custom_loader/custom_loader.dart';
import 'package:get/get.dart';

class DamageHistoryScreen extends StatefulWidget {
  const DamageHistoryScreen({Key? key}) : super(key: key);

  @override
  State<DamageHistoryScreen> createState() => _DamageHistoryScreenState();
}

class _DamageHistoryScreenState extends State<DamageHistoryScreen> {
  @override
  void initState() {
    super.initState();
    final controller = Get.put(DamageHistoryController());
    controller.loadDamageHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: MyStrings.damageHistory),
      body: GetBuilder<DamageHistoryController>(
        builder: (controller) => controller.isLoading
            ? const Center(child: CustomLoader())
            : controller.damageHistory.isEmpty
                ? const Center(child: Text('No damage history available'))
                : ListView.builder(
                    itemCount: controller.damageHistory.length,
                    itemBuilder: (context, index) {
                      final damageItem = controller.damageHistory[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomCard(
                            isPress: true,
                            onPressed: () {
                               print("thisd si damage id from history ${damageItem.damageID}");
                              Get.toNamed(RouteHelper.damageHistoryDetailsScreen, arguments:[ damageItem.damageID]);
                            },
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Text(damageItem.id.toString()), Text("${MyStrings.quantity}: ${damageItem.creationTime.toString()}")],
                            )),
                      );
                    },
                  ),
      ),
    );
  }
}
