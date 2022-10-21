class ProcessusEmployeModel {
  int? codeProcessus;
  String? processus;
  String? mat;

  ProcessusEmployeModel({this.codeProcessus, this.processus, this.mat});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'codeProcessus' : codeProcessus,
      'processus' : processus,
      'mat' : mat
    };
    return map;
  }

  bool isEqual(ProcessusEmployeModel? model) {
    return this.codeProcessus == model?.codeProcessus;
  }
}