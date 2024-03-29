import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/model/category/category_model.dart';
import 'package:flutter_prime/data/model/product/product_model.dart';
import 'package:flutter_prime/data/model/uom/uom_model.dart';
import 'package:flutter_prime/view/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:flutter_prime/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutter_prime/view/screens/product/widgets/add_product_bottom_sheet.dart';
import 'package:flutter_prime/view/screens/product/widgets/edit_or_delete_product_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProductController extends GetxController {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController uomController = TextEditingController();
  final TextEditingController stocksController = TextEditingController();
  final TextEditingController wholesaleController = TextEditingController();
  final TextEditingController mrpController = TextEditingController();
  final TextEditingController purchasePriceController = TextEditingController();
  TextEditingController newNameController = TextEditingController();
  TextEditingController newPriceController = TextEditingController();
  TextEditingController newStockController = TextEditingController();
  TextEditingController newWholesalePriceController = TextEditingController();
  TextEditingController newpurchasePriceController = TextEditingController();
  List<CategoryModel> categoryList = [];
  List<UomModel> uomList = [];
  List<ProductModel> productList = [];
  File? pickedImage;
  File? newPickedImage;
  String newCategory = '';
  String newUom = '';
  String selectedCategory = '';
  bool loading = false;
  @override
  void onInit() {
    super.onInit();
  }

  Future<void> loadDropdownData() async {
    try {
      await databaseHelper.initializeDatabase();

      List<UomModel> uomData = await databaseHelper.getUomList();
      List<CategoryModel> categoryData = await databaseHelper.getCategoryList();

      categoryList.add(CategoryModel(title: MyStrings.selectOne, id: -1));
      categoryList.addAll(categoryData);
      uomList.add(UomModel(title: MyStrings.selectOne, id: -1));
      uomList.addAll(uomData);
  
      update();
    } catch (e) {
      print('Error loading dropdown data: $e');
    }
  }

  Future<void> initializeData() async {
    loading = true;
    update();
    await loadDatabase();
    await loadDropdownData();
    await getProductList();
     loading = false;
    update();
    print("Category List: ${categoryList}");
    print("UOM List: ${uomList}");
  }

  Future<void> loadDatabase() async {
    try {
      await databaseHelper.initializeDatabase();
      update();
    } catch (e) {
      print('Error loading saved text: $e');
    }
  }

  Future<void> getProductList() async {
    await databaseHelper.initializeDatabase();
    productList = await databaseHelper.getProductList();
    update();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      pickedImage = File(pickedFile.path);
      newPickedImage = pickedImage;
      update();
    }
  }

  void showAddProductBottomSheet(BuildContext context) {
    CustomBottomSheet(child: const AddProductBottomSheet()).customBottomSheet(context);
  }

  void showEditOrDeleteBottomSheet(BuildContext context, ProductModel productModel) {
    newNameController.text = productModel.name ?? "";
    newPriceController.text = productModel.price ?? "";
    newStockController.text = productModel.stock ?? "";
    newWholesalePriceController.text = productModel.wholesalePrice ?? "";
    newpurchasePriceController.text = productModel.purchasePrice ?? "";
    newPickedImage = File(productModel.imagePath ?? "");
    newCategory = productModel.category ?? "";
    newUom = productModel.uom ?? "";

 
    CustomBottomSheet(
      child: EditOrDeleteProductBottomSheet(
        id: productModel.id??0,
      ),
    ).customBottomSheet(context);
  }

  Future<void> updateProduct(int id, String newName, String price, String newCategory, String newUom, String newImagePath, String newStocks, String newWholeSalePrice, String newPurchasePrice) async {
    await databaseHelper.updateProduct(id, newName, price, newCategory, newUom, newImagePath, newStocks, newWholeSalePrice, newPurchasePrice);
    await getProductList();
    update();
  }

  Future<void> deleteProduct(int id) async {
    await databaseHelper.deleteProduct(id);
    await getProductList();
    update();
  }

  editProduct(int id, String name, image) async {
    await updateProduct(
      id,
      newNameController.text.isNotEmpty ? newNameController.text : name,
      newPriceController.text.isNotEmpty ? newPriceController.text : "",
      newCategory,
      newUom,
      newPickedImage != null ? newPickedImage!.path : image,
      newStockController.text.isNotEmpty ? newStockController.text : "",
      newWholesalePriceController.text.isNotEmpty ? newWholesalePriceController.text : "",
      newpurchasePriceController.text.isNotEmpty ? newpurchasePriceController.text : "",
    );
    update();
  }

  addProducts() async {
    if (pickedImage == null) {
      print("image not provided");
      return;
    }

    await databaseHelper.insertProduct(productNameController.text, priceController.text, categoryController.text, uomController.text, pickedImage!.path, stocksController.text, wholesaleController.text, mrpController.text, purchasePriceController.text);
   
    
    getProductList();
    claerField();
    update();
     Get.back();
      await  CustomSnackBar.success(successList: [MyStrings.productAddedSuccessfully]);
    
  }

  claerField() {
     
    productNameController.clear();
    priceController.clear();
    categoryController.clear();
    uomController.clear();
    stocksController.clear();
    wholesaleController.clear();
    purchasePriceController.clear();
    pickedImage = null;
    newPickedImage = null;
   
    update();
  }
}
