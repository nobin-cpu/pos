import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/controller/damage/damage_controller.dart';
import 'package:flutter_prime/view/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:flutter_prime/view/components/buttons/rounded_button.dart';
import 'package:flutter_prime/view/components/text-form-field/custom_text_field.dart';
import 'package:get/get.dart';

class DamageStockUpdateBottomSheet extends StatefulWidget {
  const DamageStockUpdateBottomSheet({super.key});

  @override
  State<DamageStockUpdateBottomSheet> createState() => _DamageStockUpdateBottomSheetState();
}

class _DamageStockUpdateBottomSheetState extends State<DamageStockUpdateBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DamageController>(
      builder: (controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BottomSheetHeaderRow(header: MyStrings.updateStockItems),
       
          const Text(MyStrings.damageQuantity),
          const SizedBox(height: Dimensions.space5),
          CustomTextField(
            onChanged: () {},
            needOutlineBorder: true,
            controller: controller.damageAmountController,
          ),
          const SizedBox(height: Dimensions.space5),
          const Text(MyStrings.damageReason),
          const SizedBox(height: Dimensions.space5),
          CustomTextField (
            onChanged: () {},
            needOutlineBorder: true,
            controller: controller.damageReasonController,
            maxLines: 6,
            ),
          const SizedBox(height: Dimensions.space20),
          RoundedButton(
              text: MyStrings.update,
              press: () {
               controller.updateStockQuantity();
              })
        ],
      ),
    );
  }
}
