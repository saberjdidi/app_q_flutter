class IncidentSecuriteAgendaModel {
  int? ref;
  String? designation;
  String? dateInc;
  String? idSite;
  int? idProcessus;

  IncidentSecuriteAgendaModel({
    this.ref,
    this.designation,
    this.dateInc,
    this.idSite,
    this.idProcessus
  });

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'ref' : ref,
      'designation' : designation,
      'dateInc' : dateInc
    };
    return map;
  }

  bool isEqual(IncidentSecuriteAgendaModel? model) {
    return this.ref == model?.ref;
  }
}