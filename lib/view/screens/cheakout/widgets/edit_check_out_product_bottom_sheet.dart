import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/data/controller/cart/cart_screen_controller.dart';
import 'package:flutter_prime/data/controller/checkout/cheakout_controller.dart';
import 'package:flutter_prime/view/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:flutter_prime/view/components/buttons/rounded_button.dart';
import 'package:flutter_prime/view/components/text-form-field/custom_text_field.dart';
import 'package:get/get.dart';

class EditCheakoutProductBottomSheet extends StatefulWidget {
  final int? id;
  const EditCheakoutProductBottomSheet({super.key, this.id});

  @override
  State<EditCheakoutProductBottomSheet> createState() => _EditCheakoutProductBottomSheetState();
}

class _EditCheakoutProductBottomSheetState extends State<EditCheakoutProductBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheakoutController>(builder: (controller) {
    
      return Padding(
        padding: const EdgeInsets.all(Dimensions.space15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
           const BottomSheetHeaderRow(bottomSpace:5,header:MyStrings.editItem ),
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Text(controller.productName.toString(),style: semiBoldMediumLarge,),
             Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("${controller.price}/${controller.uom}",style: regularDefault,),
                  Text(MyStrings.preview+controller.totalPric.toString(),style: semiBoldDefault.copyWith(color: MyColor.colorRed)),
                ],
              )
           ],
         ),
           
             const SizedBox(height: Dimensions.space10),
             Padding(
               padding:const EdgeInsets.symmetric(horizontal: Dimensions.space10),
               child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {
                       controller.increaseCartItem();
                       controller.updateTotalAmount(widget.id!, controller.quantity);
                      },
                      child: Image.asset(
                        MyImages.increase,
                        height: Dimensions.space50,
                      )),
                   CustomTextField(
                    fillColor: MyColor.colorInputField,
                    onChanged: (value) {
                  int enteredQuantity = int.tryParse(value) ?? 0;
                  controller.quantity = enteredQuantity;
                  controller.updateTotalAmount(
                      widget.id!, enteredQuantity);
                },
                    controller: controller.productQuantityController,
                    needOutlineBorder: false,
                    disableBorder: true,
                    centerText: true),
                   const SizedBox(height:Dimensions.space15,),
                  InkWell(
                      onTap: () {
                         if (controller.quantity > 1) {
                          controller.decreaseCartItem(); 
                      controller.updateTotalAmount(widget.id!, controller.quantity);
                        }
                      },
                      child: Image.asset(
                        MyImages.decrease,
                        height: Dimensions.space50,
                      )),
                ],
                          ),
             ),
           

            const SizedBox(height: Dimensions.space10),
            Row(
              children: [
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
                const SizedBox(width: Dimensions.space10),
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
              ],
            )
          ],
        ),
      );
    });
  }
}
