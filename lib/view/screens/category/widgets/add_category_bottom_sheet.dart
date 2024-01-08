import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/controller/category/category_controller.dart';
import 'package:flutter_prime/view/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:flutter_prime/view/components/buttons/rounded_button.dart';
import 'package:flutter_prime/view/components/text-form-field/custom_text_field.dart';
import 'package:get/get.dart';

class AddCategoryBottomSheet extends StatefulWidget {
  const AddCategoryBottomSheet({super.key});

  @override
  State<AddCategoryBottomSheet> createState() => _AddCategoryBottomSheetState();
}

class _AddCategoryBottomSheetState extends State<AddCategoryBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(
      builder: (controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const BottomSheetHeaderRow(header:MyStrings.addCategory, ),
          
          const SizedBox(height: Dimensions.space10),
          CustomTextField(
            controller: controller.categoryController,
            onChanged: () {},
            needOutlineBorder: true,
            animatedLabel: true,
            labelText: MyStrings.addaCategory.tr,
          ),
           const SizedBox(height: Dimensions.contentToButtonSpace),
          RoundedButton(
            press: () {
              controller.addCategory();
            },
            text: MyStrings.save,
          ),
        ],
      ),
    );
  }
}
