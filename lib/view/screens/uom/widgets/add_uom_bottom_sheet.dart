import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/controller/uom/uom_controller.dart';
import 'package:flutter_prime/view/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:flutter_prime/view/components/buttons/rounded_button.dart';
import 'package:flutter_prime/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutter_prime/view/components/text-form-field/custom_text_field.dart';
import 'package:get/get.dart';

class AddUomBottomSheet extends StatefulWidget {
  const AddUomBottomSheet({
    super.key,
  });

  @override
  State<AddUomBottomSheet> createState() => _AddUomBottomSheetState();
}

class _AddUomBottomSheetState extends State<AddUomBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UomController>(
      builder: (controller) => Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
      
          children: [
            const BottomSheetHeaderRow(header:  MyStrings.addAUnit,),
             
            const SizedBox(height: Dimensions.space10),
            CustomTextField(
              controller: controller.uomController,
              onChanged: () {},
              needOutlineBorder: true,
              animatedLabel: true,
              labelText: MyStrings.addAnUnitName,
            ),
           const SizedBox(height: Dimensions.contentToButtonSpace),
            RoundedButton(
              press: () async {
                if (controller.uomController.text.isNotEmpty) {
                  controller.saveUom();
                } else {
                  CustomSnackBar.error(errorList: [MyStrings.pleaseAddAnUnit.tr]);
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
