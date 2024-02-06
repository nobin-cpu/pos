import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/core/utils/util.dart';
import 'package:flutter_prime/data/controller/category_product_list_controller/category_product_list_controller.dart';
import 'package:flutter_prime/view/components/buttons/rounded_button.dart';
import 'package:flutter_prime/view/components/text-form-field/custom_text_field.dart';
import 'package:get/get.dart';

class AddToCartAlertDialogue extends StatelessWidget {
  final int index;
  const AddToCartAlertDialogue({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryProductListController>(builder: (controller) {
      return Container(
        decoration: const BoxDecoration(color: MyColor.colorWhite),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.space15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                   
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.space15,
                            ),
                            child: Text(
                              controller.productList[index].name.toString(),
                              style: semiBoldLarge,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("${controller.productList[index].price}${MyUtils.getCurrency()}/${controller.productList[index].uom ?? ""}"),
                        const SizedBox(height: Dimensions.space10),
                        Text(
                          "${MyStrings.amt} ${controller.totalAmount.toString()}${MyUtils.getCurrency()}",
                          style: semiBoldLarge.copyWith(color: MyColor.colorRed),
                        )
                      ],
                    ),
                  )
                ],
              ),
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
                          controller.increaseInputFieldProductQuantity();
                          controller.updateTotalAmount(index, controller.quantity);
                          controller.handleDiscountChange(controller.discountController.text, index);
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
                            controller.updateTotalAmount(index, enteredQuantity);
                            controller.handleDiscountChange(controller.discountController.text, index);
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
                            controller.decreaseInputFieldProductQuantity();
                            controller.updateTotalAmount(index, controller.quantity);
                            controller.handleDiscountChange(controller.discountController.text, index);
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
                    controller.productList[index].uom ?? "",
                    style: regularExtraLarge.copyWith(color: MyColor.getGreyText()),
                  ),
                ),
                const SizedBox(
                  width: Dimensions.space10,
                )
              ],
            ),
            const SizedBox(height: Dimensions.space10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.space20, vertical: Dimensions.space30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    MyStrings.discount,
                    style: semiBoldLarge,
                  ),
                  const SizedBox(width:Dimensions.space15),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space2, vertical: Dimensions.space10),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * .055,
                        child: CustomTextField(
                          fillColor: MyColor.colorInputField,
                          onChanged: (value) {
                            controller.handleDiscountChange(value, index);
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
                        controller.changediscountCheckBox();
                        controller.handleDiscountChange(controller.discountController.text, index);
                      }),
                  Image.asset(MyImages.percentImage, height: Dimensions.space10),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.space30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10),
                  child: RoundedButton(
                      horizontalPadding: Dimensions.space10,
                      verticalPadding: Dimensions.space10,
                      color: MyColor.redCancelTextColor,
                      text: MyStrings.cancel,
                      press: () {
                        Get.back();
                      }),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10),
                  child: RoundedButton(
                      horizontalPadding: Dimensions.space10,
                      verticalPadding: Dimensions.space10,
                      color: MyColor.primaryColor,
                      text: MyStrings.addTOCart,
                      press: () {
                        controller.addToCart(controller.productList[index], controller.quantity);
                        controller.loadCartData();
                        Get.back();

                       
                        controller.loadCartData();
                      }),
                )),
              ],
            )
          ],
        ),
      );
    });
  }
}
