import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/model/category/category_model.dart';
import 'package:flutter_prime/view/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:flutter_prime/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutter_prime/view/screens/category/widgets/add_category_bottom_sheet.dart';
import 'package:flutter_prime/view/screens/category/widgets/edit_category_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CategoryController extends GetxController {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final TextEditingController categoryController = TextEditingController();
  TextEditingController editController = TextEditingController();
  List<CategoryModel> catagoryData = [];
  File? pickedImage;
  String categoryTitle = "";
  File? newPickedImage;

  void showAddCategoryBottomSheet(BuildContext context) {
    clearPickedImage();
    update();
    CustomBottomSheet(child: const AddCategoryBottomSheet()).customBottomSheet(context);
  }

  Future<void> getCategoryList() async {
    await databaseHelper.initializeDatabase();
    catagoryData = await databaseHelper.getCategoryList();
    update();
  }

  void initData() {
    getCategoryList();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      pickedImage = File(pickedFile.path);
      // newPickedImage = pickedImage;
      update();
    }
  }

  void clearPickedImage() {
    pickedImage = null;
    update();
  }

  void editCategoryDetailsBottomSheet(CategoryModel categoryModel, BuildContext context) {
    editController.text = categoryModel.title ?? "";
    pickedImage = File(categoryModel.image.toString());
    CustomBottomSheet(
      child: EditCategoryBottomSheet(id: categoryModel.id),
    ).customBottomSheet(context);
  }

  editCategoryData(int id) async {
    print("this is image path from controller ${pickedImage!.path}");
    CategoryModel newCategory = CategoryModel(title: editController.text, id: id, image: pickedImage!.path);
    await databaseHelper.updateCategories(newCategory);
    await getCategoryList();
    categoryController.clear();
    update();

    Get.back();

    CustomSnackBar.success(successList: [MyStrings.categoryUpdatedSuccessfully]);
  }

  Future<void> deleteCategory(int id) async {
    try {
      await databaseHelper.initializeDatabase();
      await databaseHelper.deleteCategory(id);
      await getCategoryList();
    } catch (e) {
      print('Error deleting UOM: $e');
    }
  }

  addCategory() async {
    if (!databaseHelper.isDatabaseInitialized()) {
      await databaseHelper.initializeDatabase();
    }

    if (categoryController.text.isNotEmpty && pickedImage != null) {
      try {
        print("this is picked image from add category controller ${pickedImage!.path}");
        await databaseHelper.insertCategory(categoryController.text, pickedImage!.path);
        categoryController.clear();
        Get.back();
        CustomSnackBar.success(successList: [MyStrings.categoryAddedSuccessfully]);
        await getCategoryList();
      } catch (e) {
        print('Error adding category: $e');
        CustomSnackBar.error(errorList: [MyStrings.errorAddingCategory]);
      }
    } else {
      CustomSnackBar.error(errorList: [MyStrings.fillAllRequiredFields]);
    }

    update();
  }
}
