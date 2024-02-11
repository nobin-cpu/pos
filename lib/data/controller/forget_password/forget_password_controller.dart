import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:get/get.dart';

class ForgetPassswordController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController forgetPasswordController = TextEditingController();
  bool isSubmitLoading = false;
  Future<void> resetPassword() async {
    isSubmitLoading = true;
    update();

    try {
      await _auth.sendPasswordResetEmail(email: forgetPasswordController.text);
      Get.offAllNamed(RouteHelper.splashScreen);
      CustomSnackBar.success(successList: [MyStrings.resetPasswordSenttoEmail]);
    } catch (e) {
      CustomSnackBar.error(errorList: [e.toString()]);
    }
    isSubmitLoading = false;
    update();
  }
}
