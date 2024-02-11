import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_prime/view/screens/auth/login/widgets/google_login_section.dart';
import 'package:get/get.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/data/controller/auth/login_controller.dart';
import 'package:flutter_prime/data/repo/auth/login_repo.dart';
import 'package:flutter_prime/data/services/api_service.dart';
import 'package:flutter_prime/view/components/buttons/rounded_button.dart';
import 'package:flutter_prime/view/components/buttons/rounded_loading_button.dart';
import 'package:flutter_prime/view/components/text-form-field/custom_text_field.dart';
import 'package:flutter_prime/view/components/text/default_text.dart';
import 'package:flutter_prime/view/components/will_pop_widget.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  bool _connected = false;

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(LoginRepo(apiClient: Get.find()));
    Get.put(LoginController(loginRepo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<LoginController>().remember = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopWidget(
      nextRoute: '',
      child: SafeArea(
        child: Scaffold(
          backgroundColor: MyColor.getScreenBgColor(),
          body: GetBuilder<LoginController>(
            builder: (controller) => SingleChildScrollView(
              padding: Dimensions.screenPaddingHV,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * .06),
                  Center(
                    child: Image.asset(MyImages.appLogo, height: 100, width: 225),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .08),
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomTextField(
                          animatedLabel: true,
                          needOutlineBorder: true,
                          controller: controller.emailController,
                          labelText: MyStrings.usernameOrEmail.tr,
                          onChanged: (value) {},
                          focusNode: controller.emailFocusNode,
                          nextFocus: controller.passwordFocusNode,
                          textInputType: TextInputType.emailAddress,
                          inputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return MyStrings.fieldErrorMsg.tr;
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: Dimensions.space20),
                        CustomTextField(
                          animatedLabel: true,
                          needOutlineBorder: true,
                          labelText: MyStrings.password.tr,
                          controller: controller.passwordController,
                          focusNode: controller.passwordFocusNode,
                          onChanged: (value) {},
                          isShowSuffixIcon: true,
                          isPassword: true,
                          textInputType: TextInputType.text,
                          inputAction: TextInputAction.done,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return MyStrings.fieldErrorMsg.tr;
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: Dimensions.space25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: Dimensions.space25,
                                  height: Dimensions.space25,
                                  child: Checkbox(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.defaultRadius)),
                                      activeColor: MyColor.primaryColor,
                                      checkColor: MyColor.colorWhite,
                                      value: controller.remember,
                                      side: MaterialStateBorderSide.resolveWith(
                                        (states) => BorderSide(width: 1.0, color: controller.remember ? MyColor.getTextFieldEnableBorder() : MyColor.getTextFieldDisableBorder()),
                                      ),
                                      onChanged: (value) {
                                        controller.changeRememberMe();
                                      }),
                                ),
                                const SizedBox(width: Dimensions.space8),
                                DefaultText(text: MyStrings.rememberMe.tr, textColor: MyColor.getTextColor())
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                controller.clearTextField();
                                Get.toNamed(RouteHelper.forgetPasswordScreen);
                              },
                              child: Text(MyStrings.forgotPassword.tr, maxLines: 2, overflow: TextOverflow.ellipsis, style: regularLarge.copyWith(color: MyColor.getPrimaryColor(), fontWeight: FontWeight.w500)),
                            )
                          ],
                        ),
                        const SizedBox(height: Dimensions.space25),
                        controller.isSubmitLoading
                            ? const RoundedLoadingBtn()
                            : RoundedButton(
                                text: MyStrings.signIn.tr,
                                press: () {
                                  if (formKey.currentState!.validate()) {
                                    controller.loginUser();
                                  }
                                }),
                        const SizedBox(height: Dimensions.space20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(MyStrings.doNotHaveAccount.tr,
                                overflow: TextOverflow.ellipsis,
                                style: regularLarge.copyWith(
                                  color: MyColor.getTextColor(),
                                )),
                            TextButton(
                              onPressed: () async {
                                Get.offAndToNamed(RouteHelper.registrationScreen);
                              },
                              child: Text(MyStrings.signUp.tr, maxLines: 2, overflow: TextOverflow.ellipsis, style: regularLarge.copyWith(color: MyColor.getPrimaryColor(), fontWeight: FontWeight.w500)),
                            )
                          ],
                        ),
                        Align(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: Dimensions.space50),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Flexible(
                                      child: Divider(
                                        color: MyColor.greyColor,
                                        thickness: 0.4,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: Dimensions.space10),
                                      child: Text(
                                        MyStrings.or,
                                        style: TextStyle(
                                          color: MyColor.primaryColor,
                                          fontSize: Dimensions.space15,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Divider(
                                        color: MyColor.greyColor,
                                        thickness: 0.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: Dimensions.space30),
                              InkWell(
                                onTap: () {},
                                child: const GoogleLoginSection(),
                              ),
                             
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
