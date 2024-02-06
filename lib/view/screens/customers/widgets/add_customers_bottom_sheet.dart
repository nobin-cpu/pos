import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/data/controller/customers/add_customers_controller.dart';
import 'package:flutter_prime/data/controller/uom/uom_controller.dart';
import 'package:flutter_prime/view/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:flutter_prime/view/components/buttons/rounded_button.dart';
import 'package:flutter_prime/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutter_prime/view/components/text-form-field/custom_text_field.dart';
import 'package:get/get.dart';

class AddCustomersBottomSheet extends StatefulWidget {
  const AddCustomersBottomSheet({
    super.key,
  });

  @override
  State<AddCustomersBottomSheet> createState() => _AddCustomersBottomSheetState();
}

class _AddCustomersBottomSheetState extends State<AddCustomersBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddCustomersController>(
      builder: (controller) => Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const BottomSheetHeaderRow(
              header: MyStrings.addAUnit,
            ),
            const Text("Customer Name", style: semiBoldLarge),
            const SizedBox(height: Dimensions.space10),
            CustomTextField(
              controller: controller.nameController,
              onChanged: () {},
              needOutlineBorder: true,
              animatedLabel: true,
              textInputType: TextInputType.emailAddress,
            ),
            const SizedBox(height: Dimensions.space5),
            const Text("Address", style: semiBoldLarge),
            const SizedBox(height: Dimensions.space10),
            CustomTextField(
              controller: controller.addressController,
              onChanged: () {},
              needOutlineBorder: true,
              animatedLabel: true,
              labelText: "ex:Sector 12,Uttara,Dhaka",
              
              textInputType: TextInputType.emailAddress,
            ),
            const SizedBox(height: Dimensions.space5),
            const Text("Ph no.", style: semiBoldLarge),
            const SizedBox(height: Dimensions.space10),
            CustomTextField(
              controller: controller.phController,
              onChanged: () {},
              needOutlineBorder: true,
              animatedLabel: true,
              
              textInputType: TextInputType.phone,
            ),
            const SizedBox(height: Dimensions.space5),
            const Text("P.O.#", style: semiBoldLarge),
            const SizedBox(height: Dimensions.space10),
            CustomTextField(
              controller: controller.poController,
              onChanged: () {},
              needOutlineBorder: true,
              animatedLabel: true,
              
              textInputType: TextInputType.phone,
            ),
            const SizedBox(height: Dimensions.contentToButtonSpace),
            RoundedButton(
              press: () async {
                if (controller.nameController.text.isNotEmpty) {
                  controller.addCustomers();
                } else {
                  CustomSnackBar.error(errorList: ["add customer name"]);
                }
              },
              text: MyStrings.save,
            ),
          ],
        ),
      ),
    );
  }
}
