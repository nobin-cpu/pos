import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/date_converter.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/data/model/damage_history_details/damage_history_details_model.dart';
import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';
import 'package:flutter_prime/data/controller/damage_history/damage_history_controller.dart';
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
    controller.fetchDamageDetails(controller.startDate);
    controller.loadDamageHistory();
    controller.loadDataFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.colorWhite,
      appBar: CustomAppBar(
        title: MyStrings.damageHistory,
        action: [
          GetBuilder<DamageHistoryController>(
            builder: (controller) => InkWell(
              onTap: () {
                controller.generatePdf(controller);
              },
              child: Image.asset(MyImages.print, color: MyColor.colorWhite, height: Dimensions.space25),
            ),
          )
        ],
      ),
      body: GetBuilder<DamageHistoryController>(
        builder: (controller) => controller.isLoading
            ? const Center(child: CustomLoader())
            : controller.damageHistory.isEmpty
                ? const Center(child: Text(MyStrings.noDamageHistoryAvailable))
                : Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(Dimensions.space10),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomCard(
                                isPress: true,
                                onPressed: () {
                                  controller.isFilteringByMonth = !controller.isFilteringByMonth;
                                  controller.fetchDamageDetails(controller.startDate);
                                },
                                width: Dimensions.space100,
                                child: Center(child: Text(controller.isFilteringByMonth ? MyStrings.month : MyStrings.day)),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                if (controller.isFilteringByMonth) {
                                  controller.moveFilterMonthBackward();
                                } else {
                                  controller.moveFilterDateBackward();
                                }
                              },
                              child: Image.asset(
                                MyImages.back,
                                height: Dimensions.space30,
                              ),
                            ),
                            Expanded(
                              child: CustomCard(
                                width: Dimensions.space200,
                                child: Center(
                                  child: Text(
                                    controller.isFilteringByMonth ? DateConverter.formatMonth(controller.startDate) : DateConverter.formatValidityDate(controller.startDate.toString()),
                                    style: regularDefault.copyWith(color: MyColor.colorBlack),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                if (controller.isFilteringByMonth) {
                                  controller.moveFilterMonthForward();
                                } else {
                                  controller.moveFilterDateForward();
                                }
                              },
                              child: Image.asset(
                                MyImages.next,
                                height: Dimensions.space30,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Table(
                        border: TableBorder.all(),
                        columnWidths: const {
                          0: IntrinsicColumnWidth(),
                          1: IntrinsicColumnWidth(),
                          2: IntrinsicColumnWidth(),
                          3: IntrinsicColumnWidth(),
                          4: IntrinsicColumnWidth(),
                        },
                        children: [
                          const TableRow(
                            decoration: BoxDecoration(),
                            children: [
                              TableCell(child: Padding(padding: EdgeInsets.all(Dimensions.space8), child: Center(child: Text(MyStrings.date)))),
                              TableCell(child: Padding(padding: EdgeInsets.all(Dimensions.space8), child: Center(child: Text(MyStrings.name)))),
                              TableCell(child: Padding(padding: EdgeInsets.all(Dimensions.space8), child: Center(child: Text(MyStrings.quantity)))),
                            ],
                          ),
                          ...controller.damageDetails.map((DamageDetailItem product) {
                            return TableRow(
                              children: [
                                TableCell(child: Padding(padding: const EdgeInsets.all(Dimensions.space8), child: Center(child: Text(DateConverter.formatValidityDate(product.creationTime) ?? "")))),
                                TableCell(child: Padding(padding: const EdgeInsets.all(Dimensions.space8), child: Center(child: Text(product.productName ?? "")))),
                                TableCell(child: Padding(padding: const EdgeInsets.all(Dimensions.space8), child: Center(child: Text(product.quantity.toString() ?? "")))),

                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ],
                  ),
      ),
    );
  }
}
