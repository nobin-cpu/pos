// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_prime/core/route/route.dart';
// import 'package:flutter_prime/core/utils/my_strings.dart';
// import 'package:flutter_prime/data/model/profile/profile_response_model.dart';
// import 'package:flutter_prime/data/model/user_post_model/user_post_model.dart';
// import 'package:flutter_prime/data/repo/account/profile_repo.dart';
// import 'package:flutter_prime/view/components/snack_bar/show_custom_snackbar.dart';



// class ProfileCompleteController extends GetxController {

//   ProfileRepo profileRepo;
//   ProfileCompleteController({required this.profileRepo});

//   ProfileResponseModel model = ProfileResponseModel();

//   TextEditingController firstNameController = TextEditingController();
//   TextEditingController lastNameController  = TextEditingController();
//   TextEditingController emailController     = TextEditingController();
//   TextEditingController mobileNoController  = TextEditingController();
//   TextEditingController addressController   = TextEditingController();
//   TextEditingController stateController     = TextEditingController();
//   TextEditingController zipCodeController   = TextEditingController();
//   TextEditingController cityController      = TextEditingController();


//   FocusNode firstNameFocusNode = FocusNode();
//   FocusNode lastNameFocusNode  = FocusNode();
//   FocusNode emailFocusNode     = FocusNode();
//   FocusNode mobileNoFocusNode  = FocusNode();
//   FocusNode addressFocusNode   = FocusNode();
//   FocusNode stateFocusNode     = FocusNode();
//   FocusNode zipCodeFocusNode   = FocusNode();
//   FocusNode cityFocusNode      = FocusNode();
//   FocusNode countryFocusNode   = FocusNode();


//   bool isLoading     = false;
//   bool submitLoading = false;

//   updateProfile()async{

//     String firstName = firstNameController.text;
//     String lastName  = lastNameController.text.toString();
//     String address   = addressController.text.toString();
//     String city      = cityController.text.toString();
//     String zip       = zipCodeController.text.toString();
//     String state     = stateController.text.toString();


//     if(firstName.isEmpty){
//       CustomSnackBar.error(errorList: [MyStrings.kFirstNameNullError]);
//       return;
//     }else if(lastName.isEmpty){
//       CustomSnackBar.error(errorList: [MyStrings.kLastNameNullError]);
//       return;
//     }

//     submitLoading=true;
//     update();

//     UserPostModel model=UserPostModel(
//       image: null, firstname: firstName, lastName: lastName,
//       mobile: '', email: '', username: '', countryCode: '',
//       country: '', mobileCode: '8', address: address,
//       state: state, zip: zip, city: city
//     );

//     bool b= await profileRepo.updateProfile(model,false);

//     if(b){
//       Get.offAllNamed(RouteHelper.bottomNavBar);
//       return;
//     }

//     submitLoading=false;
//     update();

//   }

// }
