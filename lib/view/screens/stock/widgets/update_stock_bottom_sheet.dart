import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/controller/stock/stock_controller.dart';
import 'package:flutter_prime/view/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:flutter_prime/view/components/buttons/rounded_button.dart';
import 'package:flutter_prime/view/components/text-form-field/custom_drop_down_button_with_text_field2.dart';
import 'package:flutter_prime/view/components/text-form-field/custom_text_field.dart';
import 'package:get/get.dart';

class UpdateStockBottomSheet extends StatefulWidget {
  const UpdateStockBottomSheet({super.key});

  @override
  State<UpdateStockBottomSheet> createState() => _UpdateStockBottomSheetState();
}

class _UpdateStockBottomSheetState extends State<UpdateStockBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<StockController>(
      builder: (controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BottomSheetHeaderRow(header: MyStrings.updateStockItems),
          CustomDropDownTextField2(
            needLabel: false,
            selectedValue: controller.productNamecontroller.text.isEmpty ? null : controller.productNamecontroller.text,
            onChanged: (newValue) {
              controller.productNamecontroller.text = newValue!;
              var selectedProduct = controller.productList.firstWhere((product) => product.name == newValue);
              controller.selectedProductId = selectedProduct.id.toString();
              controller.update();
            },
            items: [
              for (var stockProduct in controller.productList)
                DropdownMenuItem<String>(
                  value: stockProduct.name.toString(),
                  child: Text(stockProduct.name!),
                ),
            ],
          ),
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
