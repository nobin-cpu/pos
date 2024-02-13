import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/data/controller/confirm_cheakout/confirm_checkout_controller.dart';
import 'package:flutter_prime/data/model/customers/customer_model.dart';
import 'package:flutter_prime/view/components/card/custom_card.dart';
import 'package:get/get.dart';

class AddCustomerSection extends StatefulWidget {
  const AddCustomerSection({super.key});

  @override
  State<AddCustomerSection> createState() => _AddCustomerSectionState();
}

class _AddCustomerSectionState extends State<AddCustomerSection> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConfirmCheakoutController>(
      builder: (controller) => CustomCard(
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
                child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(Dimensions.space5),
                    ),
                    child: DropdownButtonFormField<CustomerModel>(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: MyStrings.selectACustomer,
                      ),
                      value: controller.selectedCustomer,
                      onChanged: (CustomerModel? value) {
                        controller.selectedCustomer = value;
                        controller.customerid = value!.id;
                      },
                      items: controller.customerList.map((CustomerModel customer) {
                        return DropdownMenuItem<CustomerModel>(
                            value: customer,
                            child: Row(
                              children: [
                                Text(customer.name),
                                const SizedBox(
                                  width: Dimensions.space5,
                                ),
                                Text("(${customer.address})", style: regularDefault)
                              ],
                            ));
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(width: Dimensions.space15),
                InkWell(
                    onTap: () {
                      controller.showAddCustomersBottomSheet(context);
                    },
                    child: Image.asset(
                      MyImages.add,
                      height: Dimensions.space15,
                    ))
              ],
            )),
            const SizedBox(width: Dimensions.space10),
          ],
        ),
      ),
    );
  }
}
