import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_prime/core/helper/shared_preference_helper.dart';
import 'package:flutter_prime/core/utils/method.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/url_container.dart';
import 'package:flutter_prime/data/model/auth/verification/email_verification_model.dart';
import 'package:flutter_prime/data/model/global/response_model/response_model.dart';
import 'package:flutter_prime/data/services/api_service.dart';
import 'package:flutter_prime/view/components/snack_bar/show_custom_snackbar.dart';


class LoginRepo {

  ApiClient apiClient;

  LoginRepo({ required this.apiClient});

  // Future<ResponseModel> loginUser(String email,String password) async{

  //   Map<String, String> map = {'username': email, 'password': password};
  //   String url = '${UrlContainer.baseUrl}${UrlContainer.loginEndPoint}';

  //   ResponseModel model=await apiClient.request(url, Method.postMethod, map,passHeader: false);

  //   return model;
  // }


  // Future<String> forgetPassword(String type, String value) async {

  //   final map        =  modelToMap(value, type);
  //   String url       =  '${UrlContainer.baseUrl}${UrlContainer.forgetPasswordEndPoint}';
  //   final response   =  await apiClient.request(url, Method.postMethod,map,isOnlyAcceptType: true,passHeader: true);

  //   EmailVerificationModel model  =   EmailVerificationModel.fromJson(jsonDecode(response.responseJson));

  //   if (model.status.toLowerCase() == "success") {

  //     apiClient.sharedPreferences.setString(SharedPreferenceHelper.userEmailKey, model.data?.email ?? '');
  //     CustomSnackBar.success(successList:['${MyStrings.passwordResetEmailSentTo} ${model.data?.email ?? MyStrings.yourEmail}']);
  //     return model.data?.email??'';
  //   }
  //   else {
  //     CustomSnackBar.error(errorList: model.message!.error ?? [MyStrings.requestFail]);
  //     return '';
  //   }
  // }

  // Map<String, String> modelToMap(String value, String type) {
  //   Map<String, String> map = {'type': type, 'value': value};
  //   return map;
  // }

  // Future<EmailVerificationModel> verifyForgetPassCode(String code) async {

  //   String? email = apiClient.sharedPreferences.getString(SharedPreferenceHelper.userEmailKey) ?? '';
  //   Map<String, String> map  = {'code': code, 'email': email};

  //   String url  = '${UrlContainer.baseUrl}${UrlContainer.passwordVerifyEndPoint}';

  //   final response = await apiClient.request(url, Method.postMethod, map,passHeader: true,isOnlyAcceptType: true);

  //   EmailVerificationModel model = EmailVerificationModel.fromJson(jsonDecode(response.responseJson));
  //   if (model.status == 'success') {
  //     model.setCode(200);
  //     return model;
  //   } else {
  //     model.setCode(400);
  //     return model;
  //   }
  // }

  // Future<ResponseModel> resetPassword(
  //     String email, String password,String code) async {

  //   Map<String, String> map = {
  //     'token': code,
  //     'email': email,
  //     'password': password,
  //     'password_confirmation': password,
  //   };

  //   String url = '${UrlContainer.baseUrl}${UrlContainer.resetPasswordEndPoint}';

  //   ResponseModel responseModel = await apiClient.request(url, Method.postMethod, map,isOnlyAcceptType: true);

  //   return responseModel;

  //   //final response = await http.post(url, body: map, headers: {"Accept": "application/json",});


  // }


  // Future<bool> sendUserToken() async {

  //   String deviceToken;
  //   if (apiClient.sharedPreferences.containsKey(SharedPreferenceHelper.fcmDeviceKey)) {
  //     deviceToken = apiClient.sharedPreferences.getString(SharedPreferenceHelper.fcmDeviceKey) ?? '';
  //   } else {
  //     deviceToken = '';
  //   }

  //   FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  //   bool success = false;

  //   if (deviceToken.isEmpty) {

  //     firebaseMessaging.getToken().then((fcmDeviceToken) async {
  //       success = await sendUpdatedToken(fcmDeviceToken ?? '');
  //     });

  //   } else {
  //     firebaseMessaging.onTokenRefresh.listen((fcmDeviceToken) async {
  //       if (deviceToken == fcmDeviceToken) {
  //         success = true;
  //       } else {
  //         apiClient.sharedPreferences.setString(SharedPreferenceHelper.fcmDeviceKey, fcmDeviceToken);
  //         success = await sendUpdatedToken(fcmDeviceToken);
  //       }
  //     });
  //   }
  //   return success;
  // }

  // Future<bool> sendUpdatedToken(String deviceToken) async {
  //   String url = '${UrlContainer.baseUrl}${UrlContainer.deviceTokenEndPoint}';
  //   Map<String, String> map = deviceTokenMap(deviceToken);
  //   await apiClient.request(url, Method.postMethod, map, passHeader: true);
  //   return true;
  // }

  // Map<String, String> deviceTokenMap(String deviceToken) {
  //   Map<String, String> map = {'token': deviceToken.toString()};
  //   return map;
  // }

}
