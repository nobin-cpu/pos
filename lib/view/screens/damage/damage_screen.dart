import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/controller/damage/damage_controller.dart';
import 'package:flutter_prime/data/controller/stock/stock_controller.dart';
import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';
import 'package:flutter_prime/view/components/card/custom_card.dart';
import 'package:get/get.dart';

class DamageScreen extends StatefulWidget {
  const DamageScreen({super.key});

  @override
  State<DamageScreen> createState() => _DamageScreenState();
}

class _DamageScreenState extends State<DamageScreen> {
  @override
  void initState() {
    super.initState();
    final controller = Get.put(DamageController());
    controller.loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: MyStrings.damage),
      body: GetBuilder<DamageController>(
        builder: (controller) {
          return Column(
            children: [
              const SizedBox(
                height: Dimensions.topSectionToContentSpace,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.products.length,
                  itemBuilder: (context, index) {
                    final product = controller.products[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: Dimensions.space5),
                      child: CustomCard(
                        isPress: true,
                        onPressed: () {
                          print(product.id);
                          controller.showupdateStockBottomSheet(context,product.id.toString(),product.name!);
                        },
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(product.name ?? MyStrings.noData),
                            Text('${MyStrings.inStock} ${product.stock ?? '0'}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
