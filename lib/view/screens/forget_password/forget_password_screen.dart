import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_prime/data/controller/forget_password/forget_password_controller.dart';
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


class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final formKey = GlobalKey<FormState>();

  bool _connected = false;

  @override
  void initState() {
  
    Get.put(ForgetPassswordController());

    super.initState();

  
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
          body: GetBuilder<ForgetPassswordController>(
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
                       
                        const SizedBox(height: Dimensions.space20),
                        CustomTextField(
                          animatedLabel: true,
                          needOutlineBorder: true,
                          labelText: MyStrings.email.tr,
                          controller: controller.forgetPasswordController,
                          
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
                        
                        const SizedBox(height: Dimensions.space25),
                        controller.isSubmitLoading
                            ? const RoundedLoadingBtn()
                            : RoundedButton(
                                text: MyStrings.sendVerificationMail.tr,
                                press: () {
                                  if (formKey.currentState!.validate()) {
                                    controller.resetPassword();
                                  }
                                }),
                        const SizedBox(height: Dimensions.space20),
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
