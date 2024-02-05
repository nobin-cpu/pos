import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/controller/stock/stock_controller.dart';
import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';
import 'package:flutter_prime/view/components/card/custom_card.dart';
import 'package:get/get.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  @override
  void initState() {
    super.initState();
    final controller = Get.put(StockController());
    controller.loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(title: MyStrings.stock, action: [
          GetBuilder<StockController>(
            builder: (controller) => InkWell(
              onTap: () {
                controller.generatePdf(controller);
              },
              child: Image.asset(MyImages.print, color: MyColor.colorWhite, height: Dimensions.space25),
            ),
          )
        ],),
      body: GetBuilder<StockController>(
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
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(product.name ?? MyStrings.noData),
                            Text('${MyStrings.inStock} ${product.stock ?? '0'} ${product.uom ?? '0'}'),
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
      floatingActionButton: GetBuilder<StockController>(
        builder: (controller) => InkWell(
          onTap: () {
            controller.showupdateStockBottomSheet(context);
          },
          child: Container(
            decoration: const BoxDecoration(color: MyColor.colorBlack, shape: BoxShape.circle),
            padding: const EdgeInsets.all(Dimensions.space15),
            child: Image.asset(
              MyImages.add,
              height: Dimensions.space25,
              color: MyColor.colorWhite,
            ),
          ),
        ),
      ),
    );
  }
}
