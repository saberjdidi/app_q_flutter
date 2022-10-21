class EmployeModel {
  String? mat;
  String? nompre;

  EmployeModel({this.mat, this.nompre});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'mat' : mat,
      'nompre' : nompre
    };
    return map;
  }

  bool isEqual(EmployeModel? model) {
    return this.mat == model?.mat;
  }
}