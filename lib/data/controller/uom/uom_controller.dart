import 'package:flutter/material.dart';
import 'package:flutter_prime/core/helper/sqflite_database.dart';
import 'package:flutter_prime/data/model/uom/uom_model.dart';
import 'package:flutter_prime/view/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:flutter_prime/view/screens/uom/widgets/add_uom_bottom_sheet.dart';
import 'package:flutter_prime/view/screens/uom/widgets/edit_uom_details_sheet.dart';
import 'package:get/get.dart';

class UomController extends GetxController {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final TextEditingController uomController = TextEditingController();
  String uomTitle = "";
  List<UomModel> uomData = [];
  TextEditingController editController = TextEditingController();

  void showAddUomBottomSheet(BuildContext context, ) {
    
    CustomBottomSheet(
      child: AddUomBottomSheet(),
    ).customBottomSheet(context);
  }

  void showUomDetails(UomModel uom, BuildContext context) {
    editController.text = uom.title??"";
    CustomBottomSheet(
        child: EditUomBottomSheet(
      id: uom.id,
    )).customBottomSheet(context);
  }

  Future<void> editUom(
    UomModel uom,
  ) async {
    try {
      await databaseHelper.initializeDatabase();
      await databaseHelper.updateUom(uom);

      await getUomList();
    } catch (e) {
      print('Error editing UOM: $e');
    }
  }

  Future<void> deleteUom(int id) async {
    try {
      await databaseHelper.initializeDatabase();
      await databaseHelper.deleteUom(id);
      await getUomList();
    } catch (e) {
      print('Error deleting UOM: $e');
    }
  }

  Future<void> getUomList() async {
    await databaseHelper.initializeDatabase();
    uomData = await databaseHelper.getUomList();
    update();
  }
  saveUom() async {
    UomModel newUom = UomModel(title: uomController.text);

    await databaseHelper.insertUom(newUom);

    await getUomList();

    uomController.clear();
    Get.back();
  }
  editUomData(int id)async{
    UomModel newUom = UomModel( title: editController.text , id:id ); 
                    await databaseHelper.updateUom(newUom); 
                    await getUomList();
                     uomController.clear();
                    update();
                    Get.back();
  }

  void initData() {
    getUomList();
  }
}
