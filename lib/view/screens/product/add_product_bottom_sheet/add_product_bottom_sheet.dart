import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/data/controller/product/product_controller.dart';
import 'package:flutter_prime/view/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:flutter_prime/view/components/buttons/rounded_button.dart';
import 'package:flutter_prime/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutter_prime/view/components/text-form-field/custom_drop_down_button_with_text_field2.dart';
import 'package:flutter_prime/view/components/text-form-field/custom_text_field.dart';
import 'package:get/get.dart';

class AddProductBottomSheet extends StatefulWidget {
  const AddProductBottomSheet({super.key});

  @override
  State<AddProductBottomSheet> createState() => _AddProductBottomSheetState();
}

class _AddProductBottomSheetState extends State<AddProductBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      builder: (controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const BottomSheetHeaderRow(header: MyStrings.addProduct),
          Row(
            children: [
              const Text(
                MyStrings.productName,
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
            controller: controller.productNameController,
            onChanged: () {},
            needOutlineBorder: true,
            animatedLabel: true,
          ),
          const SizedBox(height: Dimensions.space10),
          Row(
            children: [
              const Text(
                MyStrings.onlyPrice,
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
            controller: controller.priceController,
            onChanged: () {},
            needOutlineBorder: true,
            animatedLabel: true,
            textInputType: TextInputType.number,
          ),
          const SizedBox(height: Dimensions.space10),
          Row(
            children: [
              Text(
                MyStrings.stocks.tr,
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
            controller: controller.stocksController,
            onChanged: () {},
            needOutlineBorder: true,
            animatedLabel: true,
            textInputType: TextInputType.number,
          ),
          const SizedBox(height: Dimensions.space10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      MyStrings.wholesalePrice,
                      style: mediumLarge,
                    ),
                    const SizedBox(height: Dimensions.space5),
                    CustomTextField(
                      controller: controller.wholesaleController,
                      onChanged: () {},
                      needOutlineBorder: true,
                      animatedLabel: true,
                      textInputType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Dimensions.space5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      MyStrings.purchasePrice,
                      style: mediumLarge,
                    ),
                    const SizedBox(height: Dimensions.space5),
                    CustomTextField(
                      controller: controller.purchasePriceController,
                      onChanged: () {},
                      needOutlineBorder: true,
                      animatedLabel: true,
                      textInputType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ],
          ),
        controller.categoryList.length > 1?  const SizedBox(height: Dimensions.space10) :const SizedBox(),
        controller.categoryList.length > 1?  Row(
            children: [
              const Text(
                MyStrings.category,
                style: mediumLarge,
              ),
              const SizedBox(width: Dimensions.space10),
              Text(
                MyStrings.required,
                style: mediumDefault.copyWith(color: MyColor.getGreyText()),
              ),
            ],
          ): const SizedBox(),
         controller.categoryList.length > 1?  const SizedBox(height: Dimensions.space5) :const SizedBox(),
          controller.categoryList.isNotEmpty && controller.categoryList.length > 1
              ? CustomDropDownTextField2(
                  labelText: MyStrings.category,
                  needLabel: false,
                  selectedValue: controller.categoryController.text.isEmpty ? null : controller.categoryController.text,
                  onChanged: (newValue) {
                    controller.categoryController.text = newValue!;
                  },
                  items: controller.categoryList.map((newValue) {
                    return DropdownMenuItem<String>(
                      value: newValue.title,
                      child: Text(newValue.title!),
                    );
                  }).toList())
              : const SizedBox(),
         controller.uomList.length > 1?  const SizedBox(height: Dimensions.space10) :const SizedBox(),
        controller.uomList.length > 1?  Row(
            children: [
              const Text(
                MyStrings.uom,
                style: mediumLarge,
              ),
              const SizedBox(width: Dimensions.space10),
              Text(
                MyStrings.required,
                style: mediumDefault.copyWith(color: MyColor.getGreyText()),
              ),
            ],
          ):const SizedBox(),
          const SizedBox(height: Dimensions.space5),
          controller.uomList.isNotEmpty && controller.uomList.length > 1
              ? CustomDropDownTextField2(
                  needLabel: false,
                  selectedValue: controller.uomController.text.isEmpty ? null : controller.uomController.text,
                  onChanged: (newValue) {
                    controller.uomController.text = newValue!;
                  },
                  items: controller.uomList.map((uom) {
                    return DropdownMenuItem<String>(
                      value: uom.title,
                      child: Text(uom.title!),
                    );
                  }).toList(),
                )
              : const SizedBox(),
          const SizedBox(height: Dimensions.space10),
          Row(
            children: [
              const Text(
                MyStrings.productsImage,
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
    if (controller.productNameController.text.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.enterProductName]);
    } else if (controller.priceController.text.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.enterPrice]);
    } else if (controller.stocksController.text.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.enterStocks]);
    } else if (controller.categoryController.text.isEmpty || controller.categoryController.text == "Select One") {
      CustomSnackBar.error(errorList: [MyStrings.selectACatagory]);
    } else if (controller.uomController.text.isEmpty || controller.uomController.text == "Select One") {
      CustomSnackBar.error(errorList: [MyStrings.selectAUnit]);
    }
    else if (controller.pickedImage ==null ) {
      CustomSnackBar.error(errorList: [MyStrings.pickAnImage]);
    }
     else {
      controller.addProducts();
    }
  },
  text: MyStrings.save,
),

        ],
      ),
    );
  }
}
