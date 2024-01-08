import 'package:flutter/material.dart';
import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';
import 'package:flutter_prime/view/screens/bottom_nav_section/home/widget/home_main_section.dart';
import 'package:get/get.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/data/controller/home/home_controller.dart';
import 'package:flutter_prime/data/repo/home/home_repo.dart';
import 'package:flutter_prime/data/services/api_service.dart';
import 'package:flutter_prime/view/components/custom_loader/custom_loader.dart';
import 'package:flutter_prime/view/components/will_pop_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(HomeRepo(apiClient: Get.find()));
    final controller = Get.put(HomeController(homeRepo: Get.find()));
    controller.isLoading = true;
    super.initState();
   
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initialData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return GetBuilder<HomeController>(
    builder: (controller) => WillPopWidget(
      nextRoute: "",
      child: SafeArea(
        
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.initialData(shouldLoad: false);
          },
          child: Scaffold(
            appBar:const CustomAppBar(
              title: "",
              isShowBackBtn: false,
              // todaysDate: DateTime.now(),
            ),
            backgroundColor: MyColor.getScreenBgColor(),
            body: controller.isLoading
                ? const CustomLoader()
                : const Center(
                  child: HomeMainSection(),
                ),
          ),
        ),
      ),
    ),
  );
}

}
