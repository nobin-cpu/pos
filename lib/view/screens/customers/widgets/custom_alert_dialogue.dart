import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/data/controller/customers/add_customers_controller.dart';
import 'package:flutter_prime/data/controller/uom/uom_controller.dart';
import 'package:flutter_prime/view/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:flutter_prime/view/components/buttons/rounded_button.dart';
import 'package:flutter_prime/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutter_prime/view/components/text-form-field/custom_text_field.dart';
import 'package:get/get.dart';

class CustomerDetails extends StatefulWidget {
  final String address;
  final String post;
  final String phone;
  const CustomerDetails({
    super.key, required this.address, required this.post, required this.phone,
  });

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddCustomersController>(
      builder: (controller) => Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
           
             Column(children: [
              Text("Address:${widget.address}",style: regularMediumLarge,),
              Text("P.O.#:${widget.post}",style: regularMediumLarge,),
              Text("Ph. No.:${widget.phone}",style: regularMediumLarge,),
                         ]), 
            const SizedBox(height: Dimensions.contentToButtonSpace),
            RoundedButton(
              press: () async {
                if (controller.nameController.text.isNotEmpty) {
                  controller.addCustomers();
                } else {
                  CustomSnackBar.error(errorList: ["add customer name"]);
                }
              },
              text: "Back",
            ),
          ],
        ),
      ),
    );
  }
}
