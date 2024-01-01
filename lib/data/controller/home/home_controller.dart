import 'dart:async';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/model/general_setting/general_setting_response_model.dart';
import 'package:flutter_prime/data/repo/home/home_repo.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  HomeRepo homeRepo;
  HomeController({required this.homeRepo});

  String email = "";
  bool isLoading = true;
  String username = "";
  String siteName = "";
  String imagePath = "";
  String defaultCurrency = "";

  String defaultCurrencySymbol = "";
  GeneralSettingResponseModel generalSettingResponseModel = GeneralSettingResponseModel();

  Future<void> initialData({bool shouldLoad = true}) async {
    isLoading = shouldLoad ? true : false;
    update();

    loadData();
    isLoading = false;
    update();
  }

  Future<void> loadData() async {
    defaultCurrency = homeRepo.apiClient.getCurrencyOrUsername();
    username = homeRepo.apiClient.getCurrencyOrUsername(isCurrency: false);
    email = homeRepo.apiClient.getUserEmail();
    defaultCurrencySymbol = homeRepo.apiClient.getCurrencyOrUsername(isSymbol: true);
    generalSettingResponseModel = homeRepo.apiClient.getGSData();
    siteName = generalSettingResponseModel.data?.generalSetting?.siteName ?? "";
  }

  List<Map<String, dynamic>> homeButtons = [
  {
    "image":MyImages.inventory ,
    "title": MyStrings.inventory,
    "color": MyColor.colorGrey,
  },
  {
    "image":MyImages.stock ,
    "title": MyStrings.stock,
    "color": MyColor.greenP,
  },
  {
    "image":MyImages.pos ,
    "title": MyStrings.pos,
    "color": MyColor.labelTextColor,
  },
  {
    "image":MyImages.report ,
    "title": MyStrings.report,
    "color": MyColor.primaryButtonColor,
  },
  {
    "image":MyImages.issue ,
    "title": MyStrings.issue,
    "color": MyColor.colorRed,
  },
  {
    "image":MyImages.contact ,
    "title": MyStrings.contact,
     "color": MyColor.redCancelTextColor,
  },
 
];


}
