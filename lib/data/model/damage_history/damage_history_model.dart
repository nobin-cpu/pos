class DamageHistoryItem {
  final int? id;
  final int? damageID;
  final String creationTime;
  final String ? damageReason;

  DamageHistoryItem({
    required this.id,
    required this.damageID,
    required this.creationTime,
    this.damageReason,
  });

  factory DamageHistoryItem.fromJson(Map<String, dynamic> json) {
    return DamageHistoryItem(
      id: json['id'],
      damageID: json['damageID'],
      creationTime: json['creationTime'],
      damageReason: json['damageReason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'damageID': damageID,
      'creationTime': creationTime,
      'damageReason': damageReason,
    };
  }
}
