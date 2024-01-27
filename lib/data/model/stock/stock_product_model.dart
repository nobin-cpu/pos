class StockProductModel {
  final int ? id;
  final String ?title;

  StockProductModel({this.id, this.title});

  factory StockProductModel.fromMap(Map<String, dynamic> map) {
    return StockProductModel(
      id: map['id'],
      title: map['title'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }
}
