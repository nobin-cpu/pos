class CustomerModel {
  final int id;
  final String name;
  final String address;
  final String phNo;
  final String post;

  CustomerModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phNo,
    required this.post,
  });

  // Convert Product object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phNo': phNo,
      'post': post,
    };
  }

factory CustomerModel.fromMap(Map<String, dynamic> map) {
  return CustomerModel(
    id: map['id'],
    name: map['name'],
    address: map['address'],
    phNo: map['phNo'],
    post: map['post'],
  );
}

}
