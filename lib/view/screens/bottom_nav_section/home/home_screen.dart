import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
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
              backgroundColor: MyColor.colorWhite,
              appBar:const CustomAppBar(
                title: "",
                isShowBackBtn: false,
               
              ),
              body: controller.isLoading
                  ? const CustomLoader()
                  : SingleChildScrollView(
                    physics:const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                       controller.shopName.isNotEmpty?   Padding(
                            padding: const EdgeInsets.only(bottom:  5,left: Dimensions.space10),
                            child: Text(
                              "${MyStrings.hi}${controller.shopName}",
                              style: semiBoldExtraLarge,
                            ),
                          ):const SizedBox(),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              MyStrings.whatDoYouWantToDoToday,
                              style: regularExtraLarge,
                            ),
                          ),
                          const HomeMainSection(),
                        ],
                      ),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
