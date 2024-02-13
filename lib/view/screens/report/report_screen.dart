import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/core/utils/util.dart';
import 'package:flutter_prime/view/components/card/custom_card.dart';
import 'package:flutter_prime/view/components/custom_loader/custom_loader.dart';
import 'package:flutter_prime/view/screens/report/widgets/filter_section.dart';
import 'package:flutter_prime/view/screens/report/widgets/table_section.dart';
import 'package:get/get.dart';
import 'package:flutter_prime/data/controller/report/report_controller.dart';
import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  void initState() {
    final controller = Get.put(ReportController());
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadDataFromSharedPreferences();
      controller.fetchFilteredInvoiceDetails(controller.startDate);
      

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.colorWhite,
      appBar: CustomAppBar(
        title: MyStrings.report,
        action: [
          GetBuilder<ReportController>(
            builder: (controller) => InkWell(
              onTap: () {
                controller.fetchFilteredInvoiceDetails(controller.startDate);
                controller.generatePdf();
              },
              child: Image.asset(MyImages.print, color: MyColor.colorWhite, height: Dimensions.space25),
            ),
          )
        ],
      ),
      body: GetBuilder<ReportController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CustomLoader());
          } else {
            return Column(
              children: [
                Container(padding: const EdgeInsets.all(Dimensions.space10), child: const FilterSection()),
                CustomCard(
                  width: double.infinity,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * .85,
                      child: const SingleChildScrollView(child: TableSection()),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: GetBuilder<ReportController>(
        builder: (controller) => Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(boxShadow: MyUtils.getCardShadow()),
              child: CustomCard(
                width: Dimensions.space200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              MyStrings.total,
                              style: regularDefault,
                            ),
                            Text(
                              MyStrings.vat,
                              style: regularDefault,
                            ),
                            Text(
                              MyStrings.grandTotal,
                              style: regularDefault,
                            ),
                          ],
                        ),
                       
                          
                           Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${MyUtils.getCurrency()}${controller.totalAmountAllProducts!.toStringAsFixed(2)}',
                                style: regularLarge,
                              ),
                              Text(
                                '${MyUtils.getCurrency()}${controller.totalVatAllProducts!.toStringAsFixed(2)}',
                                style: regularLarge,
                              ),
                              Text(
                                '${MyUtils.getCurrency()}${controller.totalGrandTotalAllProducts}',
                                style: regularLarge,
                              ),
                            ],
                          )
                        ,
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Dimensions.space10),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
