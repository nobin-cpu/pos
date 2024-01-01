
import 'package:flutter/material.dart';
import 'package:flutter_prime/view/screens/auth/login/widgets/google_login_section.dart';
import 'package:flutter_prime/view/screens/auth/registration/widget/google_reg_section.dart';
import 'package:get/get.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/data/controller/auth/auth/registration_controller.dart';
import 'package:flutter_prime/data/repo/auth/general_setting_repo.dart';
import 'package:flutter_prime/data/repo/auth/signup_repo.dart';
import 'package:flutter_prime/data/services/api_service.dart';
import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';
import 'package:flutter_prime/view/components/will_pop_widget.dart';
import 'package:flutter_prime/view/screens/auth/registration/widget/registration_form.dart';


class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  void initState() {

    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(GeneralSettingRepo(apiClient: Get.find()));
    Get.put(RegistrationRepo(apiClient: Get.find()));
    Get.put(RegistrationController(registrationRepo: Get.find(), generalSettingRepo: Get.find()));


    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<RegistrationController>().initData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegistrationController>(
      builder: (controller) => WillPopWidget(
        nextRoute: RouteHelper.loginScreen,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: MyColor.getScreenBgColor(),
            appBar: const CustomAppBar(title: MyStrings.signUp,fromAuth: true),
            body: 
            // controller.noInternet ? NoDataOrInternetScreen(
            //   isNoInternet: true,
            //   onChanged: (value){
            //     controller.changeInternet(value);
            //   },
            // ) : controller.isLoading ? const CustomLoader() : 
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.space30, horizontal: Dimensions.space15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height*.02),
                  Center(child:Image.asset(MyImages.appLogo, height: 50, width: 225,color: MyColor.primaryColor,),),
                     Align(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                             
                              const SizedBox(height: Dimensions.space30),
                              InkWell(
                                onTap: () {
                                  // controller.handleGoogleSignIn();
                                },
                                child: const GoogleRegSection(),
                              ),
                             
                            ],
                          ),
                        ),
                      const Padding(
                                padding: EdgeInsets.symmetric(horizontal: Dimensions.space50,vertical: Dimensions.space15),
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
                                          fontWeight: FontWeight.bold,
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
                  const RegistrationForm() ,
                  const SizedBox(height: Dimensions.space30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(MyStrings.alreadyAccount.tr, style: regularLarge.copyWith(color: MyColor.getTextColor(), fontWeight: FontWeight.w500)),
                      const SizedBox(width: Dimensions.space5),
                      TextButton(
                        onPressed: (){
                          controller.clearAllData();
                          Get.offAndToNamed(RouteHelper.loginScreen);
                        },
                        child: Text(MyStrings.signIn.tr, style: regularLarge.copyWith(color: MyColor.getPrimaryColor())),
                      )
                    ],
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
