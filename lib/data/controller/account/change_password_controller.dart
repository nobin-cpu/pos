import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/model/authorization/authorization_response_model.dart';
import 'package:flutter_prime/data/model/global/response_model/response_model.dart';
import 'package:flutter_prime/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:flutter_prime/data/repo/account/change_password_repo.dart';


class ChangePasswordController extends GetxController  {

  ChangePasswordRepo changePasswordRepo;
  ChangePasswordController({required this.changePasswordRepo});


  String? currentPass, password, confirmPass;

  bool isLoading      = false;
  List<String> errors = [];

  TextEditingController passController        = TextEditingController();
  TextEditingController currentPassController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  FocusNode currentPassFocusNode = FocusNode();
  FocusNode passwordFocusNode    = FocusNode();
  FocusNode confirmPassFocusNode = FocusNode();



  addError({required String error}) {
    if (!errors.contains(error)) {
      errors.add(error);
      update();
    }
  }

  removeError({required String error}) {
    if (errors.contains(error)) {
      errors.remove(error);
      update();
    }
  }

  bool submitLoading=false;
  changePassword() async {

    String currentPass = currentPassController.text.toString();
    String password = passController.text.toString();

    submitLoading = true;
    update();
    ResponseModel responseModel = await changePasswordRepo.changePassword(currentPass, password);

    if(responseModel.statusCode == 200){
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      if(model.status?.toLowerCase() == MyStrings.success.toLowerCase()){
        currentPassController.clear();
        passController.clear();
        confirmPassController.clear();
      } else{
        CustomSnackBar.error(errorList: model.message?.error??[MyStrings.requestFail]);
      }
    } else{
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    submitLoading = false;
    update();
  }

  void clearData() {
    isLoading=false;
    errors.clear();
    currentPassController.text='';
    passController.text='';
    confirmPassController.text='';
  }
}
