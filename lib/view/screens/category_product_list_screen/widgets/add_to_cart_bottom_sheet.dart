

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

class AddToCartBottomSheet extends StatelessWidget {
  final int index;
  const AddToCartBottomSheet({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryProductListController>(builder: (con) {
      return Column(
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
                      Text(
                        "${MyStrings.amt} ${con.totalAmount.toString()}${MyUtils.getCurrency()}",
                        style: regularDefault.copyWith(color: MyColor.colorRed),
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
                           con.increaseCartItem();
                          con.updateTotalAmount(con.productList[index], con.quantity);
                          },
                          child: Image.asset(
                            MyImages.increase,
                            height: Dimensions.space50,
                          )),
                       CustomTextField(
                        onChanged: (value) {
                      int enteredQuantity = int.tryParse(value) ?? 0;
                      con.quantity = enteredQuantity;
                      con.updateTotalAmount(
                          con.productList[index], enteredQuantity);
                    },
                        controller: con.productQuantityController,
                        needOutlineBorder: false,
                        disableBorder: true,
                        centerText: true),
                       const SizedBox(height:Dimensions.space15,),
                      InkWell(
                          onTap: () {
                             if (con.quantity > 1) {
                            con.decreaseCartItem();
                            con.updateTotalAmount(con.productList[index], con.quantity);
                          }
                          },
                          child: Image.asset(
                            MyImages.decrease,
                            height: Dimensions.space50,
                          )),
                    ],
                              ),
              ),
              Padding(
                padding: const EdgeInsets.only(right:Dimensions.space20),
                child: Text(con.productList[index].uom ?? "",style: regularExtraLarge.copyWith(color: MyColor.getGreyText()),),
              )
            ],
          ),
          const SizedBox(height:Dimensions.space20),
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
                      con.loadCartData();
                      Get.back();
                    }),
              )),
              
            ],
          )
        ],
      );
    });
  }
}
