class UomModel {
  final int ? id;
  final String ?title;

  UomModel({this.id, this.title});

  factory UomModel.fromMap(Map<String, dynamic> map) {
    return UomModel(
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
