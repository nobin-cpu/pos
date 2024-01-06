import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/data/controller/uom/uom_controller.dart';
import 'package:flutter_prime/data/model/uom/uom_model.dart';
import 'package:flutter_prime/view/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:flutter_prime/view/components/buttons/rounded_button.dart';
import 'package:flutter_prime/view/components/text-form-field/custom_text_field.dart';
import 'package:get/get.dart';

class EditUomBottomSheet extends StatefulWidget {
  final int? id;
  const EditUomBottomSheet({
    Key? key,
    this.id,
  }) : super(key: key);

  @override
  State<EditUomBottomSheet> createState() => _EditUomBottomSheetState();
}

class _EditUomBottomSheetState extends State<EditUomBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UomController>(
      builder: (controller) => Padding(
        padding: const EdgeInsets.only(top: 0,right: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             const BottomSheetHeaderRow(header: MyStrings.editUom),
            CustomTextField(
              controller: controller.editController,
              onChanged: (value) {
                value = controller.editController.text;
               
              },
              labelText: "",
              animatedLabel: false,
              needOutlineBorder: true,
            ),
          const SizedBox(height: Dimensions.contentToButtonSpace),
            RoundedButton(
                text: MyStrings.edit,
                press: () {
                  controller.editUomData(widget.id!);
                })
          ],
        ),
      ),
    );
  }
}
