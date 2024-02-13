import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/data/controller/product/product_controller.dart';
import 'package:flutter_prime/view/components/text-form-field/custom_text_field.dart';
import 'package:get/get.dart';

class AddProductsDetailsFields extends StatefulWidget {
  const AddProductsDetailsFields({super.key});

  @override
  State<AddProductsDetailsFields> createState() => _AddProductsDetailsFieldsState();
}

class _AddProductsDetailsFieldsState extends State<AddProductsDetailsFields> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      builder: (controller) => Column(
        children: [
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
        ],
      ),
    );
  }
}
