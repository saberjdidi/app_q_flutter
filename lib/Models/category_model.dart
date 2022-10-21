class CategoryModel {
  int? idCategorie;
  String? categorie;

  CategoryModel({this.idCategorie, this.categorie});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'idCategorie' : idCategorie,
      'categorie' : categorie
    };
    return map;
  }

  bool isEqual(CategoryModel? model) {
    return this.idCategorie == model?.idCategorie;
  }
}