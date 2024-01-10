import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/core/utils/util.dart';
import 'package:flutter_prime/data/controller/category_product_list_model/category_product_list_controller.dart';
import 'package:flutter_prime/view/components/buttons/rounded_button.dart';
import 'package:flutter_prime/view/components/text-form-field/custom_text_field.dart';
import 'package:get/get.dart';

class AddToCartAlertDialogue extends StatelessWidget {
  final int index;
  const AddToCartAlertDialogue({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryProductListController>(builder: (con) {
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
                      // ClipRRect(
                      //   borderRadius: BorderRadius.circular(Dimensions.space3),
                      //   child: Image.file(
                      //     File(con.productList[index].imagePath ?? ""),
                      //     height: Dimensions.space50,
                      //     width: Dimensions.space50,
                      //     fit: BoxFit.cover,
                      //   ),
                      // ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.space15,
                            ),
                            child: Text(
                              con.productList[index].name.toString(),
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
                        Text("${con.productList[index].price}${MyUtils.getCurrency()}/${con.productList[index].uom ?? ""}"),
                        const SizedBox(height:Dimensions.space10),
                        Text(
                          "${MyStrings.amt} ${con.totalAmount.toString()}${MyUtils.getCurrency()}",
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
                          con.increaseInputFieldProductQuantity();
                          con.updateTotalAmount(index, con.quantity);
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
                            con.quantity = enteredQuantity.toInt();
                            con.updateTotalAmount(index, enteredQuantity);
                          },
                          controller: con.productQuantityController,
                          disableBorder: true,
                          centerText: true,
                          textInputType: TextInputType.number,
                          
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (con.quantity > 1) {
                            con.decreaseInputFieldProductQuantity();
                            con.updateTotalAmount(index, con.quantity);
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
                    con.productList[index].uom ?? "",
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
                  const Text(MyStrings.discount,style: semiBoldLarge,),
                  Expanded(
                 
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space2,vertical: Dimensions.space10),
                      child: CustomTextField(
                           
                          fillColor: MyColor.colorInputField,
                          onChanged: (value) {
                            con.handleDiscountChange(value, index);
                          },
                          controller: con.discountController,
                          needOutlineBorder: false,
                          disableBorder: true,
                          centerText: true,
                          textInputType: TextInputType.number,
                          ),
                    ),
                  ),
                  Checkbox(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.defaultRadius)),
                      activeColor: MyColor.primaryColor,
                      checkColor: MyColor.colorWhite,
                      value: con.isDiscountInpercent,
                      side: MaterialStateBorderSide.resolveWith(
                        (states) => BorderSide(width: 1.0, color: con.isDiscountInpercent ? MyColor.getTextFieldEnableBorder() : MyColor.getTextFieldDisableBorder()),
                      ),
                      onChanged: (value) {
                        con.changediscountCheckBox();
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
                        con.addToCart(con.productList[index], con.quantity);
                        print("from screen" + con.productList[index].uom.toString());
                        con.loadCartData();
                        Get.back();
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
