import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/data/controller/confirm_cheakout/confirm_checkout_controller.dart';
import 'package:flutter_prime/view/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:flutter_prime/view/components/buttons/rounded_button.dart';
import 'package:flutter_prime/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:get/get.dart';

import 'add_customer_details_field_section.dart';

class AddCustomersBottomSheetSection extends StatefulWidget {
  const AddCustomersBottomSheetSection({
    super.key,
  });

  @override
  State<AddCustomersBottomSheetSection> createState() => _AddCustomersBottomSheetSectionState();
}

class _AddCustomersBottomSheetSectionState extends State<AddCustomersBottomSheetSection> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConfirmCheakoutController>(
      builder: (controller) => Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const BottomSheetHeaderRow(
              header: MyStrings.addCustomer,
            ),
            const Text(MyStrings.customerName, style: semiBoldLarge),
            const AddCustomerDetailsFieldSection(),
            const SizedBox(height: Dimensions.contentToButtonSpace),
            RoundedButton(
              press: () async {
                if (controller.nameController.text.isNotEmpty) {
                  controller.addCustomers();
                } else {
                  CustomSnackBar.error(errorList: [MyStrings.addCustomer]);
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
