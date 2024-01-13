class ProductModel {
  final int? id;
  final String? price;
  final String? totalPrice;
  final String? name;
  final String ?category;
  final String? uom;
  final String ?imagePath;
  final String ?stock;
  final String ?wholesalePrice;
  final String ?mrp;
  final String ?purchasePrice;
  final String ?retailPrice;

  ProductModel({
      this.id,
     this.price,
     this.totalPrice,
     this.name,
     this.category,
     this.uom,
     this.imagePath,
     this.stock, this.wholesalePrice, this.mrp, this.purchasePrice,this.retailPrice,
  });

  // Factory method to create a ProductModel instance from a map
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      price: map['price'],
      totalPrice: map['totalPrice'],
      name: map['name'],
      category: map['category'],
      uom: map['uom'],
      imagePath: map['imagePath'],
       stock: map['stock'],
      wholesalePrice: map['wholesalePrice'],
      mrp: map['mrp'],
      purchasePrice: map['purchasePrice'],
      retailPrice: map['retailPrice'],
    );
  }
}
