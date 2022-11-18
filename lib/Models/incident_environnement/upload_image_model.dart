class UploadImageModel {
  int? idPiece;
  int? idFiche;
  String? image;
  String? fileName;

  UploadImageModel({this.idPiece, this.idFiche, this.image, this.fileName});

  Map<String, dynamic> dataMap() {
    var map = <String, dynamic>{
      'idFiche': idFiche,
      'image': image,
      'fileName': fileName
    };
    return map;
  }

  UploadImageModel.fromDBLocal(Map<String, dynamic> json) {
    idFiche = json['idFiche'];
    image = json['image'];
    fileName = json['fileName'];
  }

  bool isEqual(UploadImageModel? model) {
    return this.idFiche == model?.idFiche;
  }
}
