class CartProductModel {
  int ?id;
  int ?productId;
  String ?name;
  String ?price;
  String ?category;
  String ?uom;
  String ?imagePath;
  int? quantity;
  double ?totalAmount;

  CartProductModel({
    this.id,
    this.productId,
    this.name,
    this.price,
    this.category,
    this.uom,
    this.imagePath,
    this.quantity,
    this.totalAmount,
  });

  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'price': price,
      'category': category,
      'uom': uom,
      'imagePath': imagePath,
      'quantity': quantity,
      'totalAmount': totalAmount,
    };
  }

  
  factory CartProductModel.fromMap(Map<String, dynamic> map) {
    return CartProductModel(
      id: map['id'],
      productId: map['productId'],
      name: map['name'],
      price: map['price'],
      category: map['category'],
      uom: map['uom'],
      imagePath: map['imagePath'],
      quantity: map['quantity'],
      totalAmount: map['totalAmount'],
    );
  }
}
