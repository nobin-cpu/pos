// import 'package:get/get.dart';
// import 'package:flutter_prime/core/route/route.dart';
// import 'package:flutter_prime/core/utils/my_strings.dart';
// import 'package:flutter_prime/data/model/auth/verification/email_verification_model.dart';
// import 'package:flutter_prime/data/repo/auth/login_repo.dart';
// import 'package:flutter_prime/view/components/snack_bar/show_custom_snackbar.dart';

// class VerifyPasswordController extends GetxController{

//   LoginRepo loginRepo;
//   VerifyPasswordController({required this.loginRepo});


//   String email    = '';
//   String password = '';
//   bool isLoading  = false;
//   bool remember   = false;
//   bool hasError   = false;

//   List<String> errors    = [];
//   String currentText     = "";
//   String confirmPassword = '';

//   bool isResendLoading=false;

//   void resendForgetPassCode() async {

//     isResendLoading=true;
//     update();
//     String value = email;
//     String type = 'email';
//     await loginRepo.forgetPassword(type, value);
//     isResendLoading=false;
//     update();

//   }

//   bool verifyLoading=false;

//   void verifyForgetPasswordCode(String value) async{

//     if(value.isNotEmpty){

//       verifyLoading=true;
//       update();

//       EmailVerificationModel model= await loginRepo.verifyForgetPassCode(value);

//       if(model.code==200){
//         verifyLoading=false;
//         Get.offAndToNamed(RouteHelper.resetPasswordScreen,arguments: [email,value]);
//       }else{
//         verifyLoading=false;
//         update();
//         List<String>errorList=[MyStrings.verificationFailed];
//         CustomSnackBar.error(errorList: model.message?.error??errorList);
//       }
//     }
//   }

//   String getFormatedMail(){
//     try{
//       List<String>tempList = email.split('@');
//       int maskLength = tempList[0].length;
//       String maskValue = tempList[0][0].padRight(maskLength,'*');
//       String value = '$maskValue@${tempList[1]}';
//       return value;
//     } catch(e){
//       return email;
//     }

//   }

// }


