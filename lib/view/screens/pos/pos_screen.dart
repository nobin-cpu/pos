import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/controller/pos/pos_controller.dart';
import 'package:flutter_prime/data/services/api_service.dart';
import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';
import 'package:flutter_prime/view/components/bottom-nav-bar/bottom_nav_bar.dart';
import 'package:flutter_prime/view/components/custom_loader/custom_loader.dart';
import 'package:flutter_prime/view/screens/pos/widgets/pos_category_section.dart';
import 'package:get/get.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({super.key});

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
   @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    
    final controller = Get.put(PosController());
    
    super.initState();
   
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //  isPartOfBottomNavBar = Get.find<_BottomNavBarState>().currentIndex == 1;
      controller.initData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(appBar:const CustomAppBar(
      
      title: MyStrings.pos),body: GetBuilder<PosController>(
       builder: (controller) =>  Padding(
         padding: const EdgeInsets.symmetric(horizontal:Dimensions.space10,vertical: Dimensions.space10),
         child:controller.isLoading?const CustomLoader():const Column(children: [
          PosCategorySection()
               ]),
       ),
    ),);
  }
}