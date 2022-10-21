class SourceIncidentEnvModel {
  int? idSource;
  String? source;

  SourceIncidentEnvModel({this.idSource, this.source});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'idSource' : idSource,
      'source' : source
    };
    return map;
  }

  bool isEqual(SourceIncidentEnvModel? model) {
    return this.idSource == model?.idSource;
  }
}