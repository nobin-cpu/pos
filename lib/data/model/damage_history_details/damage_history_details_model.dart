class DamageDetailItem {
  final int id;
  final int damageID;
  final String creationTime;
  final String productName;
  final int quantity;
   final String ?damageReason;

  DamageDetailItem({
    required this.id,
    required this.damageID,
    required this.creationTime,
    required this.productName,
    required this.quantity,
    this.damageReason,
  });

  factory DamageDetailItem.fromJson(Map<String, dynamic> json) {
    return DamageDetailItem(
      id: json['id'],
      damageID: json['damageID'],
      creationTime: json['creationTime'],
      productName: json['productName'],
      quantity: json['quantity'],
      damageReason: json['damageReason'],
    );
  }
}
