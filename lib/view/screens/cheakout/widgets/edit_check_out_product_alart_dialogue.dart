import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/data/controller/checkout/cheakout_controller.dart';
import 'package:flutter_prime/view/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:flutter_prime/view/components/buttons/rounded_button.dart';
import 'package:flutter_prime/view/components/text-form-field/custom_text_field.dart';
import 'package:get/get.dart';

class EditCheakoutProductAlartDialogue extends StatefulWidget {
  final int? id;
  const EditCheakoutProductAlartDialogue({super.key, this.id});

  @override
  State<EditCheakoutProductAlartDialogue> createState() => _EditCheakoutProductAlartDialogueState();
}

class _EditCheakoutProductAlartDialogueState extends State<EditCheakoutProductAlartDialogue> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheakoutController>(builder: (controller) {
      print('updated product price: ${controller.totalProductPrice}');

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
           
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.productName.toString(),
                  style: semiBoldMediumLarge,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${controller.price}/${controller.uom}",
                      style: regularDefault,
                    ),
                    Text("${MyStrings.preview} ${controller.totalProductPrice.toString()}", style: semiBoldDefault.copyWith(color: MyColor.colorRed)),
                  ],
                )
              ],
            ),

            const SizedBox(height: Dimensions.space10),
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          controller.increaseCartItem();
                          controller.updateTotalAmount();
                           controller.handleDiscountChange(controller.discountController.text);
                        },
                        child: Image.asset(
                          MyImages.increase,
                          height: Dimensions.space50,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.space30),
                        child: CustomTextField(
                          fillColor: MyColor.colorInputField,
                          onChanged: (value) {
                            double enteredQuantity = double.tryParse(value.toString()) ?? 0;
                            controller.quantity = enteredQuantity.toInt();
                            controller.updateTotalAmount();
                             controller.handleDiscountChange(controller.discountController.text);
                          },
                          controller: controller.productQuantityController,
                          disableBorder: true,
                          centerText: true,
                          textInputType: TextInputType.number,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (controller.quantity > 1) {
                            controller.decreaseCartItem();
                            controller.updateTotalAmount();
                             controller.handleDiscountChange(controller.discountController.text);
                          }
                        },
                        child: Image.asset(
                          MyImages.decrease,
                          height: Dimensions.space50,
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Text(
                    controller.uom ?? "",
                    style: regularExtraLarge.copyWith(color: MyColor.getGreyText()),
                  ),
                ),
                const SizedBox(
                  width: Dimensions.space10,
                )
              ],
            ),
            //fdfsfsdf
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.space20, vertical: Dimensions.space30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    MyStrings.discount,
                    style: semiBoldLarge,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space2, vertical: Dimensions.space10),
                      child: SizedBox(
                         height: MediaQuery.of(context).size.height*.055,
                        child: CustomTextField(
                          fillColor: MyColor.colorInputField,
                          onChanged: (value) {
                            controller.handleDiscountChange(
                              value,
                            );
                          },
                          controller: controller.discountController,
                          needOutlineBorder: false,
                          disableBorder: true,
                          centerText: true,
                          textInputType: TextInputType.number,
                        ),
                      ),
                    ),
                  ),
                  Checkbox(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.defaultRadius)),
                      activeColor: MyColor.primaryColor,
                      checkColor: MyColor.colorWhite,
                      value: controller.isDiscountInpercent,
                      side: MaterialStateBorderSide.resolveWith(
                        (states) => BorderSide(width: 1.0, color: controller.isDiscountInpercent ? MyColor.getTextFieldEnableBorder() : MyColor.getTextFieldDisableBorder()),
                      ),
                      onChanged: (value) {
                        controller.changeDiscountCheckBox();
                        controller.handleDiscountChange(controller.discountController.text);
                      }),
                  Image.asset(MyImages.percentImage, height: Dimensions.space10),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.space20),
            Row(
              children: [
                    Expanded(
                  child: RoundedButton(
                    verticalPadding: Dimensions.space10,
                    color: MyColor.colorRed,
                    press: () async {
                      controller.deleteCartItem(widget.id);
                      Get.back();
                    },
                    text: MyStrings.delete.tr,
                  ),
                ),
                const SizedBox(width: Dimensions.space10),
              
                Expanded(
                  child: RoundedButton(
                    verticalPadding: Dimensions.space10,
                    press: () async {
                      controller.editCartItem(widget.id);
                      Get.back();
                    },
                    text: MyStrings.update.tr,
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
