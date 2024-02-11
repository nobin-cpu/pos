import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/controller/stock/stock_controller.dart';
import 'package:flutter_prime/view/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:flutter_prime/view/components/buttons/rounded_button.dart';
import 'package:flutter_prime/view/components/text-form-field/custom_drop_down_button_with_text_field2.dart';
import 'package:flutter_prime/view/components/text-form-field/custom_text_field.dart';
import 'package:get/get.dart';

class UpdateStockByProductBottomSheet extends StatefulWidget {
  final String selectedProduct;
  const UpdateStockByProductBottomSheet({super.key, required this.selectedProduct});

  @override
  State<UpdateStockByProductBottomSheet> createState() => _UpdateStockByProductBottomSheetState();
}

class _UpdateStockByProductBottomSheetState extends State<UpdateStockByProductBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<StockController>(
      builder: (controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BottomSheetHeaderRow(header: MyStrings.updateStockItems),
          CustomTextField(onChanged: (){},needOutlineBorder: true,readOnly: true,controller:controller.selectedroductNamecontroller ,),
          const SizedBox(height: Dimensions.space5),
          const Text(MyStrings.stock),
          const SizedBox(height: Dimensions.space5),
          CustomTextField(
            onChanged: () {},
            needOutlineBorder: true,
            controller: controller.stockcontroller,
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
