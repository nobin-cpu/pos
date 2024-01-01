import 'dart:io';

class ProductEditModel {
  final String name;
  final File? pickedImage;
  final String category;
  final String uom;
  final int id;

  ProductEditModel({
    required this.name,
    required this.pickedImage,
    required this.category,
    required this.uom,
    required this.id,
  });
}
