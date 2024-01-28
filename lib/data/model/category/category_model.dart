class CategoryModel {
  final int ? id;
 final String ?title;
 final String ?image;

  CategoryModel( {this.id, this.title,this.image,});

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      title: map['title'],
      image: map['imagePath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imagePath': image,
    };
  }
}
