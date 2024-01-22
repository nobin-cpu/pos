// import 'package:flutter/material.dart';
// import 'package:flutter_prime/core/utils/dimensions.dart';
// import 'package:flutter_prime/core/utils/my_strings.dart';
// import 'package:flutter_prime/data/controller/checkout/cheakout_controller.dart';
// import 'package:flutter_prime/view/components/buttons/rounded_button.dart';
// import 'package:get/get.dart';

// class ConfirmCheckoutPopUp extends StatefulWidget {
//   const ConfirmCheckoutPopUp({super.key});

//   @override
//   State<ConfirmCheckoutPopUp> createState() => _ConfirmCheckoutPopUpState();
// }

// class _ConfirmCheckoutPopUpState extends State<ConfirmCheckoutPopUp> {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<CheakoutController>(
//        builder: (controller) => Padding(
//          padding: const EdgeInsets.all(Dimensions.space30),
//          child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const SizedBox(height:Dimensions.space10),
//             RoundedButton(
//               press: () async {
//                controller.completeCheckout(MyStrings.paidOnline);
               
//               },
//               text: MyStrings.paidOnline,
//             ),
//             const SizedBox(height:Dimensions.space10),
//              RoundedButton(
//               press: () async {
//                controller.completeCheckout(MyStrings.paidByCash);
//               },
//               text: MyStrings.paidByCash,
//             ),
//             ],
//             ),
//        )
        
//     );
//   }
// }
