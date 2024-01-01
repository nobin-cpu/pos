
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:get/get.dart';


class InventoryController extends GetxController{

   
   final List<Map<String, String>> dataList = [
    {'title': MyStrings.uom.tr, 'image': MyImages.uom},
    {'title': MyStrings.category.tr, 'image': MyImages.category},
    {'title': MyStrings.product.tr, 'image': MyImages.product},
  ];
}