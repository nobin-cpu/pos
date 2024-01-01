import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/data/controller/category_product_list_model/category_product_list_controller.dart';
import 'package:flutter_prime/data/controller/pos/pos_controller.dart';
import 'package:flutter_prime/data/model/category/category_model.dart';
import 'package:flutter_prime/data/model/product/product_model.dart';
import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';
import 'package:flutter_prime/view/components/card/custom_card.dart';
import 'package:get/get.dart';

class CategoryProductListScreen extends StatefulWidget {
  const CategoryProductListScreen({Key? key}) : super(key: key);

  @override
  State<CategoryProductListScreen> createState() => _CategoryProductListScreenState();
}

class _CategoryProductListScreenState extends State<CategoryProductListScreen> {
  late final CategoryProductListController controller;
  late final PosController posController;
  late final CategoryModel category;

  @override
  void initState() {
    super.initState();
    controller = Get.put(CategoryProductListController());
    posController = Get.find();
    category = Get.arguments.isNotEmpty ? Get.arguments[0] : CategoryModel();
    controller.initData(category.title!);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryProductListController>(
      builder: (controller) => Scaffold(
        appBar: CustomAppBar(
          title: '${category.title}',
          isActionImage: true,
          isShowActionBtn: true,
          actionIcon: MyImages.cart,
          actionPress: () {
            Get.toNamed(RouteHelper.cartScreen);
          },
        ),
        body: ListView.builder(
          itemCount: controller.productList.length,
          itemBuilder: (context, index) {
            ProductModel product = controller.productList[index];
            return Padding(
              padding: const EdgeInsets.all(Dimensions.space5),
              child: InkWell(
                onTap: () {
                  print("object");
                  //controller.showQuantityDialog(product, context);
                },
                child: CustomCard(
                    width: double.infinity,
                    child: ListTile(
                      title: Text(product.name ?? ""),
                      subtitle: Text('Price: ${product.price}'),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.space3),
                        child: Image.file(
                          File(product.imagePath ?? ""),
                          height: Dimensions.space70,
                          width: Dimensions.space70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      onTap: () {
                        print("object");
                        controller.showAddToCartBottomSheet(product, context, index);
                      },
                    )),
              ),
            );
          },
        ),
      ),
    );
  }
}
