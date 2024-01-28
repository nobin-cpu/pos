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

class EditCategoryBottomSheet extends StatefulWidget {
  final int? id;
  const EditCategoryBottomSheet({
    Key? key,
    this.id,
  }) : super(key: key);

  @override
  State<EditCategoryBottomSheet> createState() => _EditCategoryBottomSheetState();
}

class _EditCategoryBottomSheetState extends State<EditCategoryBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(
      builder: (controller) => Padding(
        padding: const EdgeInsets.all(Dimensions.space10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BottomSheetHeaderRow(header:MyStrings.editCategory ),
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
            CustomTextField(
              controller: controller.editController,
              onChanged: (value) {
                value = controller.editController.text;
                
              },
              labelText: "",
              animatedLabel: false,
              needOutlineBorder: true,
            ),
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
            RoundedButton(text: MyStrings.done, press: (){
               controller.editCategoryData(widget.id!);
            }),
            
          ],
        ),
      ),
    );
  }
}
