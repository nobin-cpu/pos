class ConfirmCheckoutModel {
  int ?id;
  int ?productId;
  String ?name;
  String ?price;
  String ?category;
  String ?uom;
  String ?imagePath;
  int? quantity;
  double ?totalAmount;
  double ?discountAmount;
  int ?isDiscountInPercent;

  ConfirmCheckoutModel({
    this.id,
    this.productId,
    this.name,
    this.price,
    this.category,
    this.uom,
    this.imagePath,
    this.quantity,
    this.totalAmount,
    this.discountAmount,
    this.isDiscountInPercent,
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
      'discountAmount': discountAmount,
      'isDiscountInPercent': isDiscountInPercent,
    };
  }

  
  factory ConfirmCheckoutModel.fromMap(Map<String, dynamic> map) {
    return ConfirmCheckoutModel(
      id: map['id'],
      productId: map['productId'],
      name: map['name'],
      price: map['price'],
      category: map['category'],
      uom: map['uom'],
      imagePath: map['imagePath'],
      quantity: map['quantity'],
      totalAmount: map['totalAmount'],
      discountAmount: map['discountAmount'],
      isDiscountInPercent: map['isDiscountInPercent'],
    );
  }
}
