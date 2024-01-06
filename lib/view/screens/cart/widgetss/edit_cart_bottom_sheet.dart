import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/data/controller/cart/cart_screen_controller.dart';
import 'package:flutter_prime/data/controller/product/product_controller.dart';
import 'package:flutter_prime/view/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:flutter_prime/view/components/buttons/rounded_button.dart';
import 'package:flutter_prime/view/components/text-form-field/custom_drop_down_button_with_text_field2.dart';
import 'package:flutter_prime/view/components/text-form-field/custom_drop_down_text_field.dart';
import 'package:flutter_prime/view/components/text-form-field/custom_text_field.dart';
import 'package:get/get.dart';

class EditCartBottomSheet extends StatefulWidget {
  final int? id;
  const EditCartBottomSheet({super.key, this.id});

  @override
  State<EditCartBottomSheet> createState() => _EditCartBottomSheetState();
}

class _EditCartBottomSheetState extends State<EditCartBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartScreenController>(builder: (controller) {
    
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
            // CustomTextField(
            //   onChanged: () {},
            //   controller: controller.newNameController,
            //   needOutlineBorder: true,
            // ),
             const SizedBox(height: Dimensions.space10),
             Padding(
               padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*.36),
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
            // const Text(MyStrings.productImage,style: semiBoldDefault,),
            //  const SizedBox(height: Dimensions.space10),
            // controller.newPickedImage != null
            //     ? Container(
            //         width: double.infinity,
            //         decoration: BoxDecoration(border: Border.all(color: MyColor.greyColor)),
            //         child: Image.file(controller.newPickedImage!, height: Dimensions.space100, width: Dimensions.space100),
            //       )
            //     : Container(),
            //      const SizedBox(height: Dimensions.space10),
            // RoundedButton(
            //   verticalPadding: Dimensions.space8,
            //   press: () async {
            //     await controller.pickImage().then((_) {
            //       controller.newPickedImage = controller.pickedImage;
            //       controller.update();
            //     });
            //   },
            //   text: MyStrings.changeImage,
            // ),
            // const SizedBox(height: Dimensions.space10),
            // CustomDropDownTextField(
            //   labelText: MyStrings.category,
            //   selectedValue: controller.newCategory,
            //   onChanged: (newValue) {
            //     controller.newCategory = newValue!;
            //   },
            //   items: controller.categoryList.map((category) {
            //     return DropdownMenuItem<String>(
            //       value: category.title,
            //       child: Text(category.title!),
            //     );
            //   }).toList(),
            // ),
          
            // CustomDropDownTextField2(
            //   selectedValue: controller.uomController.text.isEmpty ? null : controller.uomController.text,
            //   onChanged: (newValue) {
            //     controller.uomController.text = newValue!;
            //   },
            //   items: controller.uomList.map((uom) {
            //     return DropdownMenuItem<String>(
            //       value: uom.title,
            //       child: Text(uom.title!),
            //     );
            //   }).toList(),
            //   labelText: MyStrings.uom.tr,
            // ),

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
                    text: MyStrings.edit.tr,
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
