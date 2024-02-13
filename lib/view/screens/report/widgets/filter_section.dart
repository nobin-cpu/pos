import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/date_converter.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/data/controller/report/report_controller.dart';
import 'package:flutter_prime/view/components/card/custom_card.dart';
import 'package:get/get.dart';

class FilterSection extends StatefulWidget {
  const FilterSection({super.key});

  @override
  State<FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(
      builder: (controller) => Row(
        children: [
          Expanded(
            child: CustomCard(
              isPress: true,
              onPressed: () {
                controller.changeDatetoMonthCard();
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
    );
  }
}
