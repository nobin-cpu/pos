import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_prime/core/route/route.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/my_images.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/core/utils/style.dart';
import 'package:flutter_prime/data/controller/category_product_list_model/category_product_list_controller.dart';
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
  @override
  void initState() {
    super.initState();
    final controller = Get.put(CategoryProductListController());
     controller.categoryTitle = Get.arguments.isNotEmpty ? Get.arguments[0] : "";
    controller.loadProductData(controller.categoryTitle);
    controller.initData(controller.categoryTitle);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryProductListController>(
      builder: (controller) => RefreshIndicator(
        onRefresh: () {
        return   controller.initData(controller.categoryTitle);
        },
        child: Scaffold(
          appBar: CustomAppBar(
            title: controller.categoryTitle,
            isActionImage: true,
            isShowActionBtn: true,
            action: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.space12),
                    child: InkWell(
                        onTap: () {
                          Get.toNamed(RouteHelper.cheakOutScreen);
                        },
                        child: Image.asset(
                          MyImages.cart,
                          color: MyColor.colorWhite,
                          height: Dimensions.space20,
                        )),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(Dimensions.space4),
                      decoration: const BoxDecoration(color: MyColor.colorWhite, shape: BoxShape.circle),
                      child: Text(
                        controller.cartList.length.toString(),
                        style: regularDefault.copyWith(color: MyColor.colorBlack),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          body: controller.productList.isEmpty
              ? Center(
                  child: Image.asset(
                  MyImages.noDataFound,
                  height: Dimensions.space300,
                ))
              : ListView.builder(
                  itemCount: controller.productList.length,
                  itemBuilder: (context, index) {
                    ProductModel product = controller.productList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal:  Dimensions.space10,vertical: Dimensions.space5),
                      child: CustomCard( width: double.infinity,
                          child: ListTile(
                            title: Text(product.name ?? ""),
                            subtitle: Text('${MyStrings.price} ${product.price}'),
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
                              //controller.showAddToCartBottomSheet(product, context, index);
                            },
                            trailing: InkWell(
                              onTap: () {
                                controller.showAddToCartAlertDialogue(product, context, index);
                              },
                              child: Container(
                              
                                padding:const EdgeInsets.all(Dimensions.space5),
                                decoration:const BoxDecoration(color: MyColor.primaryColor,borderRadius: BorderRadius.all(Radius.circular(20))),
                                child: Text(MyStrings.addTOCart,style: regularLarge.copyWith(color: MyColor.colorWhite),)),
                            ),
                          )),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
