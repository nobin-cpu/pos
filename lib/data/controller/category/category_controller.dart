import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/model/category/category_model.dart';
import 'package:flutter_prime/view/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:flutter_prime/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutter_prime/view/screens/category/widgets/add_category_bottom_sheet.dart';
import 'package:flutter_prime/view/screens/category/widgets/edit_category_bottom_sheet.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final TextEditingController categoryController = TextEditingController();
  TextEditingController editController = TextEditingController();
  List<CategoryModel> catagoryData = [];
  String categoryTitle = "";

  void showAddCategoryBottomSheet(BuildContext context) {
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

  void editCategoryDetails(CategoryModel categoryModel, BuildContext context) {
    editController.text = categoryModel.title ?? "";

    CustomBottomSheet(
      child: EditCategoryBottomSheet(id: categoryModel.id),
    ).customBottomSheet(context);
  }

  editCategoryData(int id) async {
    CategoryModel newCategory = CategoryModel(title: editController.text, id: id);
    await databaseHelper.updateCategories(newCategory);
    await getCategoryList();
    categoryController.clear();
    update();
    Get.back();
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

  addCategory() {
    categoryController.text != "" ? databaseHelper.insertCategory(categoryController.text) : CustomSnackBar.error(errorList: [MyStrings.pleaseAddAnUnit]);
    categoryController.clear();
    Get.back();
    getCategoryList();
    update();
  }
}
