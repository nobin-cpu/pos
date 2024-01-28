class DamageHistoryItem {
  final int? id;
  final int? damageID;
  final String creationTime;

  DamageHistoryItem({
    required this.id,
    required this.damageID,
    required this.creationTime,
  });

  factory DamageHistoryItem.fromJson(Map<String, dynamic> json) {
    return DamageHistoryItem(
      id: json['id'],
      damageID: json['damageID'],
      creationTime: json['creationTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'damageID': damageID,
      'creationTime': creationTime,
    };
  }
}
