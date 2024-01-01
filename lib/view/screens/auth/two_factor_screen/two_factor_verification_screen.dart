// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:flutter_prime/core/route/route.dart';
// import 'package:flutter_prime/core/utils/dimensions.dart';
// import 'package:flutter_prime/core/utils/my_color.dart';
// import 'package:flutter_prime/core/utils/my_images.dart';
// import 'package:flutter_prime/core/utils/my_strings.dart';
// import 'package:flutter_prime/core/utils/style.dart';
// import 'package:flutter_prime/data/controller/auth/two_factor_controller.dart';
// import 'package:flutter_prime/data/repo/auth/two_factor_repo.dart';
// import 'package:flutter_prime/data/services/api_service.dart';
// import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';
// import 'package:flutter_prime/view/components/buttons/rounded_button.dart';
// import 'package:flutter_prime/view/components/buttons/rounded_loading_button.dart';
// import 'package:flutter_prime/view/components/text/small_text.dart';
// import 'package:flutter_prime/view/components/will_pop_widget.dart';

// import '../../../components/image/custom_svg_picture.dart';


// class TwoFactorVerificationScreen extends StatefulWidget {

//   final bool isProfileCompleteEnable;
//   const TwoFactorVerificationScreen({
//     Key? key,
//     required this.isProfileCompleteEnable
//   }) : super(key: key);

//   @override
//   State<TwoFactorVerificationScreen> createState() => _TwoFactorVerificationScreenState();
// }

// class _TwoFactorVerificationScreenState extends State<TwoFactorVerificationScreen> {

//   @override
//   void initState() {

//     Get.put(ApiClient(sharedPreferences: Get.find()));
//     Get.put(TwoFactorRepo(apiClient: Get.find()));
//     final controller = Get.put(TwoFactorController(repo: Get.find()));
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.isProfileCompleteEnable=widget.isProfileCompleteEnable;
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopWidget(
//       nextRoute: RouteHelper.loginScreen,
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: MyColor.getScreenBgColor(),
//           appBar: CustomAppBar(title:MyStrings.twoFactorAuth.tr,fromAuth: true,),
//           body: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: Dimensions.space15, vertical: Dimensions.space20),
//             child: GetBuilder<TwoFactorController>(
//               builder: (controller) =>  Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const SizedBox(height: Dimensions.space20,),
//                     Container(
//                       height: 100, width: 100,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         color: MyColor.primaryColor.withOpacity(.075),
//                         shape: BoxShape.circle
//                       ),
//                       child: CustomSvgPicture(image:MyImages.emailVerifyImage, height: 50, width: 50, color: MyColor.getPrimaryColor()),
//                     ),
//                     const SizedBox(height: Dimensions.space50),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*.07 ),
//                       child: SmallText(text: MyStrings.twoFactorMsg.tr, maxLine:3,textAlign: TextAlign.center, textStyle: regularDefault.copyWith(color: MyColor.getLabelTextColor())),
//                     ),
//                     const SizedBox(height: Dimensions.space50),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: Dimensions.space30),
//                       child: PinCodeTextField(
//                         appContext: context,
//                         pastedTextStyle: regularDefault.copyWith(color: MyColor.getTextColor()),
//                         length: 6,
//                         textStyle: regularDefault.copyWith(color: MyColor.getTextColor()),
//                         obscureText: false,
//                         obscuringCharacter: '*',
//                         blinkWhenObscuring: false,
//                         animationType: AnimationType.fade,
//                         pinTheme: PinTheme(
//                           shape: PinCodeFieldShape.box,
//                           borderWidth: 1,
//                           borderRadius: BorderRadius.circular(5),
//                           fieldHeight: 40,
//                           fieldWidth: 40,
//                           inactiveColor:  MyColor.getTextFieldDisableBorder(),
//                           inactiveFillColor: MyColor.getTransparentColor(),
//                           activeFillColor: MyColor.getTransparentColor(),
//                           activeColor: MyColor.primaryColor,
//                           selectedFillColor: MyColor.getTransparentColor(),
//                           selectedColor: MyColor.primaryColor
//                         ),
//                         cursorColor: MyColor.colorWhite,
//                         animationDuration:
//                         const Duration(milliseconds: 100),
//                         enableActiveFill: true,
//                         keyboardType: TextInputType.number,
//                         beforeTextPaste: (text) {
//                           return true;
//                         },
//                         onChanged: (value) {
//                           setState(() {
//                             controller.currentText = value;
//                           });
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: Dimensions.space30),
//                     controller.submitLoading ? const RoundedLoadingBtn() : RoundedButton(
//                       press: (){
//                         controller.verifyYourSms(controller.currentText);
//                       },
//                       text: MyStrings.verify.tr,
//                     ),
//                     const SizedBox(height: Dimensions.space30),
//                   ],
//                 ),
//               )
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
