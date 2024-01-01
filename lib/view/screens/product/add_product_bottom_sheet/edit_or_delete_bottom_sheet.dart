
import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/data/controller/product/product_controller.dart';
import 'package:flutter_prime/view/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:flutter_prime/view/components/buttons/rounded_button.dart';
import 'package:flutter_prime/view/components/text-form-field/custom_drop_down_button_with_text_field2.dart';
import 'package:flutter_prime/view/components/text-form-field/custom_drop_down_text_field.dart';
import 'package:flutter_prime/view/components/text-form-field/custom_text_field.dart';
import 'package:get/get.dart';

class EditOrDeleteBottomSheet extends StatefulWidget {
  final int id;
  const EditOrDeleteBottomSheet({super.key, required this.id});

  @override
  State<EditOrDeleteBottomSheet> createState() => _EditOrDeleteBottomSheetState();
}

class _EditOrDeleteBottomSheetState extends State<EditOrDeleteBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.all(Dimensions.space15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const BottomSheetHeaderRow(),
            const Text(
              MyStrings.productName,
              style: semiBoldDefault,
            ),
            CustomTextField(
              onChanged: () {},
              controller: controller.newNameController,
              needOutlineBorder: true,
            ),
            const SizedBox(height: Dimensions.space10),
            const Text(
              MyStrings.productPrice,
              style: semiBoldDefault,
            ),
            CustomTextField(
              onChanged: () {},
              controller: controller.newPriceController,
              needOutlineBorder: true,
            ),
            const SizedBox(height: Dimensions.space10),
            const Text(
              MyStrings.productImage,
              style: semiBoldDefault,
            ),
            controller.newPickedImage != null
                ? Container(
                    width: double.infinity,
                    decoration: BoxDecoration(border: Border.all(color: MyColor.greyColor)),
                    child: Image.file(controller.newPickedImage!, height: Dimensions.space100, width: Dimensions.space100),
                  )
                : Container(),
            RoundedButton(
              verticalPadding: Dimensions.space8,
              press: () async {
                await controller.pickImage().then((_) {
                  controller.newPickedImage = controller.pickedImage;
                  controller.update();
                });
              },
              text: MyStrings.changeImage,
            ),
            const SizedBox(height: Dimensions.space10),
          controller.categoryList.isNotEmpty?  CustomDropDownTextField(
              labelText: MyStrings.category,
              selectedValue: controller.newCategory.isEmpty?null:controller.newCategory,
              onChanged: (newValue) {
                controller.newCategory = newValue!;
              },
              items: controller.categoryList.map((category) {
                return DropdownMenuItem<String>(
                  value: category.title,
                  child: Text(category.title!),
                );
              }).toList(),
            ):const SizedBox(),
           controller.uomList.isNotEmpty?  CustomDropDownTextField2(
              selectedValue: controller.uomController.text.isEmpty ? null : controller.uomController.text,
              onChanged: (newValue) {
                controller.newUom= newValue!;
              },
              items: controller.uomList.map((uom) {
                return DropdownMenuItem<String>(
                  value: uom.title,
                  child: Text(uom.title!),
                );
              }).toList(),
              labelText: MyStrings.uom.tr,
            ):const SizedBox(),
            const SizedBox(height: Dimensions.space10),
            Row(
              children: [
                Expanded(
                  child: RoundedButton(
                    verticalPadding: Dimensions.space10,
                    press: () async {
                      controller.editProduct(widget.id, controller.newNameController.text, controller.pickedImage);
                      Get.back();
                    },
                    text: MyStrings.edit,
                  ),
                ),
                const SizedBox(width: Dimensions.space10),
                Expanded(
                  child: RoundedButton(
                    verticalPadding: Dimensions.space10,
                    color: MyColor.colorRed,
                    press: () async {
                      await controller.deleteProduct(widget.id);
                      Get.back();
                    },
                    text: MyStrings.delete,
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}
