import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_prime/core/helper/secured_storage_helper.dart';
import 'package:get/get.dart';
import 'package:flutter_prime/core/helper/shared_preference_helper.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/model/auth/login/login_response_model.dart';
import 'package:flutter_prime/data/model/global/response_model/response_model.dart';
import 'package:flutter_prime/data/repo/auth/login_repo.dart';
import 'package:flutter_prime/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as prefix;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginController extends GetxController {
  LoginRepo loginRepo;
  LoginController({required this.loginRepo});

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? email;
  String? password;
  String uniqueID = "";
  List<String> errors = [];
  bool remember = false;

  void forgetPassword() {
    Get.toNamed(RouteHelper.forgotPasswordScreen);
  }

  void checkAndGotoNextStep() async {
    if (remember) {
      final storage = new FlutterSecureStorage();
      await storage.write(key: SecuredStorageHelper.uniqueID, value: uniqueID);
      Get.offAllNamed(RouteHelper.bottomNavBar);
    } else {
      await loginRepo.apiClient.sharedPreferences.setBool(SharedPreferenceHelper.rememberMeKey, false);
      Get.offAllNamed(RouteHelper.bottomNavBar);
    }

    if (remember) {
      changeRememberMe();
    }
  }

  prefix.FirebaseAuth _auth = prefix.FirebaseAuth.instance;
  bool isSubmitLoading = false;
  loginUser() async {
    isSubmitLoading = true;
    update();

    try {
      prefix.UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Login successful, handle further steps here...
      // For example, check if the user's email is verified

      prefix.User? user = userCredential.user;
      if (user != null) {
        if (user.emailVerified) {
          print("Login successful. Email is verified.");
          await _saveUidAndUserDataToSecureStorage(user.uid, user.displayName, user.email, user.photoURL);
        } else {
          print("Login successful, but email is not verified.");
          await _saveUidAndUserDataToSecureStorage(user.uid, user.displayName, user.email, user.photoURL);
          CustomSnackBar.success(successList: [MyStrings.success]);
          checkAndGotoNextStep();
        }
      } else {
        print("Login failed. User is null.");
        CustomSnackBar.error(errorList: [MyStrings.loginFailedTryAgain]);
      }
    } on prefix.FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.message}");
      CustomSnackBar.error(errorList: [e.message.toString()]);
    }

    isSubmitLoading = false;
    update();
  }

  changeRememberMe() {
    remember = !remember;
    update();
  }

  void clearTextField() {
    passwordController.text = '';
    emailController.text = '';

    if (remember) {
      remember = false;
    }
    update();
  }

  bool loading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void handleGoogleSignIn() async {
    loading = true;
    update();

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final prefix.AuthCredential credential = prefix.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      final prefix.UserCredential authResult = await prefix.FirebaseAuth.instance.signInWithCredential(credential);
      final prefix.User? user = authResult.user;

      if (user != null) {
        print("Google Sign-In Successful: ${user.displayName}");

        // Check if the user is registered in Firebase
        bool isRegisteredUser = await isUserRegistered(user.email!);

        if (isRegisteredUser) {
          bool isDeletedUser = await isUserDeleted(user.email!);

          if (!isDeletedUser) {
            await _saveUidAndUserDataToSecureStorage(user.uid, user.displayName, user.email, user.photoURL);

            checkAndGotoNextStep();
            CustomSnackBar.success(successList: [MyStrings.success]);
          } else {
            print('User has deleted their account, skip adding coins.');
            await prefix.FirebaseAuth.instance.signOut();
            CustomSnackBar.error(errorList: [MyStrings.thisAccIsdeleted]);
          }
        } else {
          // User is not registered, handle accordingly (e.g., show an error message).
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

  Future<bool> isUserRegistered(String email) async {
    try {
      // Query Firestore to check if a user with the given email exists
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('users') // Change 'users' to your collection name
          .where('email', isEqualTo: email)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (error) {
      print("Error checking user registration: $error");
      return false;
    }
  }

  String? uis = "";
  Future<void> _saveUidAndUserDataToSecureStorage(String uid, username, email, photo) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: SecuredStorageHelper.uniqueID, value: uid);
    await storage.write(key: SecuredStorageHelper.userName, value: username);
    await storage.write(key: SecuredStorageHelper.email, value: email);
    await storage.write(key: SecuredStorageHelper.photo, value: photo);
    uis = await storage.read(key: SecuredStorageHelper.uniqueID);
    print("succesfully saved everything=====================================================" + uis.toString());
    print("send $uid=====================================================get the uid: " + uis.toString());
    uniqueID = uis.toString();
  }

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