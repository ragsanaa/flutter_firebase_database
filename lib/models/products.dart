class Products {
  String? id;
  String? name;
  String? imgPath;
  bool? purchased;

  Products({this.name, this.purchased = false, this.imgPath});

  Products.fromJson(this.id, Map<String, dynamic> json) {
    name = json['name'];
    purchased = json['purchased'];
    imgPath = json['imgPath'];
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'purchased': purchased, 'imgPath': imgPath};
  }

  Products copyWith({String? name, bool? purchased, String? imgPath}) {
    return Products(
        name: name ?? this.name,
        purchased: purchased ?? this.purchased,
        imgPath: imgPath ?? this.imgPath);
  }
}
