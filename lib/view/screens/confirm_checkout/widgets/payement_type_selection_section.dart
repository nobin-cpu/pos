import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/core/utils/util.dart';
import 'package:flutter_prime/data/controller/confirm_cheakout/confirm_checkout_controller.dart';
import 'package:flutter_prime/view/components/card/custom_card.dart';
import 'package:flutter_prime/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:get/get.dart';

class PaymentTypeSelectionSection extends StatefulWidget {
  const PaymentTypeSelectionSection({super.key});

  @override
  State<PaymentTypeSelectionSection> createState() => _PaymentTypeSelectionSectionState();
}

class _PaymentTypeSelectionSectionState extends State<PaymentTypeSelectionSection> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConfirmCheakoutController>(
     builder: (controller)=> Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.space15),
        child: CustomCard(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.space10),
                  child: Container(
                    decoration: BoxDecoration(boxShadow: MyUtils.getCardShadow()),
                    child: CustomCard(
                      radius: Dimensions.space5,
                      isPress: true,
                      onPressed: () {
                        if (controller.selectedCustomer != null) {
                          controller.paidOnline = true;
                          controller.paidinCash = false;
                          controller.update();
                        } else {
                          CustomSnackBar.error(errorList: [MyStrings.selectACustomer]);
                        }
                      },
                      width: double.infinity,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: Dimensions.space10,
                              child: Radio(
                                value: true,
                                groupValue: controller.paidOnline,
                                onChanged: (bool? value) {
                                  controller.changeonlinePaid();
                                  controller.paidinCash = false;
                                  controller.update();
                                },
                              ),
                            ),
                            const Text(
                              MyStrings.paidOnline,
                              style: regularMediumLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Dimensions.space10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.space10),
                  child: Container(
                    decoration: BoxDecoration(boxShadow: MyUtils.getCardShadow()),
                    child: CustomCard(
                      radius: Dimensions.space5,
                      isPress: true,
                      onPressed: () {
                        if (controller.selectedCustomer != null) {
                          controller.paidinCash = true;
                          controller.paidOnline = false;
                          controller.update();
                        } else {
                          CustomSnackBar.error(errorList: [MyStrings.selectACustomer]);
                        }
                      },
                      width: double.infinity,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Row(
                          children: [
                            SizedBox(
                              height: Dimensions.space10,
                              child: Radio(
                                value: true,
                                groupValue: controller.paidinCash,
                                onChanged: (bool? value) {
                                  controller.changeCashPaid();
      
                                  controller.update();
                                },
                              ),
                            ),
                            const Text(
                              MyStrings.paidByCash,
                              style: regularMediumLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
