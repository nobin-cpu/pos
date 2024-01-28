import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
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
          const BottomSheetHeaderRow(header:MyStrings.addCategory,),
          
          const SizedBox(height: Dimensions.space10),
            Row(
            children: [
              const Text(
                MyStrings.categoryName,
                style: mediumLarge,
              ),
              const SizedBox(width: Dimensions.space10),
              Text(
                MyStrings.required,
                style: mediumDefault.copyWith(color: MyColor.getGreyText()),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.space5),
          CustomTextField(
            controller: controller.categoryController,
            onChanged: () {},
            needOutlineBorder: true,
            animatedLabel: true,
            labelText: MyStrings.addaCategory.tr,
          ),
           const SizedBox(height: Dimensions.space5),
           Row(
            children: [
              const Text(
                MyStrings.categoryImage,
                style: mediumLarge,
              ),
              const SizedBox(width: Dimensions.space10),
              Text(
                MyStrings.required,
                style: mediumDefault.copyWith(color: MyColor.getGreyText()),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.space5),
          InkWell(
            onTap: () => controller.pickImage(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Dimensions.space10),
              decoration: BoxDecoration(
                border: Border.all(color: MyColor.borderColor),
                color: MyColor.transparentColor,
                borderRadius: BorderRadius.circular(Dimensions.space8),
              ),
              child: controller.pickedImage != null ? Image.file(controller.pickedImage!, height: Dimensions.space100) : Image.asset(MyImages.uploadImage, color: MyColor.colorBlack, height: Dimensions.space50),
            ),
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
