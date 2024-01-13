class InvoiceProductModel {
  int? id;
  int? transectionId;
  int? productId;
  String? name;
  String? price;
  String? category;
  String? uom;
  String? imagePath;
  int? quantity;
  String? totalAmount;
  String? discountAmount;
  int? isDiscountInPercent;
  String? dateTime;

  InvoiceProductModel({
    this.id,
    this.transectionId,
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
    this.dateTime
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoiceId': transectionId,
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
      'checkoutTime': dateTime,
    };
  }

  factory InvoiceProductModel.fromMap(Map<String, dynamic> map) {
    return InvoiceProductModel(
      id: map['id'],
      transectionId: map['invoiceId'],
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
      dateTime: map['checkoutTime'],
    );
  }
}
