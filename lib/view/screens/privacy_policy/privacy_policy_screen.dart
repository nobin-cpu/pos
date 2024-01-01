// import 'package:flutter/material.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:get/get.dart';
// import 'package:flutter_prime/core/utils/dimensions.dart';
// import 'package:flutter_prime/core/utils/my_color.dart';
// import 'package:flutter_prime/core/utils/my_strings.dart';
// import 'package:flutter_prime/core/utils/style.dart';
// import 'package:flutter_prime/data/controller/privacy/privacy_controller.dart';
// import 'package:flutter_prime/data/repo/privacy_repo/privacy_repo.dart';
// import 'package:flutter_prime/data/services/api_service.dart';
// import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';
// import 'package:flutter_prime/view/components/buttons/category_button.dart';
// import 'package:flutter_prime/view/components/custom_loader/custom_loader.dart';

// class PrivacyPolicyScreen extends StatefulWidget {

//   const PrivacyPolicyScreen({Key? key}) : super(key: key);

//   @override
//   State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
// }

// class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {

//   @override
//   void initState() {
//     Get.put(ApiClient(sharedPreferences: Get.find()));
//     Get.put(PrivacyRepo(apiClient: Get.find()));
//     final controller = Get.put(PrivacyController(repo: Get.find()));

//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       controller.loadData();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: MyColor.colorWhite,
//       appBar: const CustomAppBar(
//         title: MyStrings.privacyPolicy,
//         bgColor: MyColor.primaryColor,
//         isShowActionBtn: false,
//       ),
//       body: GetBuilder<PrivacyController>(
//         builder: (controller) => SizedBox(
//           width: MediaQuery.of(context).size.width,
//           child: controller.isLoading ? const CustomLoader() : Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: Dimensions.space10, top: Dimensions.space15),
//                 child: SizedBox(
//                   height: 30,
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: List.generate(
//                         controller.list.length, (index) => Row(
//                           children: [
//                             CategoryButton(
//                               color: controller.selectedIndex == index ? MyColor.primaryColor : MyColor.secondaryColor,
//                               horizontalPadding: 8,
//                               verticalPadding: 7,
//                               textColor: controller.selectedIndex == index?MyColor.colorWhite:MyColor.colorBlack,
//                               text: controller.list[index].dataValues?.title ?? '',
//                               press: () {
//                                 controller.changeIndex(index);
//                               }
//                             ),
//                             const SizedBox(width: Dimensions.space10)
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: Dimensions.space15),
//               Expanded(
//                 child:  Center(
//                   child: SingleChildScrollView(
//                     child: Container(
//                       padding: const EdgeInsets.all(20),
//                       width: double.infinity,
//                       color: Colors.transparent,
//                       child: HtmlWidget(
//                         controller.selectedHtml,
//                         textStyle: regularDefault.copyWith(color: Colors.black),
//                         onLoadingBuilder: (context, element, loadingProgress) => const Center(
//                           child: CustomLoader()
//                     )
//                   )
//                 )
//               ),
//              )
//             )
//           ],
//         ),
//       ),
//      )
//     );
//   }
// }
