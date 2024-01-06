import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/secured_storage_helper.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_prime/core/helper/shared_preference_helper.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/model/auth/sign_up_model/registration_response_model.dart';
import 'package:flutter_prime/data/model/auth/sign_up_model/sign_up_model.dart';
import 'package:flutter_prime/data/model/general_setting/general_setting_response_model.dart';
import 'package:flutter_prime/data/model/global/response_model/response_model.dart';
import 'package:flutter_prime/data/model/model/error_model.dart';
import 'package:flutter_prime/data/repo/auth/general_setting_repo.dart';
import 'package:flutter_prime/data/repo/auth/signup_repo.dart';
import 'package:flutter_prime/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as prefix;

class RegistrationController extends GetxController {
  RegistrationRepo registrationRepo;
  GeneralSettingRepo generalSettingRepo;

  RegistrationController({required this.registrationRepo, required this.generalSettingRepo});

  bool isLoading = true;
  bool rememberMe = false;
  bool agreeTC = false;

  GeneralSettingResponseModel generalSettingMainModel = GeneralSettingResponseModel();

  bool checkPasswordStrength = false;
  bool needAgree = true;

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();
  final FocusNode countryNameFocusNode = FocusNode();
  final FocusNode mobileFocusNode = FocusNode();
  final FocusNode userNameFocusNode = FocusNode();
  final FocusNode companyNameFocusNode = FocusNode();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cPasswordController = TextEditingController();
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();

  String? email;
  String? password;
  String? confirmPassword;
  String? countryName;
  String? countryCode;
  String? mobileCode;
  String? userName;
  String? phoneNo;
  String? firstName;
  String? lastName;

  RegExp regex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  bool submitLoading = false;

  signUpUser() async {
    if (needAgree && !agreeTC) {
      CustomSnackBar.error(
        errorList: [MyStrings.agreePolicyMessage],
      );
      return;
    }

    submitLoading = true;
    update();

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
       await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
      'email': emailController.text,
      'displayName': userCredential.user!.displayName,
    });
      await _saveUidToSharedPreference(userCredential.user!.uid, true,userCredential.user!.displayName.toString(),userCredential.user!.email.toString());
        CustomSnackBar.success(successList: [MyStrings.success]);
     Get.offAndToNamed(RouteHelper.bottomNavBar);
    } on FirebaseAuthException catch (e) {
      CustomSnackBar.error(errorList: [e.message.toString()]);
    }

    submitLoading = false;
    update();
  }

 

  setCountryNameAndCode(String cName, String countryCode, String mobileCode) {
    countryName = cName;
    this.countryCode = countryCode;
    this.mobileCode = mobileCode;
    update();
  }

  updateAgreeTC() {
    agreeTC = !agreeTC;
    update();
  }

  SignUpModel getUserData() {
    SignUpModel model = SignUpModel(
      companyName: companyNameController.text.toString(),
      mobile: mobileController.text.toString(),
      email: emailController.text.toString(),
      agree: agreeTC ? true : false,
      username: userNameController.text.toString(),
      password: passwordController.text.toString(),
      country: countryName.toString(),
      mobileCode: mobileCode != null ? mobileCode!.replaceAll("[+]", "") : "",
      countryCode: countryCode ?? '',
    );

    return model;
  }

  void checkAndGotoNextStep(RegistrationResponseModel responseModel) async {
    bool needEmailVerification = responseModel.data?.user?.ev == "1" ? false : true;
    bool needSmsVerification = responseModel.data?.user?.sv == "1" ? false : true;

    SharedPreferences preferences = registrationRepo.apiClient.sharedPreferences;

    await preferences.setString(SharedPreferenceHelper.userIdKey, responseModel.data?.user?.id.toString() ?? '-1');
    await preferences.setString(SharedPreferenceHelper.accessTokenKey, responseModel.data?.accessToken ?? '');
    await preferences.setString(SharedPreferenceHelper.accessTokenType, responseModel.data?.tokenType ?? '');
    await preferences.setString(SharedPreferenceHelper.userEmailKey, responseModel.data?.user?.email ?? '');
    await preferences.setString(SharedPreferenceHelper.userNameKey, responseModel.data?.user?.username ?? '');
    await preferences.setString(SharedPreferenceHelper.userPhoneNumberKey, responseModel.data?.user?.mobile ?? '');

    await registrationRepo.sendUserToken();

    bool isProfileCompleteEnable = true;
    bool isTwoFactorEnable = false;

    // if (needEmailVerification == false && needSmsVerification == false) {
    //   Get.offAndToNamed(RouteHelper.profileCompleteScreen);
    // } else if (needEmailVerification == true && needSmsVerification == true) {
    //   Get.offAndToNamed(RouteHelper.emailVerificationScreen, arguments: [true, isProfileCompleteEnable, isTwoFactorEnable]);
    // } else if (needEmailVerification) {
    //   Get.offAndToNamed(RouteHelper.emailVerificationScreen, arguments: [false, isProfileCompleteEnable, isTwoFactorEnable]);
    // } else if (needSmsVerification) {
    //   Get.offAndToNamed(RouteHelper.smsVerificationScreen, arguments: [isProfileCompleteEnable, isTwoFactorEnable]);
    // }
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  void closeAllController() {
    isLoading = false;
    emailController.text = '';
    passwordController.text = '';
    cPasswordController.text = '';
  }

  clearAllData() {
    closeAllController();
  }

  List<ErrorModel> passwordValidationRules = [
    ErrorModel(text: MyStrings.hasUpperLetter.tr, hasError: true),
    ErrorModel(text: MyStrings.hasLowerLetter.tr, hasError: true),
    ErrorModel(text: MyStrings.hasDigit.tr, hasError: true),
    ErrorModel(text: MyStrings.hasSpecialChar.tr, hasError: true),
    ErrorModel(text: MyStrings.minSixChar.tr, hasError: true),
  ];

  bool isCountryLoading = true;
  void initData() async {
    isLoading = true;
    update();
    await getCountryData();

    ResponseModel response = await generalSettingRepo.getGeneralSetting();
    if (response.statusCode == 200) {
      GeneralSettingResponseModel model = GeneralSettingResponseModel.fromJson(jsonDecode(response.responseJson));
      if (model.status?.toLowerCase() == 'success') {
        generalSettingMainModel = model;
        registrationRepo.apiClient.storeGeneralSetting(model);
      } else {
        List<String> message = [MyStrings.somethingWentWrong.tr];
        CustomSnackBar.error(errorList: model.message?.error ?? message);
        return;
      }
    } else {
      if (response.statusCode == 503) {
        noInternet = true;
        update();
      }
      CustomSnackBar.error(errorList: [response.message]);
      return;
    }

    needAgree = generalSettingMainModel.data?.generalSetting?.agree.toString() == '0' ? false : true;
    checkPasswordStrength = generalSettingMainModel.data?.generalSetting?.securePassword.toString() == '0' ? false : true;

    isLoading = false;
    update();
  }

  bool countryLoading = true;
  // List<Countries> countryList = [];

  Future<dynamic> getCountryData() async {
    ResponseModel mainResponse = await registrationRepo.getCountryList();

    // if (mainResponse.statusCode == 200) {
    //   CountryModel model = CountryModel.fromJson(jsonDecode(mainResponse.responseJson));
    //   List<Countries>? tempList = model.data?.countries;

    //   if (tempList != null && tempList.isNotEmpty) {
    //     countryList.addAll(tempList);
    //   }
    // } else {
    //   CustomSnackBar.error(errorList: [mainResponse.message]);
    // }

    countryLoading = false;
    update();
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return MyStrings.enterYourPassword_.tr;
    } else {
      if (checkPasswordStrength) {
        if (!regex.hasMatch(value)) {
          return MyStrings.invalidPassMsg.tr;
        } else {
          return null;
        }
      } else {
        return null;
      }
    }
  }

  bool noInternet = false;
  void changeInternet(bool hasInternet) {
    noInternet = false;
    initData();
    update();
  }

  void updateValidationList(String value) {
    passwordValidationRules[0].hasError = value.contains(RegExp(r'[A-Z]')) ? false : true;
    passwordValidationRules[1].hasError = value.contains(RegExp(r'[a-z]')) ? false : true;
    passwordValidationRules[2].hasError = value.contains(RegExp(r'[0-9]')) ? false : true;
    passwordValidationRules[3].hasError = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')) ? false : true;
    passwordValidationRules[4].hasError = value.length >= 6 ? false : true;

    update();
  }

  bool hasPasswordFocus = false;
  void changePasswordFocus(bool hasFocus) {
    hasPasswordFocus = hasFocus;
    update();
  }

  bool loading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
void handleGoogleSignIn() async {
  await GoogleSignIn().signOut();
  loading = true;
  update();

  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      print("Google Sign-In: User canceled sign-in.");
      return;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final prefix.AuthCredential credential = prefix.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    print("Google Sign-In: Successfully obtained Google credentials.");
    

    final prefix.UserCredential authResult = await prefix.FirebaseAuth.instance.signInWithCredential(credential);
    final prefix.User? user = authResult.user;
       await FirebaseFirestore.instance.collection('users').doc(credential.accessToken).set({
      'email': user!.email,
    });
    if (user != null) {
      print("Google Sign-In Successful: ${user.displayName}");

      bool isRegisteredUser = await isUserRegistered(user.email!);

      if (isRegisteredUser) {
        bool isDeletedUser = await isUserDeleted(user.email!);

        if (!isDeletedUser) {
          await _saveUidToSharedPreference(user.uid, true, user.displayName.toString(), user.email.toString());
          Get.offAndToNamed(RouteHelper.bottomNavBar);
        } else {
          print('User has deleted their account, skip adding coins.');
          await prefix.FirebaseAuth.instance.signOut();
          CustomSnackBar.error(errorList: [MyStrings.thisAccIsdeleted]);
        }
      } else {
        print('User is not registered. Please register first.');
        await prefix.FirebaseAuth.instance.signOut();
      }
    }
  } catch (error) {
    loading = false;
    update();
    print("Google Sign-In Error: $error");
  }

  loading = false;
  update();
}

  Future<void> _saveUidToSharedPreference(String uid, bool rememberMe, String userName, String email) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString(SharedPreferenceHelper.userIdKey, uid);
  await preferences.setString(SharedPreferenceHelper.userNameKey, userName);
  await preferences.setString(SharedPreferenceHelper.userEmailKey, email); 
  await preferences.setBool(SharedPreferenceHelper.rememberMeKey, rememberMe);
  print("my name is " + userName);
}


Future<bool> isUserRegistered(String email) async {
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).get();
    return querySnapshot.docs.isNotEmpty;
  } catch (error) {
    print("Error checking user registration: $error");
    return false;
  }
}


  String? uis = "";

  // Future<void> _saveUidAndUserDataToSecureStorage(String uid, username, email, photo) async {
  //   final storage = new FlutterSecureStorage();
  //   await storage.write(key: SecuredStorageHelper.uniqueID, value: uid);
  //   await storage.write(key: SecuredStorageHelper.userName, value: username);
  //   await storage.write(key: SecuredStorageHelper.email, value: email);
  //   await storage.write(key: SecuredStorageHelper.photo, value: photo);
  //   uis = await storage.read(key: SecuredStorageHelper.uniqueID);
  //   print("succesfully saved everything=====================================================" + uis.toString());
  //   print("send $uid=====================================================get the uid: " + uis.toString());
  // }

  Future<bool> isUserDeleted(String email) async {
    try {
      var doc = await _firestore.collection('deletedUsers').doc(email).get();
      return doc.exists;
    } catch (e) {
      print('Error checking deleted user: $e');
      return false;
    }
  }
}
