import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/data/controller/settings/settings_controller.dart';
import 'package:flutter_prime/view/components/buttons/rounded_button.dart';
import 'package:flutter_prime/view/components/text-form-field/custom_text_field.dart';
import 'package:get/get.dart';

class VatCustomizeAlartDialogue extends StatelessWidget {
  const VatCustomizeAlartDialogue({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (controller) {
      return Container(
        padding: const EdgeInsets.all(Dimensions.space10),
        decoration: const BoxDecoration(color: MyColor.colorWhite),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CustomDropDownTextField2(
            //       labelText: MyStrings.vat,
            //       needLabel: false,
            //       selectedValue: con.vatController.text.isEmpty ? null : con.vatController.text,
            //       onChanged: (newValue) {
            //         con.vatController.text = newValue!;
            //       },
            //       items: con.categoryList.map((newValue) {
            //         return DropdownMenuItem<String>(
            //           value: newValue.title,
            //           child: Text(newValue.title!),
            //         );
            //       }).toList())
            const Text(MyStrings.enterVat, style: semiBoldLarge),
            const SizedBox(height: Dimensions.space10),
            CustomTextField(
              controller: controller.vatController,
              onChanged: () {},
              needOutlineBorder: true,
              animatedLabel: true,
              textInputType: TextInputType.number,
            ),
            const SizedBox(height: Dimensions.space10),
            Row(
              children: [
                const Expanded(child: Text(MyStrings.enterVatMsg, style: regularDefault)),
                Checkbox(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.defaultRadius)),
                    activeColor: MyColor.primaryColor,
                    checkColor: MyColor.colorWhite,
                    value: controller.percentDiscount,
                    side: MaterialStateBorderSide.resolveWith(
                      (states) => BorderSide(width: 1.0, color: controller.percentDiscount ? MyColor.getTextFieldEnableBorder() : MyColor.getTextFieldDisableBorder()),
                    ),
                    onChanged: (value) {
                      controller.changediscountCheckBox();
                    }),
              ],
            ),
            const SizedBox(height: Dimensions.space15),
            Row(
              children: [
                Expanded(
                    child: RoundedButton(
                        text: MyStrings.cancel,
                        press: () {
                          Get.back();
                        },
                        color: MyColor.colorRed,
                        verticalPadding: Dimensions.space10)),
                const SizedBox(width: Dimensions.space10),
                Expanded(
                    child: RoundedButton(
                        text: MyStrings.save,
                        press: () {
                          controller.saveVatDataToSharedPreference();
                         // controller.getVatActivationValue();
                          Get.back();
                        },
                        verticalPadding: Dimensions.space10)),
              ],
            )
          ],
        ),
      );
    });
  }
}
