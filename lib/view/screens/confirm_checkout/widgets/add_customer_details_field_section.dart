import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/data/controller/confirm_cheakout/confirm_checkout_controller.dart';
import 'package:flutter_prime/view/components/text-form-field/custom_text_field.dart';
import 'package:get/get.dart';

class AddCustomerDetailsFieldSection extends StatefulWidget {
  const AddCustomerDetailsFieldSection({super.key});

  @override
  State<AddCustomerDetailsFieldSection> createState() => _AddCustomerDetailsFieldSectionState();
}

class _AddCustomerDetailsFieldSectionState extends State<AddCustomerDetailsFieldSection> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConfirmCheakoutController>(
      builder: (controller) => Column(
        children: [
          const SizedBox(height: Dimensions.space10),
          CustomTextField(
            controller: controller.nameController,
            onChanged: () {},
            needOutlineBorder: true,
            animatedLabel: true,
          ),
          const SizedBox(height: Dimensions.space5),
          const Text(MyStrings.address, style: semiBoldLarge),
          const SizedBox(height: Dimensions.space10),
          CustomTextField(
            controller: controller.addressController,
            onChanged: () {},
            needOutlineBorder: true,
            animatedLabel: true,
            labelText: MyStrings.addressExample,
          ),
          const SizedBox(height: Dimensions.space5),
          const Text(MyStrings.phone, style: semiBoldLarge),
          const SizedBox(height: Dimensions.space10),
          CustomTextField(
            controller: controller.phController,
            onChanged: () {},
            needOutlineBorder: true,
            animatedLabel: true,
            textInputType: TextInputType.number,
          ),
          const SizedBox(height: Dimensions.space5),
          const Text(MyStrings.po, style: semiBoldLarge),
          const SizedBox(height: Dimensions.space10),
          CustomTextField(
            controller: controller.poController,
            onChanged: () {},
            needOutlineBorder: true,
            animatedLabel: true,
          ),
        ],
      ),
    );
  }
}
