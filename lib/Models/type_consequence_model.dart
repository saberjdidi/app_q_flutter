class TypeConsequenceModel {
  int? idTypeConseq;
  String? typeConseq;

  TypeConsequenceModel({
    this.idTypeConseq,
    this.typeConseq
  });

  Map<String, dynamic> dataMapIncidentEnv(){
    var map = <String, dynamic>{
      'idTypeConseq' : idTypeConseq,
      'typeConseq' : typeConseq
    };
    return map;
  }

  bool isEqual(TypeConsequenceModel? model) {
    return this.idTypeConseq == model?.idTypeConseq;
  }
}