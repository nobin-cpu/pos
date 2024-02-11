import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/data/controller/add_shop_details/add_shop_details_controller.dart';
import 'package:flutter_prime/view/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:flutter_prime/view/components/buttons/rounded_button.dart';
import 'package:flutter_prime/view/components/text-form-field/custom_text_field.dart';
import 'package:get/get.dart';

class ShopDetailsAddBottomSheet extends StatelessWidget {
  const ShopDetailsAddBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddShopDetailsController>(builder: (controller) {
      return Container(
        padding: const EdgeInsets.all(Dimensions.space10),
        decoration: const BoxDecoration(color: MyColor.colorWhite),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BottomSheetHeaderRow(
              header: MyStrings.addshopdetails,
            ),
            const Text(MyStrings.shopName, style: semiBoldLarge),
            const SizedBox(height: Dimensions.space10),
            CustomTextField(
              controller: controller.shopNameController,
              onChanged: () {},
              needOutlineBorder: true,
              animatedLabel: true,
              textInputType: TextInputType.number,
            ),
            const SizedBox(height: Dimensions.space5),
            const Text(MyStrings.shopAddress, style: semiBoldLarge),
            const SizedBox(height: Dimensions.space10),
            CustomTextField(
              controller: controller.shopAddressController,
              onChanged: () {},
              needOutlineBorder: true,
              animatedLabel: true,
              textInputType: TextInputType.number,
            ),
            const SizedBox(height: Dimensions.space5),
            const Text(MyStrings.phoneNo, style: semiBoldLarge),
            const SizedBox(height: Dimensions.space10),
            CustomTextField(
              controller: controller.phNoController,
              onChanged: () {},
              needOutlineBorder: true,
              animatedLabel: true,
              textInputType: TextInputType.number,
            ),
            const SizedBox(height: Dimensions.space10),
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
                          controller.saveshopDataToSharedPreference();
                          Get.back();
                          controller.getShopDetailsData();
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
