// import 'package:flutter/material.dart';
// import 'package:flutter_prime/core/utils/dimensions.dart';
// import 'package:flutter_prime/core/utils/my_color.dart';
// import 'package:flutter_prime/core/utils/my_strings.dart';
// import 'package:flutter_prime/data/controller/product/product_controller.dart';
// import 'package:flutter_prime/view/components/buttons/rounded_button.dart';
// import 'package:flutter_prime/view/components/text-form-field/custom_drop_down_text_field.dart';
// import 'package:flutter_prime/view/components/text-form-field/custom_text_field.dart';
// import 'package:get/get.dart';

// class EditProductDialogue extends StatefulWidget {
//   const EditProductDialogue({super.key});

//   @override
//   State<EditProductDialogue> createState() => _EditProductDialogueState();
// }

// class _EditProductDialogueState extends State<EditProductDialogue> {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<ProductController>(
//        builder: (controller) => Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           CustomTextField(
//             onChanged: () {},
//             controller:controller.newNameController,
//             needOutlineBorder: true,
//           ),
//           SizedBox(height: 10),
//           ElevatedButton(
//             onPressed: () async {
//               await controller.pickImage(); // Let the user pick a new image
//              controller.newPickedImage = controller.pickedImage;
//             },
//             child: Text('Change Image'),
//           ),
//           SizedBox(height: 10),
//           CustomDropDownTextField(
//             labelText: MyStrings.category,
//             selectedValue: newCategory,
//             onChanged: (newValue) {
//               newCategory = newValue!;
//             },
//             items: controller.categoryList.map((String category) {
//               return DropdownMenuItem<String>(
//                 value: category,
//                 child: Text(category),
//               );
//             }).toList(),
//           ),
//           SizedBox(height: 10),
//           CustomDropDownTextField(
//             labelText: MyStrings.uom,
//             selectedValue: newUom,
//             onChanged: (newValue) {
//               newUom = newValue!;
//             },
//             items: controller.uomList.map((String uom) {
//               return DropdownMenuItem<String>(
//                 value: uom,
//                 child: Text(uom),
//               );
//             }).toList(),
//           ),
//           SizedBox(height: 10),
//           Row(
//             children: [
//               Expanded(
//                 child: RoundedButton(
//                   verticalPadding: Dimensions.space10,
//                   press: () async {
//                     await controller.updateProduct(
//                       product['id'],
//                       newNameController.text.isNotEmpty ? newNameController.text : product['name'],
//                       newCategory,
//                       newUom,
//                       newPickedImage != null ? newPickedImage!.path : product['imagePath'],
//                     );
//                     Get.back();
//                   },
//                   text: 'Edit',
//                 ),
//               ),
//               const SizedBox(width: Dimensions.space10),
//               Expanded(
//                 child: RoundedButton(
//                   verticalPadding: Dimensions.space10,
//                   color: MyColor.colorRed,
//                   press: () async {
//                     await controller.deleteProduct(product['id']);
//                     Get.back();
//                   },
//                   text: 'Delete',
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
