class ServiceModel {
  int? codeService;
  String? service;
  int? codeDirection;
  String? direction;
  String? module;
  String? fiche;

  ServiceModel({
    this.codeService,
    this.service,
    this.codeDirection,
    //this.direction,
    this.module,
    this.fiche,
  });

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'codeService' : codeService,
      'service' : service,
      'codeDirection' : codeDirection,
      //'direction' : direction,
      'module' : module,
      'fiche' : fiche
    };
    return map;
  }

  bool isEqual(ServiceModel? model) {
    return this.codeService == model?.codeService;
  }
}