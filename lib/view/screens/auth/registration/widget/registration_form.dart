import 'package:flutter/material.dart';
import 'package:flutter_prime/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutter_prime/view/components/text-form-field/custom_drop_down_button_with_text_field2.dart';
import 'package:get/get.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/data/controller/auth/auth/registration_controller.dart';
import 'package:flutter_prime/view/components/buttons/rounded_button.dart';
import 'package:flutter_prime/view/components/buttons/rounded_loading_button.dart';
import 'package:flutter_prime/view/components/text-form-field/custom_text_field.dart';
import 'package:flutter_prime/view/screens/auth/registration/widget/validation_widget.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegistrationController>(
      builder: (controller) {
        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CustomTextField(
              //   animatedLabel: true,
              //   needOutlineBorder: true,
              //   labelText: MyStrings.username.tr,
              //   controller: controller.userNameController,
              //   focusNode: controller.userNameFocusNode,
              //   textInputType: TextInputType.text,
              //   nextFocus: controller.emailFocusNode,
              //   validator: (value) {
              //     if (value!.isEmpty) {
              //       return MyStrings.enterYourUsername.tr;
              //     } else if(value.length<6){
              //       return MyStrings.kShortUserNameError.tr;
              //     } else {
              //       return null;
              //     }
              //   },
              //   onChanged: (value) {
              //     return;
              //   },
              // ),
              const SizedBox(height: Dimensions.space20),
              CustomTextField(
                animatedLabel: true,
                needOutlineBorder: true,
                labelText: MyStrings.email.tr,
                controller: controller.emailController,
                focusNode: controller.emailFocusNode,
                textInputType: TextInputType.emailAddress,
                inputAction: TextInputAction.next,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return MyStrings.enterYourEmail.tr;
                  } else if (!MyStrings.emailValidatorRegExp.hasMatch(value ?? '')) {
                    return MyStrings.invalidEmailMsg.tr;
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  return;
                },
              ),
              const SizedBox(height: Dimensions.space20),
              // CountryTextField(
              //   press: (){
              //     CountryBottomSheet.bottomSheet(context, controller);
              //   },
              //   text:controller.countryName == null?MyStrings.selectACountry.tr:(controller.countryName)!.tr,
              // ),
              // const SizedBox(height: Dimensions.space20),
              Visibility(
                  visible: controller.countryName != null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Container(
                          width: 50,
                          height: 47,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: MyColor.transparentColor, borderRadius: BorderRadius.circular(Dimensions.defaultRadius), border: Border.all(color: controller.countryName == null ? MyColor.getTextFieldDisableBorder() : MyColor.getTextFieldEnableBorder(), width: 0.5)),
                          child: Text(
                            "+${controller.mobileCode}",
                            style: regularDefault.copyWith(color: MyColor.getPrimaryColor()),
                          ),
                        ),
                        const SizedBox(width: Dimensions.space5 + 3),
                        Expanded(
                          child: CustomTextField(
                            animatedLabel: true,
                            needOutlineBorder: true,
                            labelText: MyStrings.phoneNo.tr,
                            controller: controller.mobileController,
                            focusNode: controller.mobileFocusNode,
                            textInputType: TextInputType.phone,
                            inputAction: TextInputAction.next,
                            onChanged: (value) {
                              return;
                            },
                          ),
                        )
                      ]),
                      const SizedBox(height: Dimensions.space20),
                    ],
                  )),

              Focus(
                  onFocusChange: (hasFocus) {
                    controller.changePasswordFocus(hasFocus);
                  },
                  child: CustomTextField(
                    animatedLabel: true,
                    needOutlineBorder: true,
                    isShowSuffixIcon: true,
                    isPassword: true,
                    labelText: MyStrings.password.tr,
                    controller: controller.passwordController,
                    focusNode: controller.passwordFocusNode,
                    nextFocus: controller.confirmPasswordFocusNode,
                    textInputType: TextInputType.text,
                    onChanged: (value) {
                      if (controller.checkPasswordStrength) {
                        controller.updateValidationList(value);
                      }
                    },
                    validator: (value) {
                      return controller.validatePassword(value ?? '');
                    },
                  )),
              const SizedBox(height: Dimensions.textToTextSpace),
              Visibility(
                  visible: controller.hasPasswordFocus && controller.checkPasswordStrength,
                  child: ValidationWidget(
                    list: controller.passwordValidationRules,
                  )),
              const SizedBox(height: Dimensions.space20),
              CustomTextField(
                animatedLabel: true,
                needOutlineBorder: true,
                labelText: MyStrings.confirmPassword.tr,
                controller: controller.cPasswordController,
                focusNode: controller.confirmPasswordFocusNode,
                inputAction: TextInputAction.done,
                isShowSuffixIcon: true,
                isPassword: true,
                onChanged: (value) {},
                validator: (value) {
                  if (controller.passwordController.text.toLowerCase() != controller.cPasswordController.text.toLowerCase()) {
                    return MyStrings.kMatchPassError.tr;
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: Dimensions.space25),
              Visibility(
                  visible: controller.needAgree,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 25,
                        height: 25,
                        child: Checkbox(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.defaultRadius)),
                          activeColor: MyColor.primaryColor,
                          checkColor: MyColor.colorWhite,
                          value: controller.agreeTC,
                          side: MaterialStateBorderSide.resolveWith(
                            (states) => BorderSide(width: 1.0, color: controller.agreeTC ? MyColor.getTextFieldEnableBorder() : MyColor.getTextFieldDisableBorder()),
                          ),
                          onChanged: (bool? value) {
                            controller.updateAgreeTC();
                          },
                        ),
                      ),
                      const SizedBox(width: Dimensions.space8),
                      Row(
                        children: [
                          Text(MyStrings.iAgreeWith.tr, style: regularDefault.copyWith(color: MyColor.getTextColor())),
                          const SizedBox(width: Dimensions.space3),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(RouteHelper.privacyScreen);
                            },
                            child: Text(MyStrings.policies.tr.toLowerCase(), style: regularDefault.copyWith(color: MyColor.getPrimaryColor(), decoration: TextDecoration.underline, decorationColor: MyColor.getPrimaryColor())),
                          ),
                          const SizedBox(width: Dimensions.space3),
                        ],
                      ),
                    ],
                  )),
              const SizedBox(height: Dimensions.space30),
              controller.submitLoading
                  ? const RoundedLoadingBtn()
                  : RoundedButton(
                      text: MyStrings.signUp.tr,
                      press: () {
                        if (formKey.currentState!.validate() && controller.agreeTC) {
                          controller.signUpUser();
                        } else {
                          CustomSnackBar.error(errorList: [

                            MyStrings.fillAllTheFields
                          ]);
                        }
                      }),
            ],
          ),
        );
      },
    );
  }
}
