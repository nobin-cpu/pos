import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/controller/customers/add_customers_controller.dart';
import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';
import 'package:flutter_prime/view/components/card/custom_card.dart';
import 'package:get/get.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  @override
  void initState() {
    super.initState();
    final controller = Get.put(AddCustomersController());
    controller.fetchCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddCustomersController>(
        builder: (controller) => Scaffold(
              appBar: CustomAppBar(
                title: MyStrings.customers,
                isActionImage: true,
                isShowActionBtn: true,
                actionIcon: MyImages.add,
                actionPress: () {
                  //  controller.showAddUomBottomSheet(context);
                },
                action: [
                  InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * .1),
                    ),
                    onTap: () {
                      controller.showAddCustomersBottomSheet(context);
                    },
                    hoverColor: Colors.transparent,
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.space10),
                        color: MyColor.transparentColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(Dimensions.space17),
                        child: Image.asset(
                          MyImages.add,
                          height: Dimensions.space15,
                          color: MyColor.colorWhite,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              body: GetBuilder<AddCustomersController>(
                builder: (controller) {
                  return ListView.builder(
                    itemCount: controller.customers.length,
                    itemBuilder: (context, index) {
                      final customer = controller.customers[index];
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: CustomCard(
                          isPress: true,
                          onPressed: () {
                            controller.showAddCustomersDetailsAlertDialogue(context, customer.address.toString(),customer.post,customer.phNo);
                          },
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(customer.name),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ));
  }
}
