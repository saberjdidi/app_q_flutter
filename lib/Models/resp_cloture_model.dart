class RespClotureModel {

  String? mat;
  int? codeSite;
  int? codeProcessus;
  String? nompre;
  String? site;
  String? processus;

  RespClotureModel(
      {this.mat,
        this.codeSite,
        this.codeProcessus,
        this.nompre,
        this.site,
        this.processus});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'mat' : mat,
      'codeSite' : codeSite,
      'codeProcessus' : codeProcessus,
      'nompre' : nompre,
      'site' : site,
      'processus' : processus
    };
    return map;
  }

  bool isEqual(RespClotureModel? model) {
    return this.mat == model?.mat;
  }
}