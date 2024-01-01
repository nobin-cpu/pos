import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
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
            CustomTextField(
              controller: controller.editController,
              onChanged: (value) {
                value = controller.editController.text;
                
              },
              labelText: "",
              animatedLabel: false,
              needOutlineBorder: true,
            ),
            const SizedBox(height: Dimensions.space10),
            RoundedButton(text: MyStrings.done, press: (){
               controller.editCategoryData(widget.id!);
            }),
            
          ],
        ),
      ),
    );
  }
}
