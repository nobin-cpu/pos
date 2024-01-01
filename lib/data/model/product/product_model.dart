class ProductModel {
  final int id;
  final String? price;
  final String? name;
  final String ?category;
  final String? uom;
  final String ?imagePath;
  final String ?stock;
  final String ?wholesalePrice;
  final String ?mrp;
  final String ?purchasePrice;

  ProductModel( {
     required this.id,
     this.price,
     this.name,
     this.category,
     this.uom,
     this.imagePath,
     this.stock, this.wholesalePrice, this.mrp, this.purchasePrice,
  });

  // Factory method to create a ProductModel instance from a map
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
     
      
      price: map['price'],
      name: map['name'],
      category: map['category'],
      uom: map['uom'],
      imagePath: map['imagePath'],
       stock: map['stock'],
      wholesalePrice: map['wholesalePrice'],
      mrp: map['mrp'],
      purchasePrice: map['purchasePrice'],
    );
  }
}